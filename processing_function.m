function s_out = processing_function(s)
% This function processes the data in 's', appends this in the data
%  structure, outputs it as 's_out' and saves the structure to a .mat file.
%
% If a processed file already exists, this function loads the processed
%  data and outputs it as 's_out'.


% find a processed file, or process raw data
label = s.label;
if exist([label '.mat'],'file')
    load_data = 1;
else
    load_data = 0;
end


%% ----- LOAD OR PROCESS
if load_data
    %% ----- PROCESSED DATA LOADING ---------------------------------------
    load([label '.mat'])
else
    %% ----- RAW DATA LOADING ---------------------------------------------

    % ---------------------------------------------------------------------
    % Get measured data from structure
    % 

    displacement             = s.displ;
    mean_measured_inductance = s.m_L;
    std_measured_inductance  = s.s_L;
    measured_inductance      = s.L;

    % discard measurement at free length (first element)
    bi                       = 2:length(mean_measured_inductance);
    displacement             = displacement(bi);
    mean_measured_inductance = mean_measured_inductance(bi);
    std_measured_inductance  = std_measured_inductance(bi);
    measured_inductance      = measured_inductance(bi,:);

    Lc                       = s.Lc + displacement; % spring length
    mean_measured_inductance = mean_measured_inductance*1e6; % inductance in microhenry
    std_measured_inductance  = std_measured_inductance*1e6;
    measured_inductance      = measured_inductance*1e6;

    %% ----- FITTING ------------------------------------------------------

    % ---------------------------------------------------------------------
    % Define fit functions
    % 
    L_fit_fnc   = @(l,a,b) 1./l.*a+b;
    iL_fit_fnc  = @(L,a,b) a./(L-b);

    % -------------------------------------------------------------------------
    % Determine least squares fit parameters (backslash = function)
    %
    
    % determine the fit for all Sx_01 sets
    if isempty(strfind(label,'S1'))||(~isempty(strfind(label,'S1'))&&~isempty(strfind(label,'_01')))
        iLc = 1./(Lc([1,end])); I_fit_pts = mean_measured_inductance([1,end]); % based on two points (first and last)
        % iLc = 1./(Lc);          I_fit_pts = measured_inductance;          % based on all points
        A        = [iLc, ones(size(iLc))];
        p        = A\I_fit_pts; 
        alpha    = p(1); 
        beta     = p(2);
    else
    % the remaining sets for S1: use the fit from the S1_01 set
        if ~exist(['S1_01.mat'],'file')
            springs
            assign_data
            s_tmp    = get_spring(spring,'S1_01');  
            sout_tmp = processing_function(s_tmp);
        end
        load('S1_01.mat')
        alpha    = s_out.alpha;
        beta     = s_out.beta;
        clear s_out
    end
    
    % predicted displacement, given the measured inductance
    mean_L_fit  = iL_fit_fnc(mean_measured_inductance,alpha,beta);
    mean_dL_fit = (mean_L_fit - s.Lc); % length to displacement
    
    L_fit  = iL_fit_fnc(measured_inductance,alpha,beta);
    dL_fit = (L_fit - s.Lc); % length to displacement
    %% ----- THEORETICAL LINES ------------------------------------------------

    % Theoretical given displacements
    Lc_th    = s.Lc*linspace(1,1.55,25);
    displ_th = Lc_th - s.Lc;

    % calculate theoretical inductance
    for nn = 1:length(Lc_th)
        I_ht(nn)  = L_neumann_helix(s,Lc_th(nn),1)*1e6;
        I_rt(nn)  = L_rosa_w(s,Lc_th(nn))*1e6;
        I_bt(nn)  = L_basic(s,Lc_th(nn))*1e6;
        I_nt(nn)  = L_nagaoka(s,Lc_th(nn))*1e6;
        I_mt(nn)  = L_maxwell(s,Lc_th(nn))*1e6;
        I_ft(nn)  = L_fit_fnc(Lc_th(nn),alpha,beta);
    end

    %% ----- DATA PROCESSING --------------------------------------------------

    % -------------------------------------------------------------------------
    % Calculate predicted values of inductance according to theories, 
    % given a (measured) displacement
    %

    % preallocation
    predicted_helix   = zeros(length(displacement),1);
    predicted_rosa    = predicted_helix;
    predicted_nagaoka = predicted_helix;
    predicted_maxwell = predicted_helix;
    predicted_basic   = predicted_helix;
    predicted_fit     = predicted_helix;

    % calculate
    lmeas  = length(displacement);
    for nn = 1:lmeas;
        predicted_basic(nn)   = L_basic(s,Lc(nn))*1e6;
        predicted_nagaoka(nn) = L_nagaoka(s,Lc(nn))*1e6;
        predicted_rosa(nn)    = L_rosa_w(s,Lc(nn))*1e6;
        predicted_maxwell(nn) = L_maxwell(s,Lc(nn))*1e6;
        predicted_helix(nn)   = L_neumann_helix(s,Lc(nn),1)*1e6;
        predicted_fit(nn)     = L_fit_fnc(Lc(nn),alpha,beta);
    end

    % -------------------------------------------------------------------------
    % Determine displacement given a measured inductance, via theories/fit
    % using interpolation
    %
    
    % for means of measurements
    mean_dL_basic   = interp1(I_bt,displ_th,mean_measured_inductance,'linear','extrap');
    mean_dL_nagaoka = interp1(I_nt,displ_th,mean_measured_inductance,'linear','extrap');
    mean_dL_rosa    = interp1(I_rt,displ_th,mean_measured_inductance,'linear','extrap');
    mean_dL_maxwell = interp1(I_mt,displ_th,mean_measured_inductance,'linear','extrap');
    mean_dL_helix   = interp1(I_ht,displ_th,mean_measured_inductance,'linear','extrap');
    
    % for all measurements
    dL_basic   = interp1(I_bt,displ_th,measured_inductance,'linear','extrap');
    dL_nagaoka = interp1(I_nt,displ_th,measured_inductance,'linear','extrap');
    dL_rosa    = interp1(I_rt,displ_th,measured_inductance,'linear','extrap');
    dL_maxwell = interp1(I_mt,displ_th,measured_inductance,'linear','extrap');
    dL_helix   = interp1(I_ht,displ_th,measured_inductance,'linear','extrap');

    % -------------------------------------------------------------------------
    % Determine quality of relations
    %

    % R2    (how close is the theoretical inductance characteristic to the measured)
    R2_basic    = calcR2(mean_measured_inductance,predicted_basic);
    R2_nagaoka  = calcR2(mean_measured_inductance,predicted_nagaoka);
    R2_rosa     = calcR2(mean_measured_inductance,predicted_rosa);
    R2_maxwell  = calcR2(mean_measured_inductance,predicted_maxwell);
    R2_helix    = calcR2(mean_measured_inductance,predicted_helix);
    R2_fit      = calcR2(mean_measured_inductance,predicted_fit);
    
    % RMSE  (how well can the different theories and the fit predict displacement)
    RMSE_dL_basic   = rmse(displacement,mean_dL_basic)./range(displacement);
    RMSE_dL_nagaoka = rmse(displacement,mean_dL_nagaoka)./range(displacement);
    RMSE_dL_rosa    = rmse(displacement,mean_dL_rosa)./range(displacement);
    RMSE_dL_maxwell = rmse(displacement,mean_dL_maxwell)./range(displacement);
    RMSE_dL_helix   = rmse(displacement,mean_dL_helix)./range(displacement);
    RMSE_dL_basef   = rmse(displacement,mean_dL_fit)./range(displacement);

    %% ----- OUTPUT STRUCTURE -------------------------------------------------

    % spring data
    s_out.spring = s;

    % fit
    s_out.alpha = alpha;
    s_out.beta  = beta;

    % theoretical data
    s_out.th_displ   = displ_th;
    s_out.th_I_basic = I_bt;
    s_out.th_I_naga  = I_nt;
    s_out.th_I_rosa  = I_rt;
    s_out.th_I_maxw  = I_mt;
    s_out.th_I_helix = I_ht;
    s_out.th_I_fit   = I_ft;

    % measured data
    s_out.m_mean_I  = mean_measured_inductance;
    s_out.m_std_I   = std_measured_inductance;
    s_out.m_I       = measured_inductance;
    s_out.m_displ   = displacement;
    s_out.m_Lc      = Lc;

    % predicted inductance, given measured displacement (based on theory)
    s_out.pr_I_basic = predicted_basic;
    s_out.pr_I_naga  = predicted_nagaoka;
    s_out.pr_I_rosa  = predicted_rosa;
    s_out.pr_I_maxw  = predicted_maxwell;
    s_out.pr_I_helix = predicted_helix;
    s_out.pr_I_fit   = predicted_fit;

    % predicted mean displacement, given mean measured inductance (based on theory)
    s_out.pr_m_displ_basic = mean_dL_basic;
    s_out.pr_m_displ_naga  = mean_dL_nagaoka;
    s_out.pr_m_displ_rosa  = mean_dL_rosa;
    s_out.pr_m_displ_maxw  = mean_dL_maxwell;
    s_out.pr_m_displ_helix = mean_dL_helix;
    s_out.pr_m_displ_fit   = mean_dL_fit;
    
    % predicted displacement, given measured inductance
    s_out.pr_displ_basic = dL_basic;
    s_out.pr_displ_naga  = dL_nagaoka;
    s_out.pr_displ_rosa  = dL_rosa;
    s_out.pr_displ_maxw  = dL_maxwell;
    s_out.pr_displ_helix = dL_helix;
    s_out.pr_displ_fit   = dL_fit;

    % quality measures
    s_out.RMSE_displ.basic = RMSE_dL_basic;
    s_out.RMSE_displ.naga  = RMSE_dL_nagaoka;
    s_out.RMSE_displ.rosa  = RMSE_dL_rosa;
    s_out.RMSE_displ.maxw  = RMSE_dL_maxwell;
    s_out.RMSE_displ.helix = RMSE_dL_helix;
    s_out.RMSE_displ.fit   = RMSE_dL_basef;

    s_out.R2_I.basic = R2_basic;
    s_out.R2_I.naga  = R2_nagaoka;
    s_out.R2_I.rosa  = R2_rosa;
    s_out.R2_I.maxw  = R2_maxwell;
    s_out.R2_I.helix = R2_helix;
    s_out.R2_I.fit   = R2_fit;


    %% ----- SAVE PROCESSED DATA TO FILE --------------------------------------
    cd('./processed_data')
    save(label,'s_out')
    cd('..')
end

end
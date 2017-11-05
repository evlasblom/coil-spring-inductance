function data = repeated_series_visualization(which)

% assumes Rx_01 is used to fit, others are used to validate fit


% find available processed data for the repeated series 'which'
datalist=dir('processed_data');
data_names = [];
for nn = 1:size(datalist,1)
    cur_name = datalist(nn).name;
    if strfind(cur_name,which)
        data_names{end+1} = cur_name;
    end
end
% load data into data{}
for nn = 1:size(data_names,2)
    cur_name      = data_names{nn};
    load(cur_name)
    data{nn}.name = cur_name;
    data{nn}.s    = s_out;
end

% %% ------ Combine all points --------------------------------------
% % use all individually processed data points instead of the means (take means after processing)
% m_measured_displacement    =  data{1}.s.m_displ*1000; % same for every series
% 
% predicted_displacement     = [data{1}.s.pr_displ_fit,data{2}.s.pr_displ_fit,...
%                               data{3}.s.pr_displ_fit,data{4}.s.pr_displ_fit,...
%                               data{5}.s.pr_displ_fit]*1000;
% m_predicted_displacement   = mean(predicted_displacement,2);
% std_predicted_displacement = std(predicted_displacement,[],2);
% 
% m_inductance               = [data{1}.s.m_I,data{2}.s.m_I,...
%                               data{3}.s.m_I,data{4}.s.m_I,...
%                               data{5}.s.m_I]*1000;
% std_inductance             = std(m_inductance,[],2);

%% ------ Combine means --------------------------------------
% use processed means of data points (take means before processing)
m_measured_displacement    =  data{1}.s.m_displ*1000; % same for every series

predicted_displacement     = [data{1}.s.pr_m_displ_fit,data{2}.s.pr_m_displ_fit,...
                              data{3}.s.pr_m_displ_fit,data{4}.s.pr_m_displ_fit,...
                              data{5}.s.pr_m_displ_fit]*1000;
m_predicted_displacement   = mean(predicted_displacement,2);
std_predicted_displacement = std(predicted_displacement,[],2);


m_inductance               = [data{1}.s.m_mean_I,data{2}.s.m_mean_I,...
                              data{3}.s.m_mean_I,data{4}.s.m_mean_I,...
                              data{5}.s.m_mean_I]*1000;
std_inductance             = std(m_inductance,[],2);

%% Statistics on repeated series

rmse_all = [];
r2_all   = [];
for nn = 1:length(data)
    rmse_all = [rmse_all; 
                [data{nn}.s.RMSE_displ.basic,...
                 data{nn}.s.RMSE_displ.naga,...
                 data{nn}.s.RMSE_displ.rosa,...
                 data{nn}.s.RMSE_displ.maxw,...
                 data{nn}.s.RMSE_displ.helix,...
                 data{nn}.s.RMSE_displ.fit] ...
                 ];

    r2_all = [r2_all; 
                [data{nn}.s.R2_I.basic,...
                 data{nn}.s.R2_I.naga,...
                 data{nn}.s.R2_I.rosa,...
                 data{nn}.s.R2_I.maxw,...
                 data{nn}.s.R2_I.helix,...
                 data{nn}.s.R2_I.fit] ...
                 ];
end
rmse_mean = mean(rmse_all,1); % mean RMSE of repeated series
rmse_std  = std(rmse_all,1);  % std on RMSE of repeated series

r2_mean = mean(r2_all,1);     % mean R2 of repeated series
r2_std  = std(r2_all,1);      % std on R2 of repeated series

%% Plot prediction power of fit for a repeated series
f1=figure;
    
    % plot data points
    p1=plot(m_measured_displacement,m_measured_displacement);hold on
    p6=plot(m_measured_displacement,predicted_displacement);
    p5=plot(m_measured_displacement([1,end]),predicted_displacement([1,end],1));
    
    % set axes properties
    axx     = gca;
    limits  = [axx.XLim,axx.YLim];
    md_step = m_measured_displacement(2)-m_measured_displacement(1);
    limits(2)=limits(2)+md_step;
    limits(4)=limits(4)+md_step;
    grid
    axis(limits)
    s_font = 15;
    set(axx,'fontsize',s_font)
    
    % style plot
    set(p1,'color','r','linestyle','-','marker','none','linewidth',1)
    set(p5,'color',[0.5 0.5 0.5],'linestyle','none','marker','+','markersize',13)
    set(p6,'color',[0.2 0.2 0.2],'linestyle','none','marker','.','markersize',13)
    
    % set legend
    legend_content = [];
    legend_content{end+1} = ['Ideal'];
    legend_content{end+1} = ['Fitting points'];
    legend_content{end+1} = ['Predicted by Fit'];

    legend([p1(1),p5(1),p6(1)],legend_content,'Location','NorthWest','fontsize',s_font)
    
    % set labels
    xlabel('Actual Deflection in mm','fontsize',s_font)
    ylabel('Predicted Deflection in mm','fontsize',s_font)
    title(['Repeated Sequence Prediction Spring S' which(2)],'fontsize',s_font)
    
    % create magnifying glass
    magn_lw = 0.5;
    magn_c  = 'k';
    magn_ar = [0.04,0.04];
    magn_it = 9;
    magnifying_glass(f1,gca,[m_measured_displacement(magn_it),...
                     m_predicted_displacement(magn_it)],magn_ar,...
                     [50,20],[0.2,0.2],[0 0 1 1],magn_c,magn_lw,['br']);
    
   %% output
    data.x      = m_measured_displacement;
    data.y_mean = m_predicted_displacement;
    data.y_std  = std_predicted_displacement;
    data.I_std  = std_inductance;
    data.m_rmse   = rmse_mean.';
    data.std_rmse = rmse_std.';
    data.m_r2     = r2_mean.';
    data.std_r2   = r2_std.';
    data.range    = range(m_measured_displacement);
function data = data_visualization(label)
% Function to create paper figures on the inductance-displacement relation
%  and sort data for in the tables.

%% load data

% load complete data structure
load([label '.mat'])

% assign frequently used variables
measured_displacement    = s_out.m_displ*1000; % convert to mm
mean_measured_inductance = s_out.m_mean_I;
std_measured_inductance  = s_out.m_std_I;
theoretical_displacement = s_out.th_displ*1000; % convert to mm

% easy measure for size of the graph
md_step = measured_displacement(2)-measured_displacement(1);

data.x      = measured_displacement;
data.y_mean = mean_measured_inductance;
data.y_std  = std_measured_inductance;
data.rmse   = [s_out.RMSE_displ.basic,...
                 s_out.RMSE_displ.naga,...
                 s_out.RMSE_displ.rosa,...
                 s_out.RMSE_displ.maxw,...
                 s_out.RMSE_displ.helix,...
                 s_out.RMSE_displ.fit].';
data.r2     = [s_out.R2_I.basic,...
                 s_out.R2_I.naga,...
                 s_out.R2_I.rosa,...
                 s_out.R2_I.maxw,...
                 s_out.R2_I.helix,...
                 s_out.R2_I.fit].';

%% ----- FIGURE ----------------------------------------------------------
f1=figure;
    
    % plot data points
    p1=plot(theoretical_displacement,s_out.th_I_basic);hold on
    p2=plot(theoretical_displacement,s_out.th_I_naga);
    p3=plot(theoretical_displacement,s_out.th_I_rosa);
    p4=plot(theoretical_displacement,s_out.th_I_maxw);
    p5=plot(theoretical_displacement,s_out.th_I_helix);
    p7=plot(theoretical_displacement,s_out.th_I_fit);
    p6=errorbar(measured_displacement,mean_measured_inductance,std_measured_inductance);
    p6d=plot(-inf,inf); % dummy data point for legend
    
    % set axis properties
    axx       = gca;
    limits    = [axx.XLim,axx.YLim];
    md_step   = measured_displacement(2)-measured_displacement(1);
    limits(2) = (measured_displacement(end)+md_step);
    grid
    axis(limits)
    s_font = 15;
    set(axx,'fontsize',s_font)
    
    % style data
    set(p1,'color','r','linestyle','-','marker','none','linewidth',1)
    set(p2,'color','g','linestyle','-.','marker','none','linewidth',1)
    set(p3,'color','b','linestyle',':','marker','none','linewidth',1)
    set(p4,'color','c','linestyle','--','marker','none','linewidth',1)
    set(p5,'color','m','linestyle','-','marker','none','linewidth',0.5)
    set(p6d,'color',[0.2 0.2 0.2],'linestyle','none','marker','s','markersize',12)
    set(p6,'color',[0.2 0.2 0.2],'linestyle','none','marker','none')
    set(p7,'color',[0.5 0.5 0.5],'linestyle','-','marker','none','linewidth',1.5)
    
    % set legend
    legend_content = [];
    legend_content{end+1} = ['Basic'];
    legend_content{end+1} = ['Nagaoka'];
    legend_content{end+1} = ['Rosa'];
    legend_content{end+1} = ['Maxwell'];
    legend_content{end+1} = ['Helix'];
    legend_content{end+1} = ['Measured'];
    legend_content{end+1} = ['Fitted'];
    legend([p1,p2,p3,p4,p5,p6d,p7],legend_content,'Location','NorthEast','fontsize',s_font)
    
    % set labels
    xlabel('Deflection (mm)','fontsize',s_font)
    ylabel('Inductance (\mu H)','fontsize',s_font)
    title(['Spring S' label(2)],'fontsize',s_font)
    
    % create magnifying glass
    magn_lw = 0.5; % magnifying glass line width
    magn_c  = 'k'; % magnifying glass line color
    magn_ar = [0.03,0.03]; % size of magn. area (percentage of width and height)
    magn_it = 3; % data point to magnify
    if strcmp(label(1:2),'S1')
        magnifying_glass(f1,gca,[measured_displacement(magn_it),...
                         mean_measured_inductance(magn_it)],magn_ar,...
                         [24,4.0],[0.2,0.2],[0 1 1 0],magn_c,magn_lw,['tr']);
    else
        magn_it = 0;
    end
    % define rectangle properties 
    x_rect  = measured_displacement-0.5*magn_ar(1)*(limits(2)-limits(1));
    y_rect  = mean_measured_inductance-0.5*magn_ar(2)*(limits(4)-limits(3));
    w_rect  = magn_ar(1)*(limits(2)-limits(1));
    h_rect  = magn_ar(2)*(limits(4)-limits(3));
    rect_pos= [x_rect,y_rect,w_rect*ones(size(x_rect)),h_rect*ones(size(x_rect))];
    p6r     = [];
    % plot a rectangle around every data point
    for nn = 1:size(rect_pos,1)
        if nn~=magn_it
            p6r = [p6r;rectangle('position',rect_pos(nn,:),'edgecolor',magn_c,'linewidth',magn_lw)];
        end
    end
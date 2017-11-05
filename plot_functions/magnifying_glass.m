function [ax1,ax2,lh] = magnifying_glass(fh,ax1,cor_ma,size_ma,cor_mg,size_mg,draw_lines,line_color,line_width,ax_tick)
    % limits in primary axes    
    xl1     = xlim(ax1);
    yl1     = ylim(ax1);
    wa1     = xl1(2)-xl1(1);
    ha1     = yl1(2)-yl1(1);
    
    % magnified area coordinates and dimensions
    x_ma    = cor_ma(1)-0.5*size_ma(1)*wa1;
    y_ma    = cor_ma(2)-0.5*size_ma(2)*ha1;
    w_ma    = size_ma(1)*wa1;
    h_ma    = size_ma(2)*ha1;
    ma_pos  = [x_ma,y_ma,w_ma,h_ma];
    
    % magnifying glass coordinates and dimensions in primary axes
    x_mg    = cor_mg(1)-0.5*size_mg(1)*wa1;
    y_mg    = cor_mg(2)-0.5*size_mg(2)*ha1;
    w_mg    = size_mg(1)*wa1;
    h_mg    = size_mg(2)*ha1;
    
    % magnifying glass coordinates and dimensions in figure
    
    % 1. interpolation coordinates of first axes in figure
    p1  = get(ax1,'position');
    Xa1 = [p1(1),p1(1)+p1(3)]; % lower left to lower right
    xa1 = xl1;
    Ya1 = [p1(2),p1(2)+p1(4)]; % lower left to upper left
    ya1 = yl1;
    % 2. interpolate coordinates and dimensions to figure frame
    X_mg   = interp1(xa1,Xa1,x_mg,'linear','extrap');
    Y_mg   = interp1(ya1,Ya1,y_mg,'linear','extrap');
    W_mg   = p1(3)*w_mg/wa1;
    H_mg   = p1(4)*h_mg/ha1;
    a2_pos = [X_mg,Y_mg,W_mg,H_mg];
    
    % copy new axes
%     set(ax1,'XMinorGrid','on','YMinorGrid','on','XMinorTick','on','YMinorTick','on')
    ax2     = copyobj(ax1,fh);
    
    xax_loc = get(ax2,'XAxisLocation');
    yax_loc = get(ax2,'YAxisLocation');
    
    % new x ticks
    xtick       = get(ax1,'xtick');
    xtick_l     = get(ax1,'xticklabel');
    xtick_rat   = 1.5*(size_mg(1)/size_ma(1));
    xtick_new   = linspace(xtick(1),xtick(end),floor(1+(length(xtick)-1)*xtick_rat));
    
    x_prec = 0;
    for nn = 1:length(xtick_l)
        x_prec = max(x_prec,length(xtick_l{nn}));
    end
    x_prec = min(2,x_prec);
    for nn = 1:length(xtick_new)
        xtick_new_label{nn} = num2str(xtick_new(nn),x_prec+1);
    end
    
    % new y ticks
    ytick       = get(ax1,'ytick');
    ytick_l     = get(ax1,'yticklabel');
    ytick_rat   = 2.0*(size_mg(2)/size_ma(2));
    ytick_new   = linspace(ytick(1),ytick(end),floor(1+(length(ytick)-1)*ytick_rat));
    
    y_prec = 0;
    for nn = 1:length(ytick_l)
        y_prec = max(y_prec,length(ytick_l{nn}));
    end
    y_prec = min(2,y_prec);
    for nn = 1:length(ytick_new)
        ytick_new_label{nn} = num2str(ytick_new(nn),y_prec+1);
    end
    
    % determine x-ticks
    if strfind(ax_tick,'t')
        xax_loc = 'top';
    elseif strfind(ax_tick,'b')
        xax_loc = 'bottom';
    else
        xtick_new       = [];
        xtick_new_label = [];
    end
    % determine y-ticks
    if strfind(ax_tick,'l')
        yax_loc = 'left';
    elseif strfind(ax_tick,'r')
        yax_loc = 'right';
    else
        ytick_new       = [];
        ytick_new_label = [];
    end
    % set new properties
    set(ax2,'position',a2_pos,'units','normalized','color',[1 1 1],...
        'title',[],'xlabel',[],'ylabel',[],'xtick',xtick_new,'ytick',ytick_new,...
        'xticklabel',xtick_new_label,'yticklabel',ytick_new_label,...
        'XAxisLocation',xax_loc,'YAxisLocation',yax_loc,...
        'Box','on','xcolor',line_color,'ycolor',line_color,'linewidth',line_width)
    % magnify the appropriate area
    axis(ax2,[x_ma,x_ma+w_ma,y_ma,y_ma+h_ma])
    
    % box magnified area
    rh=rectangle('parent',ax1,'edgecolor',line_color,'position',ma_pos,'linewidth',line_width);
    
    % draw lines between corners
    lh = [];
    if draw_lines(1) % lower left
        lh=[lh;line([x_ma,x_mg],[y_ma,y_mg],'parent',ax1,'color',line_color,'linewidth',line_width)];
    end
    if draw_lines(2) % lower right
        lh=[lh;line([x_ma+w_ma,x_mg+w_mg],[y_ma,y_mg],'parent',ax1,'color',line_color,'linewidth',line_width)];
    end
    if draw_lines(3) % upper left
        lh=[lh;line([x_ma,x_mg],[y_ma+h_ma,y_mg+h_mg],'parent',ax1,'color',line_color,'linewidth',line_width)];
    end
    if draw_lines(4) % upper right
        lh=[lh;line([x_ma+w_ma,x_mg+w_mg],[y_ma+h_ma,y_mg+h_mg],'parent',ax1,'color',line_color,'linewidth',line_width)];
    end
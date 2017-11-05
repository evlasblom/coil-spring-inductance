clear all;clc;close all
springs

% Uses helical filament mutual inductance formula evaluated using
% Simpson's rule, and conductor gmd
%  Lw      = total length of wire
%  psi     = pitch angle of winding
%  r       = radius of winding
%  dw  	   = wire diameter
%  MaxErr  = max allowable error


Lc    = spring(3).Lc*linspace(1,2,100);
I_h   = zeros(1,length(Lc));
I_b   = zeros(1,length(Lc));
I_n   = zeros(1,length(Lc));
I_l   = zeros(1,length(Lc));
% T_end = zeros(1,length(Lc));

%%
% tic
for nn = 1:length(Lc)
    I_h(nn)  = helix_fcn(spring(3),Lc(nn),1e-7);
    I_b(nn)  = L_basic(spring(3),Lc(nn));
    I_n(nn)  = L_nagaoka(spring(3),Lc(nn));
    I_na(nn) = L_nagaoka_algorithm(spring(3),Lc(nn));
    I_l(nn)  = L_lundin(spring(3),Lc(nn));
    I_r(nn)  = L_rosa(spring(3),Lc(nn));
%     T_end(nn)   = toc;
end

%%
Lc_calc=spring(3).Lc;
N =spring(3).N;
r =spring(3).Dm/2;
dw=spring(3).d;
psi = atan(Lc_calc/(2*pi*r*N));
Lw  = 2*pi*N*r/cos(psi);
% psic = asin(dw/(2*pi*r));
% psic    = atan(sinpsic/sqrt(1-sinpsic*sinpsic))

%%
displacement = 100*(Lc-Lc(1))/Lc(1);
figure
    p1=plot(displacement,I_h*1e6);hold on
    p2=plot(displacement,I_b*1e6);
    p3=plot(displacement,I_n*1e6);
    p4=plot(displacement,I_l*1e6);
    p5=plot(displacement,I_r*1e6);
    p6=plot(displacement,I_na*1e6);
    
    ylim([0 7])
    grid
    
    legend_array{1} = 'Helical';
    legend_array{2} = 'Basic';
    legend_array{3} = 'Nagaoka';
    legend_array{4} = 'Lundin';
    legend_array{5} = 'Rosa';
    legend_array{6} = 'Nagaoka_2';
    legend([p1,p2,p3,p4,p5,p6],legend_array)
    
    xlabel('Displacement of spring in % of L_0')
    ylabel('Inductance of spring in micro Henry')
    title('Inductance of T32602B')
    
    set(p1,'color','b')
    set(p2,'color','r')
    set(p3,'color','k','linewidth',1)
    set(p4,'color','c')
    set(p5,'color','g')
    set(p6,'color','m')
    
    
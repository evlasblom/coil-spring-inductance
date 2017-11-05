% data on the set of springs bought at TEVEMA

spring = struct('number',[],... % Tevema cataloque number [-]
    'label',[],... % label for experiments [-]
    'num',[],... % number of the spring in the cell structure [-]
    'N',[],... % turns [-]
    'd',[],... % wire diameter [m]
    'r',[],... % wire radius [m]
    'Do',[],... % coil diameter, outer [m]
    'Dm',[],... % coil diameter, middle of wire [m]
    'Rc',[],... % coil radius, middle of wire [m]
    'Ls',[],... % rest length spring incl. connection [m]
    'Lb',[],... % rest length spring excl. connection [m]
    'Lc',[],... % rest length coil (body - 2*radius) [m]
    'Ln',[],... % maximal extended length spring incl. connection [m]
    'Lnp',[],... % maximal extended length spring incl. connection [%]
    'F0',[],... % initial force [N]
    'C',[],... % spring constant [N/m]
    'Sn',[],... % extension at load Fn [m]
    'Fn',[],... % load at maximal extended length [N]
    'rho',[],... % electrical resistivity
    'material',[]); % material [-]



% random springs
spring(1).number = 'T42721';
spring(1).label = 'S1_01';
spring(1).material = 'stainless steel';
% measured
spring(1).d = 2.82; %[2.82,2.81,2.81,2.82,2.81,2.82] <- individual measurements
spring(1).Dm = 19.76-spring(1).d; %[19.75,19.77,19.75,19.76,19.77]-d
spring(1).Ls = 145.74; %[145.69,145.84,145.81,145.83,145.52]
spring(1).Lb = 119.58+0.5*spring(1).d; %[119.68,119.47,119.60,119.53,119.62] +0.5*d
% according to specifications
% spring(1).d = 2.8; % spec
% spring(1).Dm = 17.2; % spec
% spring(1).Ls = 146; % spec
% spring(1).Lb = 120.08; % spec
spring(1).F0 = 41.9; % 10 (on tensile machine)
spring(1).C = 2.52;
spring(1).Sn = 130.75;
spring(1).Fn = 371.85;

spring(2) = spring(1);
spring(2).label = 'S1_02';

spring(3) = spring(1);
spring(3).label = 'S1_03';

spring(4) = spring(1);
spring(4).label = 'S1_04';

spring(5) = spring(1);
spring(5).label = 'S1_05';

spring(6).number = ' ';
spring(6).label = 'S2_01';
spring(6).d = 2.54; %[2.56,2.55,2.53,2.56,2.52]
spring(6).Dm = 27.63-spring(6).d;%[27.6,27.67,27.63,27.64]-d
spring(6).Ls = 143.64-2*spring(6).d;% [143.84,143.57,143.64,143.50,143.65]
spring(6).Lb = 101;% [100.86,100.92,101.24,98.54+d,98.52+d]
spring(6).F0 = [];
spring(6).C  = [];
spring(6).Sn = [];
spring(6).Fn = [];

spring(7).number = ' ';
spring(7).label = 'S3_01';
spring(7).d = 1.21; % [1.22,1.21,1.21,1.21]
spring(7).Dm = 12.7-spring(7).d; %[12.71,12.69,12.71,12.7]-d
spring(7).Ls = 100.99 -2*spring(7).d; %[100.96,100.99,101.03,100.99,100.96]
spring(7).Lb = 78.27+0.5*spring(7).d;% [78.27,78.36,78.18,78.35,78.21]+0.5*d
spring(7).F0 = [];
spring(7).C  = [];
spring(7).Sn = [];
spring(7).Fn = [];

spring(8).number = ' ';
spring(8).label = 'S4_01';
spring(8).d = 2.2;
spring(8).Dm = 24.3-spring(8).d;
spring(8).Ls = 93.5;
spring(8).Lb = 52.9;
spring(8).Sn = 1.5*spring(8).Lb+(spring(8).Ls-spring(8).Lb); % 1.5 * body

%%
ns = length(spring);
for ii = 1:ns
    si = spring(ii);
    si.num = ii;
    
    % convert lengths to meters
    si.d  = si.d/1000;
    si.Dm = si.Dm/1000;
    si.r  = si.r/1000;
    si.Lb = si.Lb/1000;
    si.Ls = si.Ls/1000;
    si.Sn = si.Sn/1000;
    
    si.C  = si.C*1000;
    
    % calculate additional parameters
    si.r = si.d/2;
    si.Rc = si.Dm/2;
    si.Lc = si.Lb - si.d;
    si.N = si.Lc / si.d;
    si.Do = si.Dm + si.d;   
    si.Ln = si.Ls + si.Sn;
    si.Lnp = si.Ln/si.Ls*100;
    
    if isempty(si.material)
        if strcmp(si.number(1),'T') % from tevema
            si.material = 'spring steel';
        end
    end
    
    % resistivity (find correct values)
    if strcmp(si.material,'stainless steel')
        si.rho = 6.9e-7; 
    elseif strcmp(si.material,'spring steel')
        si.rho = 6.9e-7; 
    elseif strcmp(si.material,'piano wire')
        si.rho = 1.18e-7;
    end
    
    spring(ii) = si;
    
end




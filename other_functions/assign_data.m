% This function adds the inductance measurement data of a spring to the 
% corresponding spring in the 'spring' structure

% Data file names in folder


file_names{1} = 'S1_01'; % S1 (file: s1)
file_names{2} = 'S1_02'; % S1 (file: s2)
file_names{3} = 'S1_03'; % S1 (file: s3)
file_names{4} = 'S1_04'; % S1 (file: s4)
file_names{5} = 'S1_05'; % S1 (file: s5)

file_names{6} = 'S2_01'; % S2 
file_names{7} = 'S3_01'; % S3 
file_names{8} = 'S4_01'; % S4


%% Load the data, do some processing and add it to the structure
for nn = 1:length(file_names);
    if ~isempty(file_names{nn})
        % load
        spring(nn).data.filename = file_names{nn};
        spring(nn).data.raw      = load_data([file_names{nn} '.csv']);
        
        % basic processing
        spring(nn).displ   = spring(nn).data.raw(:,1)*1e-3; % convert from mm to m
%         spring(nn).m_displ = mean(spring(nn).displ,2);      
%         spring(nn).s_displ = std(spring(nn).displ,[],2);
        spring(nn).R       = spring(nn).data.raw(:,2:2:20);
        spring(nn).m_R     = mean(spring(nn).R,2);
        spring(nn).s_R     = std(spring(nn).R,[],2);
        spring(nn).L       = spring(nn).data.raw(:,3:2:21);
        spring(nn).m_L     = mean(spring(nn).L,2);
        spring(nn).s_L     = std(spring(nn).L,[],2);
    end
end

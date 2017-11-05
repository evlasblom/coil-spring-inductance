function data = load_data(filename)
% This function is used to read in data from .csv files in the 
% '../experiment/measurements/' folder and give the data with
% additional info as output.
% The experimental data file is specifically
% made for this read in function.
%
% measurement step nr - desired position steps - pause time - measured position ...
% - measured (inductance - resistance) x repetitions

% load data
curr = cd;
try
    stringdata = fileread(filename); % load data from .csv file
catch
    cd('../experiment/measurements/')% if it doesn't work directly, go to the directory
    stringdata = fileread(filename); % load data from .csv file
    cd(curr);
end
i_line = regexp(stringdata,'\n'); % find indices with line-end markers (\n)

% read line by line
start_ii = 1;
for ii = 1:length(i_line)
    line{ii} = stringdata(start_ii:i_line(ii)); % read untill line end
    line{ii} = [line{ii},';'];                  % add a semicolon at the end of a line
    i_semi = regexp(line{ii},';');              % find indices at which a 
                                                %  measured value ends,
                                                %  indicated by a semicolon
    
    % read data in line
    start_jj = 1;
    for jj = 1:length(i_semi)
        str = line{ii}(start_jj:i_semi(jj));
        % read data lines
        if jj > 3 %(first three are not interesing (see top))
            data(ii,jj-3) = str2num(str); % convert to numerical value
        end
        start_jj = i_semi(jj)+1; % starting index of next measured value
    end
    
    start_ii = i_line(ii)+1; % starting index of next line
end


end
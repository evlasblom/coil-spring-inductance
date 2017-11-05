clear all,clc
%% 1. Set paths
    addpath('inductance_functions')
    addpath('plot_functions')
    addpath('raw_data')
    addpath('processed_data')
    addpath('other_functions')

%% 2. Load spring data
fprintf('\nLoading...\n')
    springs     % generate data structure with spring properties of meaured springs
    assign_data % add measurement data in structure
    save_figures = 0;
    
    % which springs (labels)
    which = [];
    which{end+1}='S1_01';
    which{end+1}='S1_02';
    which{end+1}='S1_03';
    which{end+1}='S1_04';
    which{end+1}='S1_05';
    
    which{end+1}='S2_01';
    which{end+1}='S3_01';
    which{end+1}='S4_01';

%% 3. Process data
fprintf('\nProcess data\n')
    for nn = 1:length(which)
        s    = get_spring(spring,which(nn)); % select spring from structure  
        sout = processing_function(s);       % process raw data, save in .mat file and output in sout
    end
%% 4. Visualize data

%-------------------------
% Single spring plots
%
fprintf('\nPlot inductance-displacement relations\n\n')
% set variable for tables
rmse_table = [];
r2_table   = [];

for nn = 1:length(which)
    data{nn}=data_visualization(which{nn}); % plot inductance-displacement relation
                                              % and output sorted RMSE and
                                              % R2 data
    % figure customization:
    if ~isempty(strfind(which{nn},'S2'))
        ylim(gca,ylim(gca)+0.5)
    end
    
    % extract data on std
    min_std(nn) = 1000*min(data{nn}.y_std);
    max_std(nn) = 1000*max(data{nn}.y_std);
    fprintf('S%i_%i Std range: [%1.2f,%1.2f] nH\n',[str2num(which{nn}(2)),str2num(which{nn}(5)),min_std(nn),max_std(nn)])
    
    % save figures (only the Sx_01 series)
    if save_figures && ~isempty(strfind(which{nn},'_01'))
        print(gcf,['figure_S',which{nn}(2)],'-depsc')
    end
    
    % append tables for paper
    rmse_table = [rmse_table;data{nn}.rmse.'];
    r2_table   = [r2_table;data{nn}.r2.'];
end
    
fprintf('Overall std range: [%1.2f,%1.2f]\n',[min(min_std),max(max_std)])
%% Give out tables in latex format
fprintf('\nR2 table:\n')
fprintf(...
    ['\nS1-a & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S1-b & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S1-c & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S1-d & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S1-e & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S2   & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S3   & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'...
       'S4   & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f & %1.3f \\\\ \n'],reshape(r2_table.',[1 size(r2_table,1)*size(r2_table,2)]))
fprintf('\nRMSE table in percentage:\n')
fprintf(...
    ['\nS1-a & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S1-b & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S1-c & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S1-d & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S1-e & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S2   & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S3   & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'...
       'S4   & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% & %1.1f \\%% \\\\ \n'],reshape(rmse_table.',[1 size(rmse_table,1)*size(rmse_table,2)])*100.')

%% -------------------------
% S1 Repeated series plot
%
data_repeated = repeated_series_visualization('S1'); % plot displacement prediction of it for the repeated series
fprintf('Repeated series std range: [%1.2f,%1.2f] mm\n',[min(data_repeated.y_std),max(data_repeated.y_std)])
fprintf('Repeated series std range: [%1.2f,%1.2f] percent\n',[min(data_repeated.y_std),max(data_repeated.y_std)]*100/data_repeated.range)
fprintf('Repeated series std range: [%1.2f,%1.2f] nH\n',[min(data_repeated.I_std),max(data_repeated.I_std)])

if save_figures
    print(gcf,'figure_S1_repeat','-depsc')
end 
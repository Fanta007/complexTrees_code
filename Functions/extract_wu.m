clear;close all
% cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching;


%% read data and extract apical dendrite

data_path = 'NeuroData/wu/CNG version/';
% swc_files = get_filenames(data_path);
fnames = ls(data_path);
% fnames = fnames';
for i=3: size(fnames, 1)
    swc_files{i-2} = fnames(i, :);
end
% fnames = textscan(fnames,'%s','delimiter', '\t');
% fnames = fnames{1};
fnames = sort(fnames);
% return;
N = numel(swc_files);

ap = 4;

raw = cell(1,N);
ST = cell(1,N);
qST = cell(1,N);
for i=1:N
    raw{i} = read_swcdata( strcat( data_path,swc_files{i} ));
    ST{i} = ST_from_swcdata(raw{i},ap);
    qST{i} = SimpleTree_to_qSimpleTree(ST{i});
end

grps = [ones(1,20), 2*ones(1,21)];

%%
% save('wu_data_12072016.mat', ...
%      'qST','ST','grps','N','data_path','swc_files','raw');

%% display

lw=2;
% set(0,'defaultLineLinewidth',lw);
% set(0,'defaultScatterSizedata',4*lw^2);
% set(0,'defaultScatterMarkerFaceColor','flat');

set(0,'defaultFigureVisible','on');


fig_dir = 'tmp_figs/';
% mkdir(fig_dir);

fprintf('Plotting %d trees...',N);
for i=1:N
    figure(i); view(0, -90); hold on;
%     Display_ST_vs_swc(ST{i},raw{i},ap)
    DisplaySimpleTree(ST{i},raw{i},ap)
%     axis off
end
return;
fprintf('done\n');

% fprintf('Exporting figs...');
% for i=1:N
%     fprintf('%d...',i);
%     fig_path = sprintf('%s%02d', fig_dir,i);
%     export_fig(fig_path,'-png','-eps','-transparent','-nocrop',i);
%     if mod(i,10)==0
%         fprintf('\n');
%     end
% end
% fprintf('\ndone\n');

% set(0,'defaultLineLinewidth','factory');
% set(0,'defaultScatterSizedata','factory');
% set(0,'defaultScatterMarkerFaceColor','factory');

% set(0,'defaultFigureVisible','factory');





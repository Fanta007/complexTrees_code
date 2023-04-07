% clc
% close all;
% gcf = figure('position', [100, 100, 1000, 600]);
% set(gcf,'visible', 'on');
% set(gcf, 'color', 'w');
% view(0, 90);
% axis equal; hold on;

% A10 is the geodesic
function [folder_name] = saveInputAndMeanObjs_compTrees_rad_4layers(A10, data_path, used_idxes)

CT = A10;

addpath Yanirk_code

% c = distinguishable_colors(50,[.9,.9,.9;0,0,0],[20,20]);

c = distinguishable_colors(70);

folder_name = ['outputedOBJs/InputAndMeanOBJs_', data_path, '-', num2str(used_idxes)];
mkdir(folder_name);

for i =1: numel(CT)
    
    compTree2obj_rad_4layer(CT{i}, [folder_name,'/',num2str(i)]);
end
    
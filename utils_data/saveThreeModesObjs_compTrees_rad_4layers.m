% clc
% close all;
% gcf = figure('position', [100, 100, 1000, 600]);
% set(gcf,'visible', 'on');
% set(gcf, 'color', 'w');
% view(0, 90);
% axis equal; hold on;

% A10 is the geodesic
function [folder_name] = saveThreeModesObjs_compTrees_rad_4layers(CT_cell, data_path, used_idxes)

% CT = A10;
CT_cell = CT_cell;

addpath Yanirk_code

% c = distinguishable_colors(50,[.9,.9,.9;0,0,0],[20,20]);

c = distinguishable_colors(70);

folder_name = ['ThreeModesOBJs_', data_path, '-', num2str(used_idxes)];
mkdir(folder_name);

for m_idx =1: numel(CT_cell)
    
%     y_added = ceil(i/19) * -0;
%     x_added = (mod(i, 19)+1) * 300;
%     
%     clear first_pt_x first_pt_y first_pt_z
%     
%     first_pt_x = (CT{i}.beta0(1, 1));
%     first_pt_y = (CT{i}.beta0(2, 1));
%     first_pt_z = (CT{i}.beta0(3, 1));
    
    mkdir([folder_name, '/mode_', num2str(m_idx)]);
    for i = 1: numel(CT_cell{m_idx})
    
        compTree2obj_rad_4layer(CT_cell{m_idx}{i}, [folder_name,'/mode_',num2str(m_idx), '/', num2str(i)]);
    end
end
    
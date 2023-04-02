clc;
close all;


gcf = figure('position', [100, 100, 1000, 500]);
set(gcf,'visible', 'on');
set(gcf, 'color', 'w');
view(0, 90);
axis equal; hold on;
axis off; hold on;


for i=1: 9
%     wg_tree_showOneOBJ_botanicalTrees([num2str(i), '.obj'], 4.5*(i-1), 0, 0);
    
    wg_tree_showOneOBJ_neuroTrees([num2str(i), '.obj'], 300*(i-1), 0, 0);
end




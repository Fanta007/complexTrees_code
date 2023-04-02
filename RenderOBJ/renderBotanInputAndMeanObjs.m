clc; 
% clear; 
close all;
addpath('func_render/');
addpath('func_other/');
% mesh_dir = 'data/';
mesh_dir = [obj_folder, '/'];
% mesh_dir = ['../InputAndMeanOBJs_botanTrees_txtskl_SGP18---33  34  35  36  37', '/'];

% load the shape
N = length(dir(mesh_dir)) -2;
S = cell(1, N);
for i = 1:N
    S{i} = MESH_IO.read_shape([mesh_dir, num2str(i),'.obj']);
end

%% Draw geodesic
 renderOptions = {'RotationOps',{[-90,0,0],[0,0,0]},...  % Botanical trees: [-90,0,0],[0,0,0]
                  'CameraPos',[-0.1,10],...             % default: [-10, 10]
                  'FaceAlpha',0.9,...
                  'BackgroundColor',[1.0, 1.0, 1.0]}; % you can change the background color here
              
fig = figure('visible','on');
axis equal; hold on;
default_c = get(gca,'colororder');

for i=1:N

    M = S{i};
    color_botanTree = [0.2, 0.1, 0];
%     color_neuroTree = [0.0, 0.0, 0.5];
%     color_neuroTree = default_c(1, :);
    used_color = color_botanTree;
    
    M_col = repmat(used_color, M.nv, 1);    
    if i == N
        moveVec = [mod(i-1, 17)*120 + 50, ceil(i/17)*0, 0];  % --- BotanTrees: [(i-1)*4, 0, 0], NeuroTrees; [(i-1)*4, 0, 0]
    else
        moveVec = [mod(i-1, 17)*120, ceil(i/17)* 0, 0];
    end
    
    tm1 = tic();
    [~,~, S1_new] = render_mesh(M,'MeshVtxColor',M_col,...
                               'VtxPos',M.surface.VERT + repmat(moveVec, M.nv,1),... % translate the second shape such that S1 and S2 are not overlapped
                                renderOptions{:});
    hold on;
    all_edges = get_edge_list(S{i});  % get the edge list
    vertex = S1_new.surface.VERT';    % get the vertex positions after the rotations!

    
    t = trimesh(S1_new.surface.TRIV, vertex(1,:), vertex(2,:), vertex(3,:),...
                'FaceColor','none',...
                'EdgeColor', used_color,...
                'LineWidth', 1);

    hold on;
    T_render= toc(tm1);
    fprintf('%d-th tree rendering done, time: %f\n', i, T_render);
end

set(fig,'Position', [100 100 1000 800]);
set(gca,'Position',[0.0,-0.0, 1 ,1] )
set(fig,'Color', [1, 1, 1],'InvertHardcopy','off'); 
% print(gcf, '-depsc', '-r1500', './GeoNeuro_chen_No32and41')
% % Save as .pdf
% set(fig,'Units','Inches');
% pos = get(fig,'Position');
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(fig, './Geod_compBotanTrees', '-dpdf', '-r1000')



% Mean info
% lam_m=1; lam_s=1; lam_p=1;
S1 = sprintf('Mean, BotanTree, %s trees, %s, --- ', num2str(N-1), mesh_dir);
Lambda_str = ['\lambda_{m}=', num2str(lam_m), ', \lambda_{s}=', num2str(lam_s), ', \lambda_{p}=', num2str(lam_p)];
% T3 = 387.82;
TotalTime_str = ['totalTime :', num2str(T3)];

title({[S1, Lambda_str] , TotalTime_str}, 'Interpreter', 'none');

% Axis position
% set(gca,'position',[0, -0.05, 1.1, 1])
axis off
% Save as .png
% set(gca,'looseInset',[0 0 0 0])
print(fig,['InputAndMean_compBotanTrees_', num2str(N-1), 'trees'],'-dpng','-r600')
% print(fig,['InputAll_compNeuroTrees_', num2str(N-1), 'trees'],'-dpng','-r1000')
% saveas(fig,'results/eg_singleShape_singleCol.png')



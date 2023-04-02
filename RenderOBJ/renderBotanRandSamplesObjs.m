clc; 
% clear; 
close all;
addpath('func_render/');
addpath('func_other/');
% mesh_dir = 'data/';
% obj_folder = 'randSamplesOBJs_BotanTreeSGP-Group-4';
obj_folder = 'randSamplesOBJs_InputBotanTrees_SGP_G1';
mesh_dir = [obj_folder, '/'];

% load the shape
% N = length(dir(mesh_dir)) -2;
N = length( strfind(ls(mesh_dir), '.obj') );
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

for i=1:36

    M = S{i};
    color_botanTree = [0.2, 0.1, 0];
    
    M_col = repmat(color_botanTree, M.nv, 1);
    moveVec = [mod(i-1, 9)*180, ceil(i/9 )* -1000, 0];
    
    tm1 = tic();
    [~,~, S1_new] = render_mesh(M,'MeshVtxColor',M_col,...
                               'VtxPos',M.surface.VERT + repmat(moveVec, M.nv,1),... % translate the second shape such that S1 and S2 are not overlapped
                                renderOptions{:});
    hold on;
    
%     S1_new = M;
    vertex = S1_new.surface.VERT';    % get the vertex positions after the rotations!

    
    % only draw mesh, no rendering
%     t = trimesh(S1_new.surface.TRIV, vertex(1,:)+ moveVec(1), vertex(2,:) +moveVec(2), vertex(3,:),...
%                 'FaceColor','none',...
%                 'EdgeColor', color_botanTree,...
%                 'LineWidth', 1);

    t = trimesh(S1_new.surface.TRIV, vertex(1,:), vertex(2,:), vertex(3,:),...
                'FaceColor','none',...
                'EdgeColor', color_botanTree,...
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



% % Rand Samples info
% S1 = sprintf('Rand Samples, BotanTree, %s, %d randTrees, --- ', data_path, length(S));
% Lambda_str = ['\lambda_{m}=', num2str(lam_m), ', \lambda_{s}=', num2str(lam_s), ', \lambda_{p}=', num2str(lam_p)];
% TotalTime_str = ['totalTime :', num2str(T3)];
% 
% title({[S1, Lambda_str], TotalTime_str});

% Axis position
% set(gca,'position',[0, -0.05, 1.1, 1])
axis off
% Save as .png
% set(gca,'looseInset',[0 0 0 0])
print(fig, obj_folder ,'-dpng','-r1000')


% print(fig,['InputAll_compNeuroTrees_', num2str(N-1), 'trees'],'-dpng','-r1000')
% saveas(fig,'results/eg_singleShape_singleCol.png')



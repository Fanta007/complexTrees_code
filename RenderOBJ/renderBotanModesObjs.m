clc; 
% clear; 
close all;
addpath('func_render/');
addpath('func_other/');
% mesh_dir = 'data/';
mesh_dir = [obj_folder, '/'];

% load the shape
mode_num = length( strfind(ls(mesh_dir), 'mode') );

mode_samp_num = length( strfind(ls([mesh_dir, 'mode_', num2str(1)]), '.obj') );

% read objs
S = cell(1, mode_num);
for i = 1:mode_num
    for j = 1 : mode_samp_num
        S{i}{j} = MESH_IO.read_shape([mesh_dir, 'mode_', num2str(i),'/', num2str(j),'.obj']);
    end
end

%% Draw modes
 renderOptions = {'RotationOps',{[-90,0,0],[0,0,0]},...  % Botanical trees: [-90,0,0],[0,0,0]
                  'CameraPos',[-0.1,10],...             % default: [-10, 10]
                  'FaceAlpha',0.9,...
                  'BackgroundColor',[1.0, 1.0, 1.0]}; % you can change the background color here
              
fig = figure('visible','on');
axis equal; hold on;
default_c = get(gca,'colororder');

for i=1:mode_num
    for j = 1: mode_samp_num

        M = S{i}{j};

%         color_neuroTree = [0.0, 0.0, 0.5];
        color_botanTree = [0.2, 0.1, 0];
    %     color_neuroTree = default_c(1, :);

        M_col = repmat(color_neuroTree, M.nv, 1); 
        
        moveVec = [j*120, i* -150, 0];  % 550, -5500

        tm1 = tic();
%         [~,~, S1_new] = render_mesh(M,'MeshVtxColor',M_col,...
%                                    'VtxPos',M.surface.VERT + repmat(moveVec, M.nv,1),... % translate the second shape such that S1 and S2 are not overlapped
%                                     renderOptions{:});
        hold on;
        S1_new = M;
        vertex = S1_new.surface.VERT';    % get the vertex positions after the rotations!

        if i==1
            [~, max_y_idx] = max(vertex(2,:));
            text(vertex(1, max_y_idx)+ moveVec(1), ...
                 vertex(2, max_y_idx)+ moveVec(2) + 20, ...
                 vertex(3, max_y_idx), ...
                 [num2str((j-1)*1-2), ' std'], 'FontSize', 15);
        end
            
            
        t = trimesh(S1_new.surface.TRIV, vertex(1,:)+ moveVec(1), vertex(2,:)+ moveVec(2), vertex(3,:),...
                    'FaceColor','none',...
                    'EdgeColor', color_botanTree,...
                    'LineWidth', 1);

        hold on;
        T_render= toc(tm1);
        fprintf('%d-th tree rendering done, time: %f\n', i, T_render);
        
        
    end
end

set(fig,'Position', [100 100 600 1000]);
set(gca,'Position',[0.0, -0.0, 1 ,1] )
set(fig,'Color', [1, 1, 1],'InvertHardcopy','off');

% axis equal; hold on;
% print(gcf, '-depsc', '-r1500', './GeoNeuro_chen_No32and41')
% % Save as .pdf
% set(fig,'Units','Inches');
% pos = get(fig,'Position');
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(fig, './Geod_compBotanTrees', '-dpdf', '-r1000')



% Mode info, add title
S1 = sprintf('Modes, BotanTree, %s, %d inputTrees, --- ', data_path, tNum);
Lambda_str = ['\lambda_{m}=', num2str(lam_m), ', \lambda_{s}=', num2str(lam_s), ', \lambda_{p}=', num2str(lam_p)];
% TotalTime_str = ['totalTime :', num2str(T3)];

title({[S1, Lambda_str], ' ', ' ', ' '});

% Axis position
% set(gca,'position',[0, -0.05, 1.1, 1])
axis off
% Save as .png
% set(gca,'looseInset',[0 0 0 0])
print(fig, obj_folder ,'-dpng','-r800')

% print(fig,['InputAll_compNeuroTrees_', num2str(N-1), 'trees'],'-dpng','-r1000')
% saveas(fig,'results/eg_singleShape_singleCol.png')



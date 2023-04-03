clc; 
% clear; 
close all;
mesh_dir = [obj_folder, '/'];

% load the shape
N=9;
S = cell(1, N);
for i = 1:N
    S{i} = MESH_IO.read_shape([mesh_dir, num2str(i),'.obj']);
end

%% Draw geodesic
 renderOptions = {'RotationOps',{[-90,0,0],[0,0,0]},... 
                  'CameraPos',[-0.1,10],...             % default: [-10, 10]
                  'FaceAlpha',0.9,...
                  'BackgroundColor',[0.9, 0.9, 0.9]};
              
fig = figure('visible','on');
axis equal; hold on;
default_c = get(gca,'colororder');

for i=1:N

    M = S{i};
    color_neuroTree = [0.0, 0.0, 0.5];
    
    M_col = repmat(color_neuroTree, M.nv, 1);    

    moveVec = [(i-1)*350, 0, 0];  % --- BotanTrees: [(i-1)*4, 0, 0], NeuroTrees; [(i-1)*4, 0, 0]
    
    tm1 = tic();
    [~,~, S1_new] = render_mesh(M,'MeshVtxColor',M_col,...
                               'VtxPos',M.surface.VERT + repmat(moveVec, M.nv,1),... % translate the second shape such that S1 and S2 are not overlapped
                                renderOptions{:});
    hold on;
    all_edges = get_edge_list(S{i});  % get the edge list
    vertex = S1_new.surface.VERT';    % get the vertex positions after the rotations!

    
    t = trimesh(S1_new.surface.TRIV, vertex(1,:), vertex(2,:), vertex(3,:),...
                'FaceColor','none',...
                'EdgeColor', color_neuroTree,...
                'LineWidth', 1);

    hold on;
    T_render= toc(tm1);
    fprintf('%d-th tree rendering done, time: %f\n', i, T_render);
end

set(fig,'Position', [200 200 800 600]);
set(gca,'position',[0.0,0.0,0.99,0.99])
set(fig,'Color', [1, 1, 1],'InvertHardcopy','off'); 




% Title: Geod info
S1 = sprintf('Geodesic, NeuroTree %d with %d, ', idx1, idx2);
Lambda_and_E = ['\lambda_{m}=', num2str(lam_m), ', \lambda_{s}=', num2str(lam_s), ', \lambda_{p}=', num2str(lam_p), ', E-total=', num2str(G.E)];

title({S1, Lambda_and_E});

axis off
print(fig,'Geod_compNeuroTrees','-dpng','-r1000')



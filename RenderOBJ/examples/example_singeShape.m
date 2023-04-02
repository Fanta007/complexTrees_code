clc; clear; close all;
addpath('../func_render/');
addpath('../func_other/');
mesh_dir = '../data/';

% load the shape
% S1 = MESH_IO.read_shape([mesh_dir, 'tr_reg_001.off']);
S1 = MESH_IO.read_shape([mesh_dir, '2.obj.obj']);
%% mesh with color from the vertex position
% the 2nd argument controls the color-scheme of the shape
% try any permutation of [1,2,3] with different signs, e.g., [1,2,3], [-3,-2,1]
S1_col = get_mesh_face_color(S1, [-2,-1,3]);
figure(1);
[~, ~, S1_new] = render_mesh(S1, 'MeshVtxColor', S1_col,...
                            'RotationOps',{[-90,0,0],[0,0,20]},...  % apply rotations to S1, the return S1_new is the rotated version of S1
                            'CameraPos',[-10,10],...
                            'FaceAlpha',0.9); 

set(gcf,'Position', [50 50 600 600]);
saveas(gcf,'../results/eg_singleShape_colorFromVertex.png')

%% mesh with a single color
renderOptions = {'RotationOps',{[-90,0,0],[0,0,20]},...  
    'CameraPos',[-10,10],...
    'FaceAlpha',0.9,...
    'BackgroundColor',[0.9, 0.9, 0.9]}; % you can change the background color here

figure(1); clf;
S1_col = repmat([0.5, 0.5, 0.5], S1.nv, 1);
% S1_col = repmat([0.98, 0.98, 0.98], S1.nv, 1);
render_mesh(S1,...
    'MeshVtxColor', S1_col,...
    renderOptions{:}); 

set(gcf,'Position', [50 50 600 600]);
set(gcf,'Color', [1.0,1.0,1.0],'InvertHardcopy','off'); 
saveas(gcf,'../results/eg_singleShape_singleCol.png')


% return;
%% visaulize a function on the mesh
f1 = S1.surface.X; % a function defined on the shape

f_min = min(f1); f_max = max(f1); % for consistent/comparable color axis

color_min = [14,77,146]/255;
color_ave = [1,1,1];
color_max = [213,94,0]/255;

range_col = [color_min; color_ave; color_max];

S1_col = assign_color_for_scalar_func(f1,f_min,f_max,range_col);

figure(1); clf;
render_mesh(S1,...
    'MeshVtxColor', S1_col,...
    renderOptions{:}); 

set(gcf,'Position', [50 50 600 600]);
set(gcf,'Color', [0.5,0.5,0.5],'InvertHardcopy','off'); % to preserve the bgcolor when saving it
saveas(gcf,'../results/eg_singleShape_visualizeFunction.png')

%% visualize all the edges: can be very slow if mesh is large!!

figure(1); clf;
S1_col = repmat([0.1, 0.1, 0.5], S1.nv, 1);
[~,~, S1_new] = render_mesh(S1,...
    'MeshVtxColor', S1_col,...
    renderOptions{:});  hold on;

all_edges = get_edge_list(S1); % get the edge list
vertex = S1_new.surface.VERT'; % get the vertex positions after the rotations!

% visualize all the edges - can be really slow if the mesh is large
edges = all_edges;
% visualize a subset:
edges = all_edges(:,:);
x = [ vertex(1,edges(:,1)); vertex(1,edges(:,2))];
y = [ vertex(2,edges(:,1)); vertex(2,edges(:,2))];
z = [ vertex(3,edges(:,1)); vertex(3,edges(:,2))];
line(x,y,z, 'color', [0.1, 0.1, 0.5], 'LineWidth',2.0); hold off; % change the edge color here

set(gcf,'Position', [50 50 600 600]);
set(gcf,'Color', [1.0,1.0,1.0],'InvertHardcopy','off'); % to preserve the bgcolor when saving it
saveas(gcf,'../results/eg_singleShape_subsetEdges.png')
return;

%% visualize a vector filed on a mesh

[Nv, Nf] = compute_vtx_and_face_normals(S1);

figure(1); clf;
S1_col = repmat([0.98, 0.98, 0.98], S1.nv, 1);
render_mesh(S1,...
    'MeshVtxColor', S1_col,...
    'VecField', Nv,...
    renderOptions{:}); 

set(gcf,'Position', [50 50 600 600]);
set(gcf,'Color', [0.5,0.5,0.5],'InvertHardcopy','off'); % to preserve the bgcolor when saving it
saveas(gcf,'../results/eg_singleShape_vectorField.png')

clc;
clear;
close all


%% ############ DATA ############
addpath('utils_data');
data_path = 'utils_data/NeuroData/chen/CNG version/';
[all_qCompTrees, all_compTrees] = load_neuroTrees_rad(data_path);

% separate data
G_1and2 = linspace(1, length(all_compTrees), length(all_compTrees));
G_1_idxes = [linspace(1, 15, 15), linspace(32, 46, 15), linspace(62, 79, 18)]; % hard coded
G_2_idxes = setdiff(G_1and2, G_1_idxes);
         
% addpath('utils_draw');
% run showAll_compTrees_4layers.m
% return;

tNum = 5;
used_idxes = [47, 48, 49, 50, 51];

used_qCompTrees = all_qCompTrees(used_idxes);
used_compTrees = all_compTrees(used_idxes);
% return;

%% ######### Statistical Models #########

% %%%%%% Mean Computation %%%%%%
addpath('utils_statModels','utils_funcs')

% parameters
lam_m = 1; 
lam_s = 1;
lam_p = 1;
Nitr = 3;

fprintf('Q1 to Q2 (with perm), lam_m:%.2f, lam_s:%.2f, lam_p:%.2f\n', ...
                                                    lam_m, lam_s, lam_p);


% === Loops: Pad, Align tree pairs; Compuate geodesic ====
tm_all = tic;
qMean = used_qCompTrees{1};
for i = 2: tNum
    
    tm1 = tic;
    Q1 = qMean;
    Q2 = used_qCompTrees{i};
    
    % ---- Pad and Align trees ---
    [G,Q1p, Q2p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q1, Q2, lam_m, lam_s, lam_p);
    
    T1 = toc(tm1); fprintf('Loop %d: Pad and Align trees - done, timecost:%.4f secs\n', (i-1), T1);

    % --- Compute Geodesic ---
    tm2 = tic;
    stp1 = i+1;
    [A10, qA10] = GeodComplexTreesPrespace_rad_4layers(Q1p, Q2p, stp1);
    qMean = qA10{2};
    
    T2 = toc(tm2); fprintf('Loop %d: Geodesic computation - done, timecost:%.4f secs\n',(i-1), T2);

end

T3 = toc(tm_all); fprintf('Mean Loops - done, timecost:%.4f secs\n', T3);

% --- Visualization, A10{2} is final mean ----------
addpath('utils_draw')
run showInputAndMean_compTrees_4layers.m

% --- Save Objs --------
addpath('GetOBJ')
Data = [used_compTrees(1:end), A10{2}];
obj_folder = saveInputAndMeanObjs_compTrees_rad_4layers(Data, 'chen', used_idxes);


% ===== Render Objs =====
addpath('RenderOBJ')
addpath('RenderOBJ/func_render/');
addpath('RenderOBJ/func_other/');
run renderNeuroInputAndMeanObjs.m





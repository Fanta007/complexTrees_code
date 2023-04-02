clc;
clear;
close all


%% ############ DATA ############

% Botanical Trees
addpath('utils_data/utils_data_botanTrees');
data_path = 'botanTrees_txtskl';
[~, all_compTrees] = load_botanTrees_rad(data_path);

addpath('utils_draw')
run showAll_compBotanTrees_4layers.m

% % -------------------------------------------
% % NeuroTrees
% addpath('utils_data');
% data_path = 'NeuroData/chen/CNG version/';
% % data_path = 'NeuroData/wu/CNG version/';
% [all_qCompTrees, all_compTrees] = load_neuroTrees_rad(data_path);

% run showAll_compTrees_4layers.m
%% ######### Statistical Models #########

% ##### Geodesic Computation #####
addpath('utils_statModels')
idx1 =6; idx2 = 12;

for time=1: 10

    %%% --- disorder(rand permute)  subtrees ---
    T1 = disorderSubtrees(all_compTrees{idx1}, time);
    T2 = disorderSubtrees(all_compTrees{idx2}, time*2);
    
    Q1 = CompTree_to_qCompTree_rad_4layers(T1);
    Q2 = CompTree_to_qCompTree_rad_4layers(T2);

    
    % parameters
    lam_m = 1; 
    lam_s = 1;
    lam_p = 1;
    Nitr = 3;
    
    fprintf('Q1 to Q2 (with perm), lam_m:%.2f, lam_s:%.2f, lam_p:%.2f\n', ...
                                                        lam_m, lam_s, lam_p);
    
    
    % ===== Pad and Align trees =====
    tm1 = tic;
    [G,Q1p, Q2p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q1, Q2, lam_m, lam_s, lam_p);
    
    T1 = toc(tm1); fprintf('Pad and Align trees - done, timecost:%.4f secs\n', T1);
    % --- Align two trees and compute correspondence ---
    % [Q1p, G, ~, Q2p] = AlignFull_qComplexTree_4layers(Q1, Q2, lam_m,lam_s,lam_p, Nitr); 
    
    
    % ===== Compute the geodesic，map back to Euclidean space =====
    stp1 = 9;
    tm2 = tic;
    [A10, qA10] = GeodComplexTreesPrespace_rad_4layers(Q1p,Q2p,stp1);
    
    T2 = toc(tm2); fprintf('Geodesic computation - done, timecost:%.4f secs\n', T2);
    
    % ===== Visualization =====
    addpath('utils_draw')
    run showGeodesic_compBotanTrees_4layers.m
    
    % % ===== Save Objs =====
    addpath('GetOBJ')
    obj_folder = saveGeoObjs_compTrees_rad_4layers(A10, data_path, idx1, idx2);
    
    % ===== Render Objs =====
    addpath('RenderOBJ')
    addpath('RenderOBJ/func_render/');
    addpath('RenderOBJ/func_other/');
    run renderBotanGeodObjs_for10times.m
end






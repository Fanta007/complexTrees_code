clc;
% clear;
close all

%% ############ DATA ############

% % Botanical Trees
% addpath('utils_data/utils_data_botanTrees');
% data_path = 'botanTrees_txtskl_SGP18';   % botanTrees_txtskl_SGP18
% [all_qCompTrees, all_compTrees] = load_botanTrees_rad(data_path);
% % 
% % addpath('utils_draw')
% % run showAll_compBotanTrees_ownMade4layers.m
% % return
% tNum = 5;
% used_qCompTrees = all_qCompTrees(1:tNum);
% used_compTrees = all_compTrees(1:tNum);

% -------------------------------------------
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

tNum = length(G_2_idxes);  used_idxes=-1;
used_qCompTrees = all_qCompTrees(G_2_idxes(1:tNum));
used_compTrees = all_compTrees(G_2_idxes(1:tNum));
% return;

%% ######### Statistical Models #########

% ##### Mean Computation #####
addpath('utils_statModels')

% parameters
lam_m = 0.2; 
lam_s = 1;
lam_p = 0.2;
Nitr = 3;

fprintf('Q1 to Q2 (with perm), lam_m:%.2f, lam_s:%.2f, lam_p:%.2f\n', ...
                                                    lam_m, lam_s, lam_p);
% === Loops, Pad and Align trees ====
tm_all = tic;
qMean = used_qCompTrees{1};
used_qCompTrees_Align = cell(1, tNum);
used_qCompTrees_Align{1} = used_qCompTrees{1};

for i = 2: tNum
    
    tm1 = tic;
    Q1 = qMean;
    Q2 = used_qCompTrees{i};
    
    % Q2 to Q1
    [G,Q2p, Q1p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q2, Q1, lam_m, lam_s, lam_p);
    
    used_qCompTrees_Align{i} = Q2p;
    T1 = toc(tm1); fprintf('Loop %d: Pad and Align trees - done, timecost:%.4f secs\n', (i-1), T1);
    % --- Align two trees and compute correspondence ---
    % [Q1p, G, ~, Q2p] = AlignFull_qComplexTree_4layers(Q1, Q2, lam_m,lam_s,lam_p, Nitr); 

    % --- Compute the geodesic ---
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


% % --- Save Objs --------
% addpath('GetOBJ')
% Data = used_compTrees;
% used_idxes = [-1];
% obj_folder = saveInputAndMeanObjs_compTrees_rad_4layers(Data, 'chen', used_idxes);
% 
% % ===== Render Objs =====
% addpath('RenderOBJ')
% addpath('RenderOBJ/func_render/');
% addpath('RenderOBJ/func_other/');
% run renderNeuroInputAndMeanObjs.m

save('allVars_Main_modes_withRad.mat')
%% ----- Modes Compuatation -----
% Pad input trees to be compatible with mean
used_qCompTrees_Ready = CompatMultiMax_rad_4layers(used_qCompTrees_Align);

% % check purpose
% for i=1: numel(used_qCompTrees_Ready)
%     used_CompTrees_Ready{i} = qCompTree_to_CompTree_rad_4layers(used_qCompTrees_Ready{i});
% end

% Flatten
qX = [];
for i = 1: tNum
    qX(i, :) = flattenQCompTree_4layers_rad(used_qCompTrees_Ready{i}, lam_m, lam_s, lam_p);
end
save('qX.mat', 'qX');

% covariance
covMat = cov(qX);
qX_mean = mean(qX);
% qX_1_2 = mean(qX(1:2, % load V E U:));


load('V_E_U.mat');
% SVD
[V,E,U] = svd(covMat);
% save('V_E_U.mat', 'V', 'E', 'U');

alpha_1 = sqrt(E(1,1));
alpha_2 = sqrt(E(2,2));
alpha_3 = sqrt(E(3,3));
alpha_4 = sqrt(E(4,4));

Range=3; Step=1;

alpha_1_vec = -Range*alpha_1: (Step*alpha_1): Range*alpha_1;
alpha_2_vec = -Range*alpha_2: (Step*alpha_2): Range*alpha_2;
alpha_3_vec = -Range*alpha_3: (Step*alpha_3): Range*alpha_3;
alpha_4_vec = -Range*alpha_4: (Step*alpha_4): Range*alpha_4;

mode_length= numel(alpha_1_vec);

% mode points
for i=1:mode_length
    
    qX_PC1{i} = alpha_1_vec(i)*V(:,1)' + qX_mean;
    qX_PC2{i} = alpha_2_vec(i)*V(:,2)' + qX_mean;
    qX_PC3{i} = alpha_3_vec(i)*V(:,3)' + qX_mean;
    qX_PC4{i} = alpha_4_vec(i)*V(:,4)' + qX_mean;
end

% % Test purpose
% qX_1_2_Q= unflattenCompTree_4layers_rad(qX_1_2, lam_m, lam_s, lam_p, used_qCompTrees_Ready{2});
% X_1 = qCompTree_to_CompTree_rad_4layers(qX_1_2_Q);

% Unflatten and map-back
q_PC1 = cell(1, mode_length); q_PC2 = cell(1, mode_length); q_PC3 = cell(1, mode_length); q_PC4 = cell(1, mode_length);
PC1 = cell(1, mode_length); PC2 = cell(1, mode_length); PC3 = cell(1, mode_length); PC4 = cell(1, mode_length);

for i=1: mode_length
    % 1st mode
    q_PC1{i} = unflattenCompTree_4layers_rad(qX_PC1{i}, lam_m, lam_s, lam_p, used_qCompTrees_Ready{1});
    PC1{i} = qCompTree_to_CompTree_rad_4layers(q_PC1{i});
    
    % 2nd mode
    q_PC2{i} = unflattenCompTree_4layers_rad(qX_PC2{i}, lam_m, lam_s, lam_p, used_qCompTrees_Ready{1});
    PC2{i} = qCompTree_to_CompTree_rad_4layers(q_PC2{i});
    
    % 3rd mode
    q_PC3{i} = unflattenCompTree_4layers_rad(qX_PC3{i}, lam_m, lam_s, lam_p, used_qCompTrees_Ready{1});
    PC3{i} = qCompTree_to_CompTree_rad_4layers(q_PC3{i});
    
    % 4th mode
    q_PC4{i} = unflattenCompTree_4layers_rad(qX_PC4{i}, lam_m, lam_s, lam_p, used_qCompTrees_Ready{1});
    PC4{i} = qCompTree_to_CompTree_rad_4layers(q_PC4{i});
end

run showModes_compTrees_4layers.m

% --- Save Objs --------
addpath('GetOBJ')
CT_cell = {PC1(1:end), PC2, PC3};
obj_folder = saveThreeModesObjs_compTrees_rad_4layers(CT_cell, 'chen', used_idxes);

% ===== Render Objs =====
addpath('RenderOBJ')
addpath('RenderOBJ/func_render/');
addpath('RenderOBJ/func_other/');
run renderNeuroModesObjs.m


%%%%% PC1-4 is what we want %%%%%%

%% ----- Random Sampling ------
% rand digit between [-2,2]
Digit1=(rand(1, 20)-0.5)*8;
Digit2=(rand(1, 20)-0.5)*8;
Digit3=(rand(1, 20)-0.5)*8;
rand_num = size(Digit1, 2);

rand_sampleX = cell(1, rand_num);
rand_sampleQ = cell(1, rand_num);
rand_sample = cell(1, rand_num);

for i=1:rand_num
    
    rand_sampleX{i} = Digit1(i)*alpha_1 * V(:,1)' + Digit2(i)*alpha_2 * V(:,2)' + Digit3(i)*alpha_3 * V(:,3)' + qX_mean;
    rand_sampleQ{i} = unflattenCompTree_4layers_rad(rand_sampleX{i}, lam_m, lam_s, lam_p, used_qCompTrees_Ready{1});

    rand_sample{i} = qCompTree_to_CompTree_rad_4layers(rand_sampleQ{i});
end

run showRandSamples_compTrees_4layers.m

% --- Save Objs --------
addpath('GetOBJ')
obj_folder = saveRandSamplesObjs_compTrees_rad_4layers(rand_sample, 'chen', used_idxes);

% ===== Render Objs =====
addpath('RenderOBJ')
addpath('RenderOBJ/func_render/');
addpath('RenderOBJ/func_other/');
run renderNeuroRandSamplesObjs.m



% ---- Done ----




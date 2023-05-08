clc;
clear;
close all

%% ############ DATA ############

% Botanical Trees
addpath('utils_data');
addpath('utils_data/utils_data_botanTrees');
data_path = 'botanTrees/botanTrees_txtskl_collections';            
[all_qCompTrees, all_compTrees] = load_botanTrees_rad(data_path);

% Hard coded
G_1_idxes = linspace(1, 6, 6);
G_2_idxes = linspace(7, 9, 3);
G_3_idxes = linspace(10, 32, 23);
G_4_idxes = linspace(33, 38, 6);

used_idxes = G_4_idxes;
[used_qCompTrees, used_compTrees] = augment_botanTrees_rad(all_qCompTrees(used_idxes), ...
                                                           all_compTrees(used_idxes) );

tNum = length(used_qCompTrees);


% --- Save Input Trees --------
addpath('GetOBJ')
obj_folder_inputTree = saveRandSamplesObjs_compTrees_rad_4layers(used_compTrees, 'InputBotanTrees_Collections_G1');


% used_qCompTrees = all_qCompTrees(used_idxes);
% used_compTrees = all_compTrees(used_idxes);

% % Load augmented trees
% load('rand_sampleQ')
% used_qCompTrees = [used_qCompTrees, rand_sampleQ];
% tNum = length(used_qCompTrees);
%% ######### Statistical Models #########

% ##### Mean Computation #####
addpath('utils_statModels','utils_funcs')

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
run showInputAndMean_compBotanTrees_4layers.m

% save('allVars_Main_modes_withRad.mat')
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
% save('qX.mat', 'qX');

% covariance
covMat = cov(qX);
qX_mean = mean(qX);
% qX_1_2 = mean(qX(1:2, % load V E U:));


% load('V_E_U.mat');
% SVD
[V,E,U] = svds(covMat, 6);
% save('V_E_U.mat', 'V', 'E', 'U');

alpha_1 = sqrt(E(1,1));
alpha_2 = sqrt(E(2,2));
alpha_3 = sqrt(E(3,3));
alpha_4 = sqrt(E(4,4));

Range=2; Step=1;

alpha_1_vec = -Range*alpha_1: (Step*alpha_1): Range*alpha_1;   % (-Range: Step: Range)* alpha_1
alpha_2_vec = -Range*alpha_2: (Step*alpha_2): Range*alpha_2;   % (-Range: Step: Range)*alpha_2 
alpha_3_vec = -Range*alpha_3: (Step*alpha_3): Range*alpha_3;   % (-Range: Step: Range)*alpha_3
alpha_4_vec = -Range*alpha_4: (Step*alpha_4): Range*alpha_4;   % (-Range: Step: Range)*alpha_4

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

run showModes_compBotanTrees_4layers.m

% --- Save Objs --------
addpath('GetOBJ')
CT_cell = {PC1(1:end), PC2, PC3};
obj_folder = saveThreeModesObjs_compTrees_rad_4layers(CT_cell, 'BotanTreeCollections-Group-', 4);

% ===== Render Objs =====
addpath('RenderOBJ')
addpath('RenderOBJ/func_render/');
addpath('RenderOBJ/func_other/');
run renderBotanModesObjs.m


%% ----- Random Sampling ------
% rand digit between [-w,w]
Digit1=(rand(1, 40)-0.5)*5;
Digit2=(rand(1, 40)-0.5)*5;
Digit3=(rand(1, 40)-0.5)*5;
rand_num = size(Digit1, 2);

rand_sampleX = cell(1, rand_num);
rand_sampleQ = cell(1, rand_num);
rand_sample = cell(1, rand_num);

for i=1:rand_num
    
    rand_sampleX{i} = Digit1(i)*alpha_1 * V(:,1)' + Digit2(i)*alpha_2 * V(:,2)' + Digit3(i)*alpha_3 * V(:,3)' + qX_mean;
    rand_sampleQ{i} = unflattenCompTree_4layers_rad(rand_sampleX{i}, lam_m, lam_s, lam_p, used_qCompTrees_Ready{1});

    rand_sample{i} = qCompTree_to_CompTree_rad_4layers(rand_sampleQ{i});
end

run showRandSamples_compBotanTrees_4layers.m

% --- Save Objs --------
addpath('GetOBJ')
obj_folder = saveRandSamplesObjs_compTrees_rad_4layers(rand_sample, 'BotanTreeCollections-Group-4');

% ===== Render Objs =====
addpath('RenderOBJ')
addpath('RenderOBJ/func_render/');
addpath('RenderOBJ/func_other/');
run renderBotanRandSamplesObjs.m



% ---- Done ----




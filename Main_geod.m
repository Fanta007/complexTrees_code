clc;
clear;
close all


%% ############ DATA #############
addpath('utils_data')
data_path = 'NeuroData/chen/CNG version/';
allCompTrees = load_trees(data_path);

% return;

%% ######### Statistical Models ############

% ##### Geodesic Computation #####
addpath('utils_statModels')

Q1 = allCompTrees(1);
Q2 = allCompTrees(2);

% parameters
lam_m = 0.01; 
lam_s = 0.1;
lam_p = 1;
Nitr = 3;

fprintf('Q1 to Q2 (with perm), lam_m:%.2f, lam_s:%.2f, lam_p:%.2f\n', ...
                                                    lam_m, lam_s, lam_p);

tm1 = tic;

% ### Pad and Align trees ###
[G,Q1p, Q2p] = ReparamPerm_qCompTrees_4layers_v2(Q1, Q2, lam_m, lam_s, lam_p);

T1 = toc(tm1);
fprintf('Pad and Algin trees - done, timecost:%.4f secs\n', T1);
% --- Align two trees and compute correspondence ---
% [Q1p, G, ~, Q2p] = AlignFull_qComplexTree_4layers(Q1, Q2, lam_m,lam_s,lam_p, Nitr); 

clear A10 qA10
stp1 = 10;
% ### Compute the geodesic，map back to Euclidean space ###
tm2 = tic;
[A10, qA10] = GeodComplexTreesPrespace_4layers(Q1p,Q2p,stp1);

T2 = toc(tm2);
fprintf('Geodesic computation - done, timecost:%.4f secs\n', T2);

% ### visualization ###
addpath('utils_draw')
run showGeodesic_compTrees_4layers.m

%% ##### Mean Tree Computation #####






% for i=1: numel(beta_id_left)
%     plot3(beta{beta_id_left(i)}(1, :), beta{beta_id_left(i)}(2, :), beta{beta_id_left(i)}(3, :),......
%                                                                                             'y', 'LineWidth', 2);
%     hold on;
% end

% for i=1: numel(beta)
%     plot3(beta{i}(1, :), beta{i}(2, :), beta{i}(3, :), 'g', 'LineWidth', 2);
%     
%     text(beta{i}(1, end), beta{i}(2, end), beta{i}(3, end), [num2str(i), ',', num2str(prnt(i))]);
%     
%     hold on;
% end


% for i=1: numel(B.beta)
%     B.beta



return;



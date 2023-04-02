function [final_qCompTrees, final_compTrees] = augment_botanTrees_rad(qCompTrees, compTrees)

tNum = length(qCompTrees);
% parameters
lam_m = 1; 
lam_s = 1;
lam_p = 1;
Nitr = 3;

fprintf('Trees augmentent: Q1 to Q2 (with perm), lam_m:%.2f, lam_s:%.2f, lam_p:%.2f\n', ...
                                                    lam_m, lam_s, lam_p);


% ===== Pad and Align trees =====
tm1 = tic;
final_qCompTrees = qCompTrees;
final_compTrees = compTrees;

% Generate [tNum(tNum-1)/2]*2 extra trees
for idx1 = 2:tNum
    for idx2 = 1:idx1-1
    
        Q1 = qCompTrees{idx1};
        Q2 = qCompTrees{idx2};
        [G,Q1p, Q2p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q1, Q2, lam_m, lam_s, lam_p);

        % ===== Compute the geodesic，map back to Euclidean space =====
        stp1 = 4;
        tm2 = tic;
        [A10, qA10] = GeodComplexTreesPrespace_rad_4layers(Q1p,Q2p,stp1);

        final_qCompTrees{end+1} = qA10{2};
        final_qCompTrees{end+1} = qA10{3};

        final_compTrees{end+1} = A10{2};
        final_compTrees{end+1} = A10{3};
        
        T1 = toc(tm1);
        fprintf('Tree Augment by %d tree and %d tree\n', idx1, idx2)
        fprintf('Tree Augment: Got %d trees, totalTimecost:%.2f secs\n', length(final_qCompTrees), T1)
    end
    
end
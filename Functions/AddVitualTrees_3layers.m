% add zero length branches to Q2 to make it compatible with Q1
% assume:
%   main branches are compatible
%   Q1.K >= Q2.K
%   First Q2.K branches are compatible
% result:
%   Q2p is the same as Q2 on main branch and first Q2.K sides.
%   If Q1.K > Q2.K, then Q2p has null sides Q2.K+1 through Q1.K at
%       same relative arclen positions as corresponding branches on Q1.
function Q2p = AddVitualTrees_3layers(Q1, Q2)

% --- Here Q1 and Q2 is 4-layers trees and we want to add virtual trees to
% Q2 to make the subtree number is equal to that of Q1 ---

if Q1.T0_pointNum ~= Q2.T0_pointNum
    error('Incompatible main branch discretizations.');
end

K0 = Q2.K_sideNum;
K = Q1.K_sideNum;


for i=1: numel(Q1.q)
    Q1.T_sidePointNums(i) = size(Q1.q{i}, 2);
end

for i=1: numel(Q2.q)
    Q2.T_sidePointNums(i) = size(Q2.q{i}, 2);
end

% --- A processing step to make it more safe ---

tmp_diff = Q1.T_sidePointNums(1:K0) - Q2.T_sidePointNums;
non_zero_ind = find(tmp_diff ~= 0);

for i=1: numel(non_zero_ind)
    
    ind = non_zero_ind(i);
    [GAM, E] = DPQ_difflen(Q1.q{ind},Q2.q{ind});
    Q1.q{ind} = GammaActionQ(Q1.q{ind}, GAM);
    
    Q1.T(ind) = size(Q1.q{ind}, 2);
end
    
% --- the step ends ---


if any(Q1.T_sidePointNums(1:K0) ~= Q2.T_sidePointNums)
    error('Incompatible side branch discretizations.');
end

% initialize fields from original structure
Q2p = Q2;

rem_ind = (K0+1):K;

%%% q
Q2p.q = [Q2.q, cell(1,K-K0)];
for i=rem_ind
    Q2p.q{i} = zeros(size(Q1.q{i}));
    if isfield(Q2p, 'q_children') && isfield(Q1, 'q_children')
%         Q2p.q_children{i} = makeZeroST(Q1.q_children{i});
        Q2p.q_children{i} = makeOneVirtualTree_3layers(Q1.q_children{i});
    end
end

%%% tk,sk (not bp)
% t = linspace(0,1,qST2.T0);
% s1 = cumtrapz( t, sum(qST1.q0.^2,1) ) / qST1.len0;
% sk = s1(qST1.bp(rem_ind));
% s2 = cumtrapz( t, sum(qST2.q0.^2,1) ) / qST2.len0;
% qST2p.bp(rem_ind) = round(interp1( s2, 1:qST2.T0, sk ));
Q2p.sk = [Q2p.sk, Q1.sk(rem_ind)];
Q2p.tk_sideLocs = [Q2p.tk_sideLocs, interp1(Q2p.s, Q2p.t_paras, Q2p.sk(rem_ind))];

%%% K, T, len
Q2p.K_sideNum = K;
Q2p.T_sidePointNums(rem_ind) = Q1.T_sidePointNums(rem_ind);
Q2p.len(rem_ind) = 0;
Q2p.func_t_parasAndRad = [];

end
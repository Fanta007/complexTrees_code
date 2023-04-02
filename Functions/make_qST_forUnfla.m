function treeQ = make_qST_forUnfla(q0,q,sk)

% --- Here we do this for safe ---
q0(isnan(q0) == 1) =0;
% ---
treeQ.q0 = q0;
treeQ.q = q;
treeQ.sk = sk;
treeQ.K_sideNum = numel(q);
[treeQ.dimension,treeQ.T0_pointNum] = size(q0);

treeQ.t_paras = linspace(0,1,treeQ.T0_pointNum);

treeQ.s = cumtrapz( treeQ.t_paras, sum(q0.^2,1), 2);
treeQ.len0 = treeQ.s(end);
treeQ.s = treeQ.s/treeQ.len0;

if isempty(treeQ.sk) == 0
    treeQ.tk_sideLocs = interp1(treeQ.s,treeQ.t_paras, treeQ.sk);
else
    treeQ.tk_sideLocs = [0];


treeQ.T_sidePointNums = zeros(1,treeQ.K_sideNum);
treeQ.len = zeros(1,treeQ.K_sideNum);

for k=1:treeQ.K_sideNum
    treeQ.T_sidePointNums(k) = size(treeQ.q{k},2);
    t = linspace(0,1,treeQ.T_sidePointNums(k));
    treeQ.len(k) = trapz( t, sum(treeQ.q{k}.^2,1), 2);
end




end
function [Q1p, G, O] ...
    = AlignNoPerm_qSimpleTree(Q1,Q2, lam_m,lam_s,lam_p, Nitr, verbose)

if nargin < 6
    Nitr = 3;
end
if nargin < 7
    verbose = false; 
end

%%% do first pass reparam/compat
% tm = tic;
[G,Q1p] = ReparamNoPerm_qST(Q1,Q2, lam_m,lam_s,lam_p);
% toc(tm)
if verbose
    fprintf('%f\n',G.E);
end
% finished first reparam (and compatibilization)

O = eye(3);
for k=2:Nitr
    
    Op = Procrustes_SimpleTree(Q1p,Q2, lam_m,lam_s);
    O = Op*O;
    Q1p = ApplyRotationSimpleTree(Q1,O);
    
    %tm = tic;
    [G,Q1p] = ReparamNoPerm_qST(Q1p,Q2, lam_m,lam_s,lam_p);
    %toc(tm)
    if verbose
        fprintf('%f\n',G.E);
    end
end
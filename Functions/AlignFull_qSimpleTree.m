% Algorithm 1 in paper
function [Q1p, G, O] ...
    = AlignFull_qSimpleTree(Q1,Q2, lam_m,lam_s,lam_p, Nitr, verbose)

if nargin < 6
    Nitr = 3;
end
if nargin < 7
    verbose = false; 
end

% tm = tic;
% --- here ReparamPerm_qST will return the branch correspondence (in G) as well as
% add zero-length branches if possible (but not certainly) ---
[G,Q1p] = ReparamPerm_qST(Q1,Q2, lam_m,lam_s,lam_p);

% toc(tm)
% if verbose
%     fprintf('%f\n',G.E);
% end
% 
O = eye(3);
% for k=2:Nitr
%     
%     Op = Procrustes_SimpleTree(Q1p,Q2, lam_m,lam_s);    % --- compute the rotatation matrix for Q1p
%     O = Op*O;
% %     O = eye(3);   % --- here do not let the O change.
%     Q1p = ApplyRotationSimpleTree(Q1,O);
%     
%     %tm = tic;
%     [G,Q1p] = ReparamPerm_qST(Q1p,Q2, lam_m,lam_s,lam_p);
%     %toc(tm)
%     if verbose
%         fprintf('%f\n',G.E);
%     end
% end
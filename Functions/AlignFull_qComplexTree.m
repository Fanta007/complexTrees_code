% Algorithm 1 in paper
function [Q1p, G, O, Q2p] ...
    = AlignFull_qComplexTree(Q1,Q2, lam_m,lam_s,lam_p, Nitr, verbose)

if nargin < 6
    Nitr = 3;
end
if nargin < 7
    verbose = false; 
end

% tm = tic;
% --- here ReparamPerm_qST will return the branch correspondence (in G) as well as
% add zero-length branches if possible (but not certainly) ---

[G,Q1p, Q2p] = ReparamPerm_qST_complex(Q1, Q2, lam_m,lam_s,lam_p);
% toc(tm)
% if verbose
%     fprintf('%f\n',G.E);
% end
% 
O = eye(3);
% for k=2:Nitr
% 
%     Op = Procrustes_ComplexTree(Q1p,Q2p, lam_m,lam_s);    % --- compute the rotatation matrix for Q1p
% %     O = Op*O;
% %     O = eye(3);   % --- here do not let the O change.
%     Q1 = ApplyRotationComplexTree(Q1,Op);
% %     
% %     %tm = tic;
% %     [G,Q1p] = ReparamPerm_qST(Q1p,Q2, lam_m,lam_s,lam_p);
% %     rmfield(Q1p, 'q_children_p');
% %     rmfield(Q2p, 'q_children_p');
%     [G,Q1p, Q2p] = ReparamPerm_qST_complex(Q1,Q2, lam_m,lam_s,lam_p);
% end
%     %toc(tm)
%     if verbose
%         fprintf('%f\n',G.E);
%     end
% end
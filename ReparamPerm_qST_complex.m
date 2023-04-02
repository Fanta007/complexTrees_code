% Algorithm 2 in paper
function [G,qST1p, qST2p] = ReparamPerm_qST_complex(qST1,qST2, lam_m,lam_s,lam_p)
% function [matched,Etotal,E] = ReparamPerm_qST(qST1,qST2, lam_m,lam_s,lam_p)

%%%%% MATCH SIDES %%%%% 
K1 = qST1.K;
K2 = qST2.K;

s1k = qST1.sk;
s2k = qST2.sk;

% build matching energy and side-branch reparameterization matrices
%% --- Original Method ---

gam_side_all = cell(K1,K2);

E = zeros(K1+K2,K1+K2);

for i=1:K1
     
    for j=1:K2
        % --- the process here just makes code safe. ---
        if isempty(qST1.q{i})
            qST1.q{i} = [0,0;0,0;0,0];
        end
        
        if isempty(qST2.q{j})
            qST2.q{j}= [0,0;0,0;0,0];
        end
        
        [gam_side_all{i,j}, Eside0] = DPQ_difflen(qST1.q{i}, qST2.q{j});
        
        % --- compute the overall shape difference between i-th subtree in tree 1 and j-th subtrees of tree 2
        [G, ~] = ReparamPerm_qST(qST1.q_children{i}, qST2.q_children{j}, lam_m,lam_s,lam_p);
        Eside = sqrt(G.E);
        
        E(i,j) = lam_s*Eside + lam_p*(s1k(i)-s2k(j)).^2;
    end
    
    q_zero = makeZeroST(qST1.q_children{i});
    [G1] = ReparamPerm_qST_forZero(qST1.q_children{i}, q_zero, lam_m,lam_s,lam_p);
    E(i,K2+1:end) = lam_s* sqrt(G1.E);
end

for j=1:K2
    clear q_zero
    q_zero = makeZeroST(qST2.q_children{j});
    [G2] = ReparamPerm_qST_forZero(q_zero, qST2.q_children{j}, lam_m,lam_s,lam_p);
    
    E(K1+1:end,j) = lam_s* sqrt(G2.E);
end
% t2 = toc(BB);

% optimize assignment
% a = tic;
[Mvec,Efin] = munkres(E);

% get list of matched pairs and unmatched from munkres output
matched = zeros(0,2);
unmatched1 = [];
unmatched2 = [];
gam_side = cell(1,0);

for i=1:K1
    if Mvec(i)<=K2
        matched = [matched; i,Mvec(i)];
        gam_side = [gam_side, gam_side_all{i,Mvec(i)}];
    else
        unmatched1 = [unmatched1, i];
    end
end

for i= K1+(1:K2)
    if Mvec(i)<=K2
        unmatched2 = [unmatched2, Mvec(i)];
    end
end


%% --- Improved Method ---

% gam_side_all = cell(K1,K2);
% E1 = zeros(K1,K2);
% for i=1:K1
%     %fprintf('%d...',i);
%     for j=1:K2
%         [gam_side_all{i,j}, Eside0] = DPQ_difflen(qST1.q{i},qST2.q{j});
%         [G, ~] = ReparamPerm_qST_new(qST1.q_children{i}, qST2.q_children{j}, lam_m,lam_s,lam_p);
%         Eside = sqrt(G.E);
%         E1(i,j) = lam_s*Eside + lam_p*(s1k(i)-s2k(j)).^2;
%     end
%     
% end
% 
% % t1 = toc(AA);
% 
% [Mvec1,Efin] = munkres(E1);
% 
% matched = zeros(0,2);
% unmatched1 = [];
% unmatched2 = [];
% gam_side = cell(1,0);
% 
% for i=1:K1
%     if Mvec1(i) ~=0
%         matched = [matched; i, Mvec1(i)];
%         gam_side = [gam_side, gam_side_all{i,Mvec1(i)}];
%     else
%         unmatched1 = [unmatched1, i];
%     end
% end
% 
% for i=1:K2
%     if any(Mvec1 == i) == 0
%         unmatched2 = [unmatched2, i];
%     end
% end

%%


[gam0, Emain] = DPQ_difflen(qST1.q0, qST2.q0);  % --- DPQ_difflen computes the difference between two q-space branch.

Etotal = lam_m*Emain + Efin;

G = struct('E',Etotal, 'gam0',gam0, 'gam',{gam_side}, ...
    'matched',matched, 'unmatched1',unmatched1, 'unmatched2',unmatched2);

%%%%% TRANSFORM qST1 %%%%%
%%% q0, t
qST1p.q0 = GammaActionQ(qST1.q0, G.gam0);
qST1p.t = qST2.t;

%% s, len0
qST1p.s = cumtrapz(qST1p.t, sum(qST1p.q0.^2,1) );
qST1p.len0 = qST1p.s(end);

if qST1p.len0 == 0
    qST1p.s = qST1p.t*0.00001;
else
    qST1p.s = qST1p.s/qST1p.len0;
end



m = size(matched,1);
um1= numel(unmatched1);
um2= numel(unmatched2);
K = m + um2 + um1;

%%% qi -- order is [((order of q2)), unmatched1]
qST1p.q = cell(1,K);
qST2p.q = cell(1,K);

for i=1:m
    
    qST1p.q{matched(i,2)} = GammaActionQ(qST1.q{matched(i,1)}, G.gam{i});
    qST1p.q_children{matched(i,2)} = qST1.q_children{matched(i,1)};
    
    qST1p.q_children{matched(i,2)}.q0 = qST1p.q{matched(i,2)};
%     qST2p.q{matched(i,2)} = qST2.q{matched(i,2)};
%     qST1p.q_children{matched(i,2)} = qST1.q_children{matched(i,2)};
end

for i=1:um2
    
    qST1p.q{unmatched2(i)} = zeros(qST1.d, qST2.T(unmatched2(i)));
    qST1p.q_children{unmatched2(i)} = makeZeroST(qST2.q_children{unmatched2(i)});
    qST1p.q_children{unmatched2(i)}.q0 = qST1p.q{unmatched2(i)};
end

for i=1:um1
    
    qST1p.q{m+um2+i} = qST1.q{unmatched1(i)};
    qST1p.q_children{m+um2+i} = qST1.q_children{unmatched1(i)};
    qST1p.q_children{m+um2+i}.q0 = qST1p.q{m+um2+i};
    
end

%%% tk, sk
qST1p.tk = zeros(1,K);
qST1p.sk = zeros(1,K);

% matched,unmatched1 just get updated by gam0
tk1p = interp1(G.gam0, qST1p.t, qST1.tk);
sk1p = interp1(qST1p.t, qST1p.s, tk1p);

for i=1:m
    qST1p.tk(matched(i,2)) = tk1p(matched(i,1)');
    qST1p.sk(matched(i,2)) = sk1p(matched(i,1)');
end

for i=1:um1
    qST1p.tk(m+um2+i) = tk1p(unmatched1(i));
    qST1p.sk(m+um2+i) = sk1p(unmatched1(i));
end

% unmatched2 get arclength position from tree 2
qST1p.sk(unmatched2) = s2k(unmatched2);
qST1p.tk(unmatched2) = interp1(qST1p.s, qST1p.t, qST1p.sk(unmatched2));

%%% K
qST1p.K = K;

%%% T0
qST1p.T0 = qST2.T0;

%%% T
qST1p.T = [];
for i=1:K
    qST1p.T(i) = size(qST1p.q{i},2);
end

%%% len
% qST1p.len = zeros(1,K);
qST1p.len = [];
for k=1:K
    qST1p.len(k) = trapz( sum(qST1p.q{k}.^2,1) / (qST1p.T(k)-1) );
end

%%% d
qST1p.d = qST1.d;

%%% b00
qST1p.b00 = qST1.b00;


qST1p = orderfields(qST1p, ...
    {'t','s','q0','T0','len0','K','q','T','len','tk','sk','d','b00','q_children'});

%% --- Do the matching of layer 2 and layer 3 ---

% --- here we should make the layer 2 branches's number equal for the two trees ---
if numel(qST1p.q_children) > numel(qST2.q_children)
    qST2p = wg_root_AddZeroBranches(qST1p, qST2);
else
    qST2p = qST2;
end


% ---
for i = 1: numel(qST1p.q_children)
    
    % --- 
    [G1, qST1p.q_children_p{i}, qST2p.q_children{i}] = ReparamPerm_qST_wg(qST1p.q_children{i}, qST2p.q_children{i},lam_m,lam_s,lam_p);
        
    if numel(qST1p.q_children_p{i}.q) > numel(qST2p.q_children{i}.q)
        qST2p.q_children_p{i} = AddZeroBranches(qST1p.q_children_p{i}, qST2p.q_children{i});
    else
        qST2p.q_children_p{i} = qST2p.q_children{i};
    end
end

qST1p.q_children = qST1p.q_children_p;
qST2p.q_children = qST2p.q_children_p;


% % --- Here we add the dissimilarity between two 3-layer trees, TO BE CONTINUED ---
% 
% for i=1: numel(qST1p.q_children)
%     % --- here we compute the sum of shape difference and the sum of
%     % location difference between corresponding 2-layers subtrees ---
%     shapeDif_sum
%     locationDif_sum
% end
% 
% G_3layrs  = lam_m*Emain + lam_s * shapeDif_sum + locationDif_sum;
% 
% % --- Finish two 3-layer trees computation ---



end


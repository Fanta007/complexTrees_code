% qST should already be aligned to muQ
function [PC,L,Z,muQX] = PCA_qST(qST,muQ,lam_m,lam_s,lam_p)

d = muQ.d;
K = muQ.K;
T0 = muQ.T0;
T = muQ.T;

n = numel(qST);
p = d*(T0+sum(T))+K;

% flatten trees
qX = zeros(n,p);
for i=1:n
    j0 = 1;
    dj = d*T0;
    j1 = j0+dj;
    qX(i,j0:j1-1) = sqrt(lam_m)*reshape(qST{i}.q0,[1,dj])/(T0-1);
    for k=1:K
        j0 = j1;
        dj = d*T(k);
        j1 = j0+dj;
        try
            qX(i,j0:j1-1) = sqrt(lam_s)*reshape(qST{i}.q{k},[1,dj])/(T(k)-1);
        catch e
%             [i, k]
%             size(qST{i}.q{k})
%             [d, T(k)]
%             dj
%             return
            rethrow(e);
        end
    end
%     qX(i,j1:end) = sqrt(lam_p)*qST{i}.sk(1:K);
    qX(i,j1:end) = sqrt(lam_p)*qST{i}.tk(1:K);
end

% --- U is the matrix of eigenvectors (of covariance matrix), 
% --- Z is the point coordinates in the PCA-space, 
% --- L is the is the matrix of eigenvalues (of covariance matrix) ---
% [U,Z,L,~,~,mu_qX] = pca(qX); 
[U,Z,L,~,~,mu_qX] = princomp(qX); 

% unflatten components
n_PC = numel(L);
PC = cell(1,n_PC);

for i=1:n_PC
    j0 = 1;
    j1 = j0+d*T0;
    PC{i}.q0 = reshape(U(j0:j1-1,i)',[d,T0])*(T0-1)/sqrt(lam_m);
    PC{i}.q = cell(1,K);
    for k=1:K
        j0=j1;
        j1=j0+d*T(k);
        PC{i}.q{k} = reshape(U(j0:j1-1,i)',[d,T(k)])*(T(k)-1)/sqrt(lam_s);
    end
    PC{i}.sk = U(j1:end,i)'/sqrt(lam_p);
end

% unflatten mean
j0 = 1;
j1 = j0+d*T0;
q0 = reshape(mu_qX(j0:j1-1),[d,T0])*(T0-1)/sqrt(lam_m);
q = cell(1,K);
for k=1:K
    j0=j1;
    j1=j0+d*T(k);
    q{k} = reshape(mu_qX(j0:j1-1),[d,T(k)])*(T(k)-1)/sqrt(lam_s);
end
sk = mu_qX(j1:end)/sqrt(lam_p);

b00 = cellfun(@(Q)Q.b00,qST,'uniformoutput',false);
muQX = make_qST(q0,q,sk,mean([b00{:}],2));




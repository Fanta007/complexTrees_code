
function ST1p = ApplyReparamSimpleTree(G, ST1)

% get most fields from original SimpleTree struct
ST1p = ST1;

% apply reparam to main branch and change vector size
t0 = linspace(0,1,ST1.T0);
ST1p.beta0 = interp1(t0,ST1.beta0', G.gam0)';
[~,ST1p.T0] = size(ST1p.beta0);

[M,~] = size(G.matched);

% change matched side branches
for i=1:M
    k = G.matched(i,1);
    
    % reparam matched branches
    t = linspace(0,1, ST1p.T(k));
    ST1p.beta{k} = interp1(t,ST1.beta{k}', G.gam{i})';
    
    % vector sizes of matched branches
    [~,ST1p.T(k)] = size(ST1p.beta{k});
    
end

% find new indices of branch points
for k=1:ST1.K
    bpdist = ST1p.beta0 - repmat(ST1p.beta{k}(:,1), 1,ST1p.T0);
    bpdist = sum(bpdist.^2,1);
    [~,ST1p.bp(k)] = min(bpdist);
end


end
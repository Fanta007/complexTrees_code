function ST = master_to_SimpleTree(TM,d)
ST = struct();

if nargin<2
    d = 3;
end
ST.d = d;

K_old = numel(TM);

K = 0;
ST.beta = cell(1,0);
ST.T = zeros(1,0);

for k=1:K_old
    curr = TM{k};
    
    if curr.level==0
        % found main branch, create: beta0, T0, t
        ST.beta0 = fliplr( curr.vector(1:d,:) );
        [~,ST.T0] = size(ST.beta0);
        ST.t = linspace(0,1,ST.T0);
        
    elseif curr.level==1
        % found another side branch:
        K = K+1;
        % update: beta, T
        ST.beta{K} = fliplr( curr.vector(1:d,:) );
        [~,ST.T(K)] = size(ST.beta{K});
        
    end
    
end

ST.tk = zeros(1,K);
for k=1:K
    bp_diffs = ST.beta0 - repmat(ST.beta{k}(:,1), 1,ST.T0);
    bp_dists = sum( bp_diffs.^2, 1 );
    [~,bp] = min(bp_dists);
    ST.tk(k) = ST.t(bp);
end

ST.K = K;

ST = orderfields(ST, {'t','beta0','T0','K','beta','T','tk','d'});
end
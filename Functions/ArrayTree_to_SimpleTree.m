function ST = ArrayTree_to_SimpleTree(AT)

% if nargin<2
%     [d,T0] = size(AT.beta0);
%     [~,T,K] = size(AT.beta);
%     T = T*ones(1,K);
% elseif nargin<3
%     [d,T0] = size(AT.beta0);
%     [~,~,K] = size(AT.beta);
% elseif nargin<4
%     [d,~] = size(AT.beta0);
% end

ST = struct();


[ST.d, ST.T0] = size(AT.beta0);
[~, ST.T, ST.K] = size(AT.beta);
ST.T = ST.T*ones(1,ST.K);

ST.t = linspace(0,1,ST.T0);
ST.beta0 = AT.beta0;
ST.beta = cell(1,ST.K);
for k=1:ST.K
    ST.beta{k} = AT.beta(:,:,k);
end
ST.tk = ST.t(AT.tt);

ST = orderfields(ST, {'t','beta0','T0','K','beta','T','tk','d'});
end
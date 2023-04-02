function STp = AddZeroBranchesAt_ST(ST,tknew,Tnew)

n = numel(tknew);

if nargin<3
    Tnew = 3*ones(1,n);
end

if n ~= numel(Tnew)
    error('Bad arguments: tknew and Tnew must be same length.');
end

STp = ST;

K = ST.K;
STp.K = K+n;

for k = K+(1:n)
    STp.tk(k) = tknew(k-K);
    STp.T(k) = Tnew(k-K);
    bk = interp1(STp.t,STp.beta0', STp.tk(k))';
    STp.beta{k} = repmat(bk, 1,STp.T(k));
end
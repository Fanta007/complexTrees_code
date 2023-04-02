function Q = make_qST(q0,q,sk,b00)

if nargin<4
    Q.b00_startP = [0;0;0:0];
else
    Q.b00 = b00;
end

Q.q0 = q0;
Q.q = q;
Q.sk = sk;

Q.K = numel(q);
[Q.d,Q.T0] = size(q0);

Q.t = linspace(0,1,Q.T0);

Q.s = cumtrapz( Q.t, sum(Q.q0.^2,1), 2);
Q.len0 = Q.s(end);
Q.s = Q.s/Q.len0;

Q.tk = interp1(Q.s,Q.t, Q.sk);

Q.T = zeros(1,Q.K);
Q.len = zeros(1,Q.K);
for k=1:Q.K
    Q.T(k) = size(Q.q{k},2);
    t = linspace(0,1,Q.T(k));
    Q.len(k) = trapz( t, sum(Q.q{k}.^2,1), 2);
end

Q = orderfields(Q,{'t','s','q0','T0','len0',...
    'K','q','T','len','tk','sk','d','b00'});
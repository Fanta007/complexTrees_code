function [Q1p,Q2p] = CompatMax(Q1,Q2)


%%% main branch
T0 = max(Q1.T0, Q2.T0);
t = linspace(0,1,T0);

% q0
if Q1.T0<T0
    q0_1 = interp1(Q1.t,Q1.q0', t)';
    q0_2 = Q2.q0;
elseif Q2.T0<T0
    q0_1 = Q1.q0;
    q0_2 = interp1(Q2.t,Q2.q0', t)';
else
    q0_1 = Q1.q0;
    q0_2 = Q2.q0;
end

%%% side branches
Km = min(Q1.K,Q2.K);
K = max(Q1.K,Q2.K);

T = max( Q1.T(1:Km), Q2.T(1:Km) );
if Q1.K>Km
    T = [T, Q1.T(Km+1:end)];
elseif Q2.K>Km
    T = [T, Q2.T(Km+1:end)];
end

% q
q_1 = cell(1,K);
q_2 = cell(1,K);
for k=1:Km
    T1 = Q1.T(k); T2 = Q2.T(k);
    tau = linspace(0,1,T(k));
    if T1 < T(k)
        q_1{k} = interp1( linspace(0,1,T1),Q1.q{k}', tau )';
        q_2{k} = Q2.q{k};
    elseif T2 < T(k)
        q_1{k} = Q1.q{k};
        q_2{k} = interp1( linspace(0,1,T2),Q2.q{k}', tau )';
    else
        q_1{k} = Q1.q{k};
        q_2{k} = Q2.q{k};
    end
end

if Q1.K<K
    for k=Km+1:K
        q_1{k} = zeros(Q1.d,T(k));
        q_2{k} = Q2.q{k};
    end
elseif Q2.K<K
    for k=Km+1:K
        q_1{k} = Q1.q{k};
        q_2{k} = zeros(Q2.d,T(k));
    end
end

% sk
sk_1 = Q1.sk;
sk_2 = Q2.sk;
if Q1.K<K
    sk_1 = [sk_1, sk_2(Km+1:K)];
elseif Q2.K<K
    sk_2 = [sk_2, sk_1(Km+1:K)];
end

% make return values
Q1p = make_qST(q0_1,q_1,sk_1,Q1.b00);
Q2p = make_qST(q0_2,q_2,sk_2,Q2.b00);

end
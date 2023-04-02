function E = PrespaceSqDist_qSimpleTree(Q1,Q2, lam_m,lam_s,lam_p)

if Q1.d ~= Q2.d
    error('Different number of spatial dimensions.');
end

if Q1.T0 ~= Q2.T0
    error('Incompatible main branch discretizations.');
end

if Q1.K ~= Q2.K 
    error('Different number of side branches.');
end

if any(Q1.T ~= Q2.T)
    error('Incompatible side branch discretizations.');
end

E = lam_m*trapz(Q1.t, sum( (Q1.q0-Q2.q0).^2, 1), 2);
for k=1:Q1.K
    t = linspace(0,1, Q1.T(k));
    E = E + lam_s*trapz(t, sum( (Q1.q{k}-Q2.q{k}).^2, 1), 2);
end

E = E + lam_p*sum( (Q1.sk-Q2.sk).^2 );
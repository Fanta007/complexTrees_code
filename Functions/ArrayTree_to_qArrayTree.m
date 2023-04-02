function qAT = ArrayTree_to_qArrayTree(Tree)

[d,T,K] = size(Tree.beta);

[q0,len0] = curve_to_q(Tree.beta0);
q0 = q0*sqrt(len0);

q = zeros(d,T,K);
len = zeros(K);
for i=1:K
    [q(:,:,i), len(i)] = curve_to_q(Tree.beta(:,:,i));
    q(:,:,i) = q(:,:,i)*sqrt(len(i));
end

qAT = struct('q0',q0, 'q',q, 'tt',Tree.tt, 'len0',len0, 'len',len);

end

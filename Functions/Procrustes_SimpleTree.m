function O = Procrustes_SimpleTree(Q1,Q2, lam_m,lam_s)

if Q1.T0 ~= Q2.T0
    error('Incompatible main branch discretizations.');
end

K = min(Q1.K , Q2.K);

if any(Q1.T(1:K) ~= Q2.T(1:K))
    error('Incompatible side branch discretizations.');
end

q1 = [lam_m*Q1.q0 , lam_s*cell2mat(Q1.q)];
q2 = [lam_m*Q2.q0 , lam_s*cell2mat(Q2.q)];

TT1 = size(q1,2); 
TT2 = size(q2,2);

if TT1 > TT2
    q2 = [q2, zeros(3,TT1-TT2)];
elseif TT2 > TT1
    q1 = [q1, zeros(3,TT2-TT1)];
end

O = Procrustes_Points(q1,q2);
% A = q2*q1';
% 
% if norm(A,'fro') < 0.00001
%     O = eye(size(A));
% else
%     [U,~,V] = svd(A);
%     
%     if det(A)> 0
%         O = U*V';
%     else
%         O = U*([V(:,1) V(:,2) -V(:,3)])';
%     end
% end


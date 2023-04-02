function O = Procrustes_ComplexTree(Q1,Q2, lam_m,lam_s)

if Q1.T0 ~= Q2.T0
    error('Incompatible main branch discretizations.');
end

K = min(Q1.K , Q2.K);

if any(Q1.T(1:K) ~= Q2.T(1:K))
    error('Incompatible side branch discretizations.');
end

q1 = [lam_m*Q1.q0 , lam_s*cell2mat(Q1.q)];
q2 = [lam_m*Q2.q0 , lam_s*cell2mat(Q2.q)];

% --- write the q-values of the tree into a 3*N's matrix ---
q1 = [Q1.q0];
q2 = [Q2.q0];
for i=1: numel(Q1.q_children_p)
    q1 = [q1, Q1.q{i}];
    q2 = [q2, Q2.q{i}];  
end

for i=1: numel(Q1.q_children_p)
    for j = 1: numel(Q1.q_children_p{i}.q)
        q1 = [q1, Q1.q_children_p{i}.q{j}];
        q2 = [q2, Q2.q_children_p{i}.q{j}];
    end
end



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


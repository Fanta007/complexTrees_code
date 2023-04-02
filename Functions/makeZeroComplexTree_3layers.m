function q_zero = makeZeroComplexTree_3layers(q_children)

q_zero.t = q_children.t;
q_zero.s = q_children.s;
q_zero.q0 = zeros(size(q_children.q0, 1), size(q_children.q0, 2));
q_zero.T0 = q_children.T0;
q_zero.len0 = 0;
% q_zero.len0 = q_children.len0;
q_zero.K = q_children.K;
q_zero.q = q_children.q;
for i = 1: numel(q_zero.q)
    q_zero.q{i} = zeros(size(q_children.q{i}, 1), size(q_children.q{i}, 2));
    q_zero.q_children = makeZeroComplexTree(q_children.q_children);
end

% q_zero.T = zeros(size(q_children.T, 1), size(q_children.T, 2));
q_zero.T = q_children.T;
q_zero.len = zeros(size(q_children.len, 1), size(q_children.len, 2));
% q_zero.tk = zeros(size(q_children.tk, 1), size(q_children.tk, 2));
% q_zero.sk = zeros(size(q_children.sk, 1), size(q_children.sk, 2));
q_zero.tk = q_children.tk;
q_zero.sk = q_children.sk;
q_zero.d = q_children.d;
q_zero.b00 = zeros(size(q_children.b00, 1), size(q_children.b00, 2));


end
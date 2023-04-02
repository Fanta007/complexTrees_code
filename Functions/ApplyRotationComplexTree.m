function qSTp = ApplyRotationComplexTree(qST,O)

qSTp = qST;

qSTp.q0 = O*qSTp.q0;
 
qSTp.q = cellfun( @(q)O*q, qSTp.q, 'UniformOutput',false );  % --- Apply a function to each cell of a cell array.

for i=1: numel(qSTp.q_children)
    for j = 1: numel(qSTp.q_children{i}.q)
%     qSTp.q_children_p{i}.q = cellfun( @(q)O*q, qSTp.q_children_p{i}.q, 'UniformOutput',false ); 
        qSTp.q_children{i}.q{j} = O * qSTp.q_children{i}.q{j};
    end
    qSTp.q_children{i}.q0 = qSTp.q{i};
end

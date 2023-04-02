function qCT = wg_neuro_ComplexTree_to_qComplexTree(CT)


qCT = wg_neuro_SimpleTree_to_qSimpleTree(CT);
% test_CT = qSimpleTree_to_SimpleTree(qCT);

qCT.q_children = cell(1, 0);
qCT.q_children = cell(1, numel(CT.beta_children));
for i=1: numel(CT.beta_children)
    qCT.q_children{i} = wg_neuro_SimpleTree_to_qSimpleTree(CT.beta_children{i});
    
    qCT.q_children{i}.q_children = cell(1, 0);
    for t=1: numel(CT.beta_children{i}.beta_children)
        qCT.q_children{i}.q_children{t} = wg_neuro_SimpleTree_to_qSimpleTree(CT.beta_children{i}.beta_children{t});
        
        qCT.q_children{i}.q_children{t}.q_children = cell(1,0);
        for k = 1: numel(CT.beta_children{i}.beta_children{t}.beta_children)
            qCT.q_children{i}.q_children{t}.q_children{k} = ......
                                                wg_neuro_SimpleTree_to_qSimpleTree(CT.beta_children{i}.beta_children{t}.beta_children{k});
        end
    end
end
    


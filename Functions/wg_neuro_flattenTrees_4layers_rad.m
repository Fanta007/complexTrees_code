function qX = wg_neuro_flattenTrees_4layers_rad(qCT, lam_m, lam_s, lam_p)

% qX = zeros(n,p);
d = 4;
for i=1:numel(qCT)
    j0 = 1;
    T0 = qCT{i}.T0_pointNum;
    dj = d*T0;
    j1 = j0+dj;
    qX(i,j0:j1-1) = sqrt(lam_m)*reshape(qCT{i}.q0,[1,dj])/(T0-1);
    
    for k=1:numel(qCT{i}.q_children)
        
        qX_children = wg_neuro_flattenTrees_3layers_rad({qCT{i}.q_children{k}}, lam_m, lam_s, lam_p);
        
        number = numel(qX_children);
        j0 = j1;
        j1 = j0 + number;
        
        qX(i, j0:j1-1) = qX_children;
    end


    
    j0 = j1;
    j1 = j0+ numel(qCT{i}.q_children);
    
    qX(i,j0:j1-1) = sqrt(lam_p)*qCT{i}.sk(1:end);
end

% --- 输出的qX为输入树木模型（Q空间）的向量表示；
            
end


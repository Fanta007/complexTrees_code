function [ST_1] = trunkRep_to_complexTreeSturcture(trunk1)

%   
ST_1 = trunkRep_to_simpleTreeSturcture(trunk1);

ST_1.beta_children = cell(1, numel(trunk1.children));
for i = 1: numel(trunk1.children)
    ST_1.beta_children{i} = trunkRep_to_simpleTreeSturcture(trunk1.children{i});
    ST_1.beta_children{i}.beta_children = cell(1, numel(trunk1.children{i}.children));
    for j = 1: numel(ST_1.beta_children{i}.beta_children)
        ST_1.beta_children{i}.beta_children{j}.beta0 = ST_1.beta_children{i}.beta{j};
    end
end

end


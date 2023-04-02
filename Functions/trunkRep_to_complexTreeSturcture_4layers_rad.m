function [ST_1] = trunkRep_to_complexTreeSturcture_4layers_rad(trunk1)

%   此处显示详细说明
ST_1 = trunkRep_to_simpleTreeSturcture_rad(trunk1);

ST_1.beta_children = cell(1, numel(trunk1.children));

for i = 1: numel(trunk1.children)
    ST_1.beta_children{i} = trunkRep_to_complexTreeSturcture_rad(trunk1.children{i});

end

end


function [B] = AddOneFieldForNeuro_4layers(B)

%   �˴���ʾ��ϸ˵��
B = AddOneFieldFor_simpleNeuro(B);

% B.beta_children = cell(1, numel(B.children));

for i = 1: numel(B.beta_children)
    B.beta_children{i} = AddOneFieldFor_complexNeuro(B.beta_children{i});

end

end
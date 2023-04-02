function [B] = Add_oneFieldForNeuro(B)

%   �˴���ʾ��ϸ˵��
B = Add_func_t_parasAndRadFieldForSimpleNeuro(B);

B.beta_children = cell(1, numel(B.children));

for i = 1: numel(B.children)
    B.beta_children{i} = Add_func_t_parasAndRadFieldForNeuro_complex(B.beta_children{i});

end

end
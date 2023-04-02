function T = calcuLen_and_norm_3layers(T)

L = 0;

for i=1:size(T.beta0, 2)-1   
    L = L + norm(T.beta0(1:3, i+1) - T.beta0(1:3, i)); 
end

T.len_origin = calcuLen_simpleTree(T);

for i = 1: numel(T.beta_children)-1

    T.beta_children{i}.len_origin = calcuLen_simpleTree(T.beta_children{i});

    
    for j =1: numel(T.beta_children{i}.beta_children)

        T.beta_children{i}.beta_children{j}.len_origin = ...
                        calcuLen_simpleTree(T.beta_children{i}.beta_children{j});
    end
end

            

end












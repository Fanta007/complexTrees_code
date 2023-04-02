function [t_paras] = Compute_t_paras(beta0)

t_paras = 0;
total_sum = 0.0000001;     % --- calculate the total length of the truck.

for j=1: size(beta0, 2)-1
    vec = beta0(1:3, j) - beta0(1:3, j+1);
    total_sum = total_sum + norm(vec, 2);
end


for i=2: size(beta0, 2)
    sum_length = 0;
    for j=1: i-1
        vec = beta0(1:3, j) - beta0(1:3, j+1);
        sum_length = sum_length + norm(vec, 2);
    end
    % --- here make the data in ST.t_paras all different --- 
    sum_length = sum_length + 0.0000001*i;
    t_paras = [t_paras, sum_length/total_sum];
end

% --- Make it safe here --- 

end


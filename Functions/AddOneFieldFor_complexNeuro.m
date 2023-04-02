function [ST_1] = AddOneFieldFor_complexNeuro(ST_1)

%   
ST_1 = AddOneFieldFor_simpleNeuro(ST_1);

% ST_1.beta_children = cell(1, numel(trunk1.children));

for i = 1: numel(ST_1.beta_children)
    
    ST_1.beta_children{i} = AddOneFieldFor_simpleNeuro(ST_1.beta_children{i});
%     ST_1.beta_children{i}.beta_children = cell(1, numel(trunk1.children{i}.children));
    
    for j = 1: numel(ST_1.beta_children{i}.beta)
        ST_1.beta_children{i}.beta_children{j}.beta0 = ST_1.beta_children{i}.beta{j};
        
        Beta0 = ST_1.beta_children{i}.beta_children{j}.beta0;
        
%         --- Compute the function between the paras and radius ---
        t_paras = 0;
        total_sum = 0;     % --- calculate the total length of the truck.

        for jj=1: size(Beta0, 2)-1
            vec = Beta0(1:3, jj) - Beta0(1:3, jj+1);
            total_sum = total_sum + norm(vec, 2);
        end
        
        if total_sum == 0
            t_paras = linspace(0, 1, size(Beta0, 2));
        else

            for ii=2: size(Beta0, 2)
                sum_length = 0;

                for jj=1: ii-1
                    vec = Beta0(1:3, jj) - Beta0(1:3, jj+1);
                    sum_length = sum_length + norm(vec, 2);
                end

                t_paras = [t_paras, sum_length/total_sum];
            end
        end

        ST_1.beta_children{i}.beta_children{j}.t_paras = t_paras;

        F = spline(ST_1.beta_children{i}.beta_children{j}.t_paras, ST_1.beta_children{i}.beta_children{j}.beta0(4, :));

        ST_1.beta_children{i}.beta_children{j}.func_t_parasAndRad = F;
        
        
        data_t_parasAndRad = [ST_1.beta_children{i}.beta_children{j}.t_paras;...
                                ST_1.beta_children{i}.beta_children{j}.beta0(4, :)];
                            
        ST_1.beta_children{i}.beta_children{j}.data_t_parasAndRad = data_t_parasAndRad;
           
    end
     
end

end


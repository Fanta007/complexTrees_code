function Q1p = CorrectRadVal_3layers(Q1p)

% Q1p.q0(4, :) = ppval(Q1p.func_t_parasAndRad, Q1p.t_paras);
Q1p.q0(4, :) = interp1(Q1p.data_t_parasAndRad(1, :), Q1p.data_t_parasAndRad(2, :), Q1p.t_paras);

for i=1: numel(Q1p.q_children)
    
    if isempty(Q1p.q_children{i}.func_t_parasAndRad) == 0   
        
%     Q1p.q_children{i}.q0(4, :) = ppval(Q1p.q_children{i}.func_t_parasAndRad, Q1p.q_children{i}.t_paras);
        Q1p.q_children{i}.q0(4, :) = interp1(Q1p.q_children{i}.data_t_parasAndRad(1, :), Q1p.q_children{i}.data_t_parasAndRad(2, :), ......
                                                            Q1p.q_children{i}.t_paras);

        Q1p.q{i}(4, :) = Q1p.q_children{i}.q0(4, :);

        if isfield(Q1p.q_children{i}, 'q_children') == 1
            for j=1: numel(Q1p.q_children{i}.q_children)

                if isempty(Q1p.q_children{i}.q_children{j}.func_t_parasAndRad) == 0

        %             Q1p.q_children{i}.q_children{j}.q0(4, :) ......
        %               = ppval(Q1p.q_children{i}.q_children{j}.func_t_parasAndRad, Q1p.q_children{i}.q_children{j}.t_paras);

                  Q1p.q_children{i}.q_children{j}.q0(4, :) ......
                      = interp1(Q1p.q_children{i}.q_children{j}.data_t_parasAndRad(1, :), Q1p.q_children{i}.q_children{j}.data_t_parasAndRad(2, :), ......
                                                                Q1p.q_children{i}.q_children{j}.t_paras);

                    Q1p.q_children{i}.q{j}(4, :) = Q1p.q_children{i}.q_children{j}.q0(4, :);
                end

            end
        end
    
    end
end




end
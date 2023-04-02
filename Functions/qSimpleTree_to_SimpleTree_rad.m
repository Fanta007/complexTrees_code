function ST = qSimpleTree_to_SimpleTree_rad(qST)

ST = qST;
% ST = rmfield(qST, {'q','q0','b00','len','len0','s','sk'});

% --- Here make it safe ---
qST.b00_startP(4, 1) = 1;
qST.T0_pointNum = size(qST.q0, 2);

% --- Process the qST.q0 to make the 'NaN' value disappear to make it safe ---
qST.q0(isnan(qST.q0) == 1) = 0;


ST.beta0 = q_to_curve(qST.q0) + repmat(qST.b00_startP,1,qST.T0_pointNum);
ST.beta0(4, :) = qST.q0(4, :);

% --- draw the ST.beta0 ---
% plot3(ST.beta0(1, :), ST.beta0(2, :), ST.beta0(3, :));


% --- re-compute the ST.t_paras ---

ST.t_paras = 0;
total_sum = 0.0000001;     % --- calculate the total length of the truck.

for j=1: size(ST.beta0, 2)-1
    vec = ST.beta0(1:3, j) - ST.beta0(1:3, j+1);
    total_sum = total_sum + norm(vec, 2);
end


for i=2: size(ST.beta0, 2)
    sum_length = 0;
    for j=1: i-1
        vec = ST.beta0(1:3, j) - ST.beta0(1:3, j+1);
        sum_length = sum_length + norm(vec, 2);
    end
    % --- here make the data in ST.t_paras all different --- 
    sum_length = sum_length + 0.0000001*i;
    ST.t_paras = [ST.t_paras, sum_length/total_sum];
end

% --- Make it safe here ---
for t=1: numel(ST.tk_sideLocs)
    if ST.tk_sideLocs(t) == 1
        ST.tk_sideLocs(t) = 0.999;
    end
end     
% ---


if isempty(ST.tk_sideLocs) == 0
    betak0 = interp1(ST.t_paras, ST.beta0', ST.tk_sideLocs)';
else
    betak0 = [];
end

% --- draw the betak0 ---
% scatter3(betak0(1, :), betak0(2, :), betak0(3, :), 'o', 'r'); hold on;


ST.beta = cell(1,ST.K_sideNum);
ST.beta_children = cell(1,ST.K_sideNum);

for k=1:ST.K_sideNum
    
    if isempty(qST.q{k})
        ST.beta{k} = [0, 0, 0]'+ + repmat(betak0(:,k), 1, size(qST.q{k}, 2));
        
    else
        % --- Here we do this for safe ---
        qST.q{k}(isnan(qST.q{k}) == 1) = 0;
        
        ST.beta{k} = q_to_curve(qST.q{k});   % --- now the starting point of ST.beta{k} is at the orgin.
        ST.beta{k} = ST.beta{k} + repmat(betak0(:,k), 1, size(qST.q{k}, 2));
        ST.beta{k}(4,:) = qST.q{k}(4,:);
%     end
    end
    
    ST.beta_children{k}.beta0 = ST.beta{k};
    
    plot3(ST.beta{k}(1, :), ST.beta{k}(2, :), ST.beta{k}(3, :)); hold on;


% ST = orderfields(ST, {'t','beta0','T0','K','beta','T','tk','d'});

end


end
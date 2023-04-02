function [ST_1] = trunkRep_to_simpleTreeSturcture(trunk1)

%   此处显示详细说明
for i = 1: numel(trunk1.point)
    ST_1.beta0(1, i) = trunk1.point(i).x;
    ST_1.beta0(2, i) = trunk1.point(i).y;
    ST_1.beta0(3, i) = trunk1.point(i).z;
end

ST_1.T0_pointNum = numel(trunk1.point);
ST_1.K_sideNum = numel(trunk1.children);

ST_1.T_sidePointNums = [];
ST_1.tk_sideLocs = [];
ST_1.beta = {};
for i=1: numel(trunk1.children)
    for j=1: numel(trunk1.children{i}.point)
    ST_1.beta{i}(1, j) = trunk1.children{i}.point(j).x;
    ST_1.beta{i}(2, j) = trunk1.children{i}.point(j).y;
    ST_1.beta{i}(3, j) = trunk1.children{i}.point(j).z;
    end
    
    ST_1.T_sidePointNums = [ST_1.T_sidePointNums, numel(trunk1.children{i}.point)];
    ST_1.tk_sideLocs = [ST_1.tk_sideLocs, trunk1.bifurcation{i}.t_value];
end

ST_1.dimension = 3;
ST_1.t_paras = 0;
total_sum = 0;     % --- calculate the total length of the truck.

for j=1: size(ST_1.beta0, 2)-1
    vec = ST_1.beta0(:, j) - ST_1.beta0(:, j+1);
    total_sum = total_sum + norm(vec, 2);
end

for i=2: size(ST_1.beta0, 2)
    sum_length = 0;
    for j=1: i-1
        vec = ST_1.beta0(:, j) - ST_1.beta0(:, j+1);
        sum_length = sum_length + norm(vec, 2);
    end
    
    ST_1.t_paras = [ST_1.t_paras, sum_length/total_sum];
end
    
end


function [ CT ] = calcu_circles_ST( CT )

skel = CT.beta0;
c_i = 1;

% figure('color', 'white');
% box on; hold on;
% axis equal; hold on;
pointNum = size(CT.beta0, 2);
CT.beta0_circles = cell(1, 1);
CT.beta_circles = cell(1, numel(CT.beta));

CT.beta0_circles = calcu_circles_for_one_curve(CT.beta0, CT.beta0_rad);
for i= 1: numel(CT.beta)
    CT.beta_circles{i}= calcu_circles_for_one_curve(CT.beta{i}, CT.beta_rad{i});

end


function [ newick_str1, newick_str2 ] = Overall_Tran2newick( trunk1, trunk2 )
%OVERALL_TRAN2NEWICK Summary of this function goes here
%   Detailed explanation goes here
% here start
% 有两个孩子的 需要增加分叉点的个数  此处上下文有Bug
% trunk1 = AdjustDataStruction(trunk1);
% trunk2 = AdjustDataStruction(trunk2);

        
 display(['hi'])       
%   break;   

%-------------------------------------------------------------------------

% DrawInputTree_radius(trunk2);
hold on;
% DrawInputTree_radius(trunk3);
hold on;
% break;
% % test ends
%% get the spline curve function of every branch

trunk1 = calcu_t_value(trunk1);
trunk2 = calcu_t_value(trunk2);
% trunk3 = calcu_t_value(trunk3);
% trunk4 = calcu_t_value(trunk4);

T{1} = trunk1;
T{2} = trunk2;


 T = add_zero_branch_multi(T);  %
 trunk1 = T{1};
 trunk2 = T{2};
%  break;


num = 1;
B_num =1;
for i=1: numel(trunk1.children)
    for j=1: numel(trunk1.children{i}.children)
        trunk1.children{i}.children{j}.label = ['Layer3_L' num2str(num)];
        trunk2.children{i}.children{j}.label = ['Layer3_L' num2str(num)];
        trunk1.children{i}.bifurcation{j}.label = ['Layer2_B' num2str(B_num)];
        trunk2.children{i}.bifurcation{j}.label = ['Layer2_B' num2str(B_num)];

        num = num+1;
        B_num = B_num +1;
    end
    
    trunk1.children{i}.label = ['Layer2_L' num2str(num)];
    trunk2.children{i}.label = ['Layer2_L' num2str(num)];
    trunk1.bifurcation{i}.label = ['Layer1_B' num2str(B_num)];
    trunk2.bifurcation{i}.label = ['Layer1_B' num2str(B_num)];

    num = num+1;
    B_num = B_num+1;
end

%%

trunk1.label = 'Layer1_T';
trunk2.label = 'Layer1_T';

%
disp(['start transforming the trees']);
newick_str1 = Transform2Newick(trunk1);  % 输入时做了标记的trunk
disp(['the first tree format transformation is finished']);

newick_str2 = Transform2Newick(trunk2);
disp(['the second tree format transformation is finished']);


end


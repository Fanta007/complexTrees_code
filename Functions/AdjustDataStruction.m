function [ trunk1 ] = AdjustDataStruction( trunk1 )
%ADJUSTDATASTRUCTIION Summary of this function goes here
%   Detailed explanation goes here
% 有两个孩子的 需要增加分叉点的个数  此处上下文有Bug
add_bifur_num = 0;
k = 1;
new_children = { };
new_bifurcation = { };

bifur_num = numel(trunk1.bifurcation);

for i=1: bifur_num
    if numel(trunk1.children{i}) == 1
        new_children{k} = trunk1.children{i};
        new_bifurcation{k} = trunk1.bifurcation{i};
        k = k+1;
    elseif numel(trunk1.children{i}) ==2
        new_children{k} = trunk1.children{i}(1);
        new_bifurcation{k} = trunk1.bifurcation{i}; k = k+1;
        new_children{k} = trunk1.children{i}(2);
        new_bifurcation{k} = trunk1.bifurcation{i}; k = k+1;
    end
end

trunk1.children = new_children;
trunk1.bifurcation = new_bifurcation;

for i=1: numel(trunk1.children)
    k = 1;
    new_children = { };
    new_bifurcation = { };
    for j = 1: numel(trunk1.children{i}.children)
        if numel(trunk1.children{i}.children{j}) == 1
            new_children{k} = trunk1.children{i}.children{j};
            new_bifurcation{k} = trunk1.children{i}.bifurcation{j};
            k = k+1;
        elseif numel(trunk1.children{i}.children{j}) ==2
            new_children{k} = trunk1.children{i}.children{j}(1);
            new_bifurcation{k} = trunk1.children{i}.bifurcation{j};
            k = k+1;
            new_children{k} = trunk1.children{i}.children{j}(2);
            new_bifurcation{k} = trunk1.children{i}.bifurcation{j};
            k = k+1;
        end
    end
    
    trunk1.children{i}.children = new_children;
    trunk1.children{i}.bifurcation = new_bifurcation;
    
end



end


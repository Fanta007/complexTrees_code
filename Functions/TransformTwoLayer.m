function [ node_array ] = TransformTwoLayer( trunk1 )
%TRAMSFORMTWOLAYER Summary of this function goes here
%   Detailed explanation goes here
% 得到
bifur_num = length(trunk1.bifurcation);

if bifur_num ~=0 
    
    for i= bifur_num+2 : 2*bifur_num+1
        node_array(i).c1 = i-1;                         % c1对应同层次的孩子节点
        node_array(i).c2 = 2*bifur_num+1 - (i-1);     % c2是下一层的节点
    end

    

    if ~isempty(trunk1.label)
        node_array(bifur_num+1).label = trunk1.label;
    % else
    %     node_array(k+1).label = 'L1000';
    end
    
    
    first_t = trunk1.bifurcation{1}.t_value;
    if trunk1.length ~= 0
        sample = 0: first_t * trunk1.length/4 : first_t * trunk1.length;
    else
        sample = zeros(1, 5);
    end
    
    spline_data = fnval(trunk1.SplineFunc, sample);
    
    for k=1:size(spline_data,2)
       node_array(2*bifur_num+1).edge(k, :) = spline_data(:,k);
    end
%     node_array(2*bifur_num+1).label = trunk1.bifurcation{1}.label;
    
    % 添加最顶端支点
    end_t = trunk1.bifurcation{end}.t_value;
    if end_t ~= 1 && trunk1.length ~=0
        sample = end_t *trunk1.length: (1-end_t) * trunk1.length/4 : trunk1.length;
    else
        sample = ones(1, 5)* trunk1.length;
    end
    
    spline_data = fnval(trunk1.SplineFunc, sample);
    node_array(bifur_num+1).edge = spline_data';
    node_array(bifur_num+1).label = trunk1.label;
    
 %  添加叶子节点数据
 
    for i=1: bifur_num
        i
        k = 1;
        for j = 1: length(trunk1.children{i}.point)
            node_array(i).edge(k, :) = [trunk1.children{i}.point(j).x, ...
                                            trunk1.children{i}.point(j).y, ...
                                                trunk1.children{i}.point(j).z,...
                                                    trunk1.children{i}.point(j).r];
            k = k+1;
        end

        node_array(i).label = trunk1.children{i}.label;
    end
   
%%
    for i=1: bifur_num-1
        a = trunk1.bifurcation{i}.t_value;
        b = trunk1.bifurcation{i+1}.t_value;
         
        if a~=b && trunk1.length ~= 0
            sample = a * trunk1.length: (b-a) * trunk1.length/4 : b * trunk1.length;
            
            spline_data = fnval(trunk1.SplineFunc, sample);
            node_array(end - i).edge = spline_data'; 
%             node_array(end- i).label = trunk1.bifurcation{i+1}.label;
        else
            sample = ones(1, 5) * a * trunk1.length;
            
            spline_data = fnval(trunk1.SplineFunc, sample);
            node_array(end - i).edge = spline_data';
%             node_array(end- i).label = trunk1.bifurcation{i+1}.label;
        end
    end   
    
else
    if trunk1.length~= 0
        sample = 0: trunk1.length/4 : trunk1.length;
    else
        sample = zeros(1, 5);
    end
    
    spline_data = fnval(trunk1.SplineFunc, sample);
    node_array(1).edge = spline_data';
    
    node_array(1).label = trunk1.label;
    node_array(1).c1 = [];
    node_array(1).c2 = [];
end


end


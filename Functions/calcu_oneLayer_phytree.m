function [ t_node, leaf_origin_index_vec ] = calcu_oneLayer_phytree( branch, level_2_num, leaf_num )
%UNTITLED Summary of this function goes here
%   输入： branch是2* m的结构体数组，第一行存储一个元素，存储这一层的一个branch
%           第二行存储m个元素，存储下一层的所有branch
node(1,1).position = [branch(1,1).bifurcation(1).x,...
                                branch(1,1).bifurcation(1).y,...
                                        branch(1,1).bifurcation(1).z];

node(1,1).child = branch(1,1).bifurcation(1).child;

origin_index = branch(1,1).bifurcation(1).origin_index;

for i = 1: origin_index
    node(1,1).edge(i,1) = branch(1,1).point(i).x;
    node(1,1).edge(i,2) = branch(1,1).point(i).y;
    node(1,1).edge(i,3) = branch(1,1).point(i).z;
    node(1,1).edge(i,4) = branch(1,1).point(i).r;
end

% 记录前一个点在原始点集中的索引
prior_origin_index = origin_index;

% 计算每个bifurcation对应的edge.


for i =2: length(branch(1,1).bifurcation)
    node(1,i).position = [branch(1,1).bifurcation(i).x, ...
                                branch(1,1).bifurcation(i).y,...
                                        branch(1,1).bifurcation(i).z];

    node(1,i).child = branch(1,1).bifurcation(i).child;
    
    origin_index = branch(1,1).bifurcation(i).origin_index;
    
    k = 1;
    for j = prior_origin_index : origin_index
        node(1,i).edge(k, 1) = branch(1,1).point(j).x;
        node(1,i).edge(k, 2) = branch(1,1).point(j).y;
        node(1,i).edge(k, 3) = branch(1,1).point(j).z;
        node(1,i).edge(k, 4) = branch(1,1).point(j).r;
        k = k+1;
    end
    
    prior_origin_index = origin_index;
end

%--------------------------------------------------------------------------
% the second level
% 处理第二层的数据

 for i = 1: level_2_num
     level_2_node(i).position = [branch(2,i).point(end).x,...
                                    branch(2, i).point(end).y,...
                                                branch(2,i).point(end).z];
     
     level_2_node(i).child = [];
     level_2_node(i).edge = [];   
     
                                            
     for j =1: length(branch(2,i).point)
         level_2_node(i).edge = [level_2_node(i).edge; branch(2,i).point(j).x,  branch(2,i).point(j).y,  branch(2,i).point(j).z, branch(2,i).point(j).r];
     end
     
 end
 
 % 中间处理
 % child_index_vec记录leaf_node（i）对应的原branch的第二行的索引值  % child_index_vec
 leaf_origin_index_vec = [];
 for i =1: leaf_num %length(branch(1,1).bifurcation)
     
     child_index = node(1,i).child(1);
     
     leaf_node(i) = level_2_node(child_index);
     leaf_origin_index_vec = [leaf_origin_index_vec, child_index];
     node(1,i).child = i;
 end
 
 
 % 建立父子关系

 for i = 1 : leaf_num
     f_node(i) = leaf_node(i);
 end
 
 for i = 1 : leaf_num
     f_node(i + leaf_num) = node(1, leaf_num - i+1);       
 end
 
 branch_num = leaf_num;
 
 for i = leaf_num + 2: leaf_num  +branch_num 
     f_node(i).child = [f_node(i).child, i-1];
 end
 
 % 建立每个节点的父亲索引
 for i=1: leaf_num + branch_num
     for j = 1: length(f_node(i).child)
         child = f_node(i).child(j);
         f_node(child).father = i;
     end
 end
 
 % (false)注意： 此时的branch在f_node的存储顺序和Maltab中标准解析出的newick树的顺序是相反的
 %-------------------------------------------------------------------------
 % 度为1的枝干进行合并，保证最后每个节点都有2个孩子节点。
 % f_node是1* (leaf_num + branch_num) 的结构体数组
 
 for i = leaf_num+1 : leaf_num + branch_num 
     
     if length(f_node(i).child) ==1
         
         child_index = f_node(i).child;
         
         old_edge = f_node(child_index).edge;

         % 两个枝干信息合并
         f_node(child_index).edge = [f_node(i).edge; f_node(child_index).edge(2:end, :)]
         
         %标记该点，该点需要删除
         f_node(i).mark = 1;
         
        if f_node(f_node(i).father).child(1) == i
            f_node(f_node(i).father).child(1) = child_index;
            f_node(child_index).father = f_node(i).father;
        end
         
        if f_node(f_node(i).father).child(2) == i
            f_node(f_node(i).father).child(2) = child_index;
            f_node(child_index).father = f_node(i).father;
        end
              
     end
 end
%--------------------------------------------------------------------------
k = 1;
 for i=1: leaf_num + branch_num
     
     if isempty(f_node(i).mark) == 1 
         t_node(k) = f_node(i);
         k = k+1;
     end
     
     if f_node(i).mark ==1;
         for j = leaf_num+1: leaf_num + branch_num
             if j ~= i
                 
             if f_node(j).child(1) > i
                 f_node(j).child(1) = f_node(j).child(1) - 1;
             end
             
             if f_node(j).child(2) > i
                 f_node(j).child(2) = f_node(j).child(2) - 1;
             end
             
             end
         end
         
     end
     
 end


end


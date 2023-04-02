function [ array_phytree, newick_string_I ] = Trunk2array_phytree_4_Layers( trunk1 )

% The input is the trunk-representation of trees, with labled branches.
% The output is the array for the newick file writing

array_main = TransformTwoLayer(trunk1);

for i=1: numel(trunk1.children)
    sub_trunk = trunk1.children{i};
    arr = Trunk2array_phytree_3_Layers(sub_trunk);
    array2{i} = arr;
end

array = [array2(1:end)];

for i = ceil(numel(array_main)/2) : numel(array_main)
    array = [array, array_main(i)];
end

% ---- an important adjustment
for i=1: ceil(numel(array)/2)
    if numel(array{i}) ~= 1
        for j=1: ceil(numel(array{i})/2)
            array{i}(j).c1 =  array{i}(j).c1_phyIndex;
            array{i}(j).c2 =  array{i}(j).c2_phyIndex;
            array{i}(j).c1_index = [];
            array{i}(j).c2_index = [];
            array{i}(j).depth = [];
            array{i}(j).phytree_ind = [];
%             array{i}(j).c1_phyIndex =
%             array{i}(j).c2_phyIndex = 
        end
        
        for j = ceil(numel(array{i})/2)+1 : numel(array{i})
            array{i}(j).c1 =  array{i}(j).c1_phyIndex;
            array{i}(j).c2 =  array{i}(j).c2_phyIndex;
            array{i}(j).c1_index = [];
            array{i}(j).c2_index = [];
            array{i}(j).depth = [];
            array{i}(j).phytree_ind = [];
%             array{i}(j).c1_phyIndex = [];
%             array{i}(j).c2_phyIndex = [];
        end
        
    else
        array{i}(1).c1 = [];
        array{i}(1).c2 = [];
        array{i}(1).c1_index = [];
        array{i}(1).c2_index = [];
        array{i}(1).depth = [];
        array{i}(1).phytree_ind = [];
%         array{i}(1).c1_phyIndex = [];
%         array{i}(1).c2_phyIndex = [];
    end
end

% % for debuging
% figure;
% axis equal; hold on;
% for i=2: numel(array)
%      DrawArray_New(array{i}, numel(array{i}));
% end

% ----
%%
%%
%%
for i=1: ceil(numel(array)/2)
    num_before = 0;
    if i ~=1
        for k = 1: i-1
            num_before = num_before+ numel(array{k});
        end
    end
                    
    for j=1: numel(array{i})
        array{i}(j).new_ind = j+ num_before;
    end
end

num_above =0;
for i=1: ceil(numel(array)/2)
    num_above = num_above+ numel(array{i});
end


for i= ceil(numel(array)/2)+1: numel(array)
    array{i}(1).new_ind = (i-ceil(numel(array)/2))+ num_above;
end

%%
for i=1: ceil(numel(array)/2)
    if ceil(numel(array{i})/2)+1 <= numel(array{i})
        for j= ceil(numel(array{i})/2)+1 : numel(array{i})
            array{i}(j).c1_index = array{i}(array{i}(j).c1).new_ind;
            array{i}(j).c2_index = array{i}(array{i}(j).c2).new_ind;
        end
%         
    else
        array{i}(1).c1_index = [];
        array{i}(1).c2_index = [];
    end
        
end

for i= ceil(numel(array)/2)+1: numel(array)
    array{i}(1).c1_index = array{array{i}(1).c1}(end).new_ind;
    array{i}(1).c2_index = array{array{i}(1).c2}(end).new_ind;
end

%%
flag =100;
I = 0;
J = 0;
for i=1: ceil(numel(array)/2)
    for j=1: numel(array{i})
  
        array_new(array{i}(j).new_ind).edge = array{i}(j).edge;
        array_new(array{i}(j).new_ind).label = array{i}(j).label;
        array_new(array{i}(j).new_ind).c1 = array{i}(j).c1;
        array_new(array{i}(j).new_ind).c2 = array{i}(j).c2;
        array_new(array{i}(j).new_ind).c1_index = array{i}(j).c1_index;
        array_new(array{i}(j).new_ind).c2_index = array{i}(j).c2_index;
        
    end
end

j=1;
for i= ceil(numel(array)/2)+1: numel(array)
    array_new(array{i}(j).new_ind).edge = array{i}(j).edge;
    array_new(array{i}(j).new_ind).label = array{i}(j).label;
    array_new(array{i}(j).new_ind).c1 = array{i}(j).c1;
    array_new(array{i}(j).new_ind).c2 = array{i}(j).c2;
    array_new(array{i}(j).new_ind).c1_index = array{i}(j).c1_index;
    array_new(array{i}(j).new_ind).c2_index = array{i}(j).c2_index;
    
end

array_new = calcu_depth_num(array_new, numel(array_new), 1);

%%
for i=1: numel(array_new)

%     disp(['current index is :', num2str(i)]);
    % cscvn的输入格式
    edge_data = array_new(i).edge';
    
    %对每个branch做样条插值拟合
    SplineFunc=cscvn(edge_data);      %求出第i个branch的拟合函数
    size_p=size(SplineFunc.breaks,2);   %记录控制点的数目
    length=SplineFunc.breaks(size_p);   %求出弧长
    sample=0:length/4:length;           %求出采样步长,这里采出10个点
    spline_data=fnval(SplineFunc, sample);
    %
    %将插值拟合得到的点写进t_node(i).edge_spline中。
    for k=1:size(spline_data,2)
       array_new(i).edge_spline(k,1) = spline_data(1,k);
       array_new(i).edge_spline(k,2) = spline_data(2,k);
       array_new(i).edge_spline(k,3) = spline_data(3,k);
       array_new(i).edge_spline(k,4) = spline_data(4,k);
    end
end

% hold on;

% -- for debuging
% figure('color', 'k');
% axis equal; hold on;
% for i=1: numel(array_new)
%     DrawArray_New(array_new, nu)
% 
% end
% --
%%
depth_num = [];
for i=1: numel(array_new)
    if isempty(array_new(i).depth) == 0
        depth_num = [depth_num, array_new(i).depth];
    end
end

max_depth = max(depth_num);
cur_depth = max_depth;

k = ceil(numel(array_new)/2) +1;
c_k = ceil(numel(array_new)/2);
%%
% array_phytree是有顺序的节点存储数组, 是正确的for phytree writing 的数组
for i=1: numel(array_new)
    array_new(i).phytree_ind = 0;
    array_new(i).c1_phyIndex = 0;
    array_new(i).c2_phyIndex = 0;
end

% if numel(array_new) ==1
%     array_phytree(1) = array_new(1);
% else
    while cur_depth >=1
        for i=1: numel(array_new)
            if array_new(i).depth == cur_depth;
                array_phytree(k) = array_new(i);
                array_new(i).phytree_ind = k;
                k= k+1;
            end
        end
        cur_depth = cur_depth-1;
    end
% end

for i= ceil(numel(array_new)/2) +1 : numel(array_new)
    c1_ind = array_phytree(i).c1_index;
    c2_ind = array_phytree(i).c2_index;
    
    if array_new(c1_ind).phytree_ind ==0
        array_phytree(c_k) = array_new(c1_ind);
        array_phytree(i).c1_phyIndex = c_k;
        
        array_new(c1_ind).phytree_ind = c_k;
        c_k = c_k-1;
    else
        array_phytree(i).c1_phyIndex = array_new(c1_ind).phytree_ind;
    end
    
    if array_new(c2_ind).phytree_ind ==0
        array_phytree(c_k) = array_new(c2_ind);
        array_phytree(i).c2_phyIndex = c_k;
        
        array_new(c2_ind).phytree_ind = c_k;
        c_k = c_k-1;
    else
        array_phytree(i).c2_phyIndex = array_new(c2_ind).phytree_ind;
    end
end

% figure;
% axis equal; hold on;
% for i=1: numel(array_phytree)
%      X = array_phytree(i).
% end


%%  write to the newick file
%%
%%
k = 1;

for i = ceil(numel(array_phytree)/2) +1 : numel(array_phytree)
    pointers(k, :) = [array_phytree(i).c1_phyIndex, array_phytree(i).c2_phyIndex];
    k = k+1;
end


for i=1: ceil(numel(array_phytree)/2)
    names{i, 1} = array_phytree(i).label;
end

% for i=1: numel(array_phytree)
%     names{i, 1} = array_phytree(i).label;
% end


[MM] = phytree(pointers, names);
% MM = class(MMM,'phytree')
       
%%  
for i=1: numel(array_phytree)
    
    % cscvn的输入格式
    edge_data = array_phytree(i).edge';
    
    %对每个branch做样条插值拟合
    SplineFunc=cscvn(edge_data);      %求出第i个branch的拟合函数
    size_p=size(SplineFunc.breaks,2);   %记录控制点的数目
    length=SplineFunc.breaks(size_p);   %求出弧长
    sample=0:length/4:length;           %求出采样步长,这里采出10个点
    spline_data=fnval(SplineFunc, sample);
    %
    
    %将插值拟合得到的点写进t_node(i).edge_spline中。
    for k=1:size(spline_data,2)
       array_phytree(i).edge_spline(k,1) = spline_data(1,k);
       array_phytree(i).edge_spline(k,2) = spline_data(2,k);
       array_phytree(i).edge_spline(k,3) = spline_data(3,k);
       array_phytree(i).edge_spline(k,4) = spline_data(4,k);
    end
end

boot_data = [];
for i =1 : numel(array_phytree)
    
    boot_data = [];
    for j=1: 5
        boot_data = [boot_data, num2str(array_phytree(i).edge_spline(j,1)), ' ',...
                                    num2str(array_phytree(i).edge_spline(j,2)),' ',...
                                        num2str(array_phytree(i).edge_spline(j,3)),' ',...
                                            num2str(array_phytree(i).edge_spline(j,4)),' '];
%    boot_data = [boot_data,'0 0 0 '];
    end
    boot{i, 1} = boot_data;
end

newick_string_I = get_newick_str(MM,boot);

%% just a test.
[tree, boot_I] = phytree_read(newick_string_I);
V = get(tree);

M = phytree(V.Pointers, V.NodeNames)

% M，boot对应的树的newick format 表示格式
newick_string = get_newick_str(M, boot_I);

for i=1: numel(boot_I)
    edge_data = str2num(boot_I{i});
    for j=1:5;
        edges{i}(j, 1) = edge_data((j-1)*4 + 1);
        edges{i}(j, 2) = edge_data((j-1)*4 + 2);
        edges{i}(j, 3) = edge_data((j-1)*4 + 3);
        edges{i}(j, 4) = edge_data((j-1)*4 + 4);
    end
end


end


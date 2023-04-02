function str = get_newick_str(tr, boot)
% 得到tr， boot的newick format data 

if numel(tr)~=1
     error('Bioinfo:phytree:getstr:NoMultielementArrays',...
           'Phylogenetic tree must be an 1-by-1 object.');
end

%得到phytree tr的数据信息，存到V中
V = get(tr);
numBranches = V.NumBranches;
numLeaves = numBranches + 1;
numLabels = numBranches + numLeaves;    % numLabels统计所有节点（叶子&非叶子）的数量

label_name = V.NodeNames;   %所有的label的集合

for i = 1:numLabels;
    % 如果是叶子节点，需要写出具体的标号（R1，L1等）
    if i<=numLeaves        
        node_info{i} = [label_name{i} ':' '[' boot{i} ']'];
    else
        node_info{i} = [':' '[' boot{i} ']']; 
    end

end

%tree_str 存储的是各个循环中树的newick格式数据，最后一项是最终树的newick格式
tree_str = cell(1,10000);
for i = 1:numBranches
    if V.Pointers(i,1) > numLeaves
        t1 = tree_str{ V.Pointers(i,1) };
    else
        t1 = node_info{ V.Pointers(i,1) };
    end
    
    if V.Pointers(i,2) > numLeaves
        t2 = tree_str{ V.Pointers(i,2) };
    else
        t2 = node_info{ V.Pointers(i,2) };
    end

    tree_str{i  +numLeaves} = [ '(' t1 ',' t2 ')' node_info{i+numLeaves} ]; 
end

str = sprintf(tree_str{numLabels});

end


function [ trunk ] = Newick2trunk_rep( tree_1 )
%NEWICK2TRUNK_REP Summary of this function goes here
%   Detailed explanation goes here
[tree, boot] = phytree_read(tree_1);
V = get(tree);

for i=1: numel(boot)
    edge_data = str2num(boot{i});
    for j=1:5;
        edges{i}(j, 1) = edge_data((j-1)*4 + 1);
        edges{i}(j, 2) = edge_data((j-1)*4 + 2);
        edges{i}(j, 3) = edge_data((j-1)*4 + 3);
        edges{i}(j, 4) = edge_data((j-1)*4 + 4);
    end
end

pointers = V.Pointers;
edges = makeBranchesTight( edges, pointers, V.NumNodes, V.NumLeaves);
pointers = [zeros(size(V.Pointers, 1)+1, 2);V.Pointers];

%%
trunk = FormOneBranch(V.NumNodes, pointers, edges, V.NodeNames, V.NumLeaves, 1);

C_inds = trunk.child_inds;

for i=1: numel(C_inds)
    trunk.children{i} = FormOneBranch(C_inds(i), pointers, edges, V.NodeNames, V.NumLeaves, 2);
    
    for j=1: numel(trunk.children{i}.child_inds)
        trunk.children{i}.children{j} = ...
                         FormOneBranch(trunk.children{i}.child_inds(j), pointers, edges, V.NodeNames, V.NumLeaves, 3);
    end
end

end


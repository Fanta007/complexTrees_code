function [ trunk1, children, children_children, end_children, edges,edges_length, f_pointers, pointers, leafNames, numLeaves ] = Newick2trunk_rep( tree_1)
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

 
global re_count; 
re_count = 0;
pointers = V.Pointers;
edges = makeBranchesTight( edges, pointers, V.NumNodes, V.NumLeaves);
% --- test 
% figure('color', 'w','Position',[100,100,800,600]);
% axis equal;  hold on;
% axis on;  hold on;
% for i=1:numel(edges)
%     X = edges{i}(:, 1);
%     Y = edges{i}(:, 2);
%     Z = edges{i}(:, 3);
%     
%     plot3(X, Y, Z, 'r'); hold on;
%     text(X(end), Y(end), Z(end), [num2str(i)]); 
%     pause(0.05);
%     hold on;
% end

% ---

pointers = [zeros(size(V.Pointers, 1)+1, 2);V.Pointers];
for i= V.NumLeaves +1 : V.NumNodes
    ind1 = pointers(i, 1);
    ind2 = pointers(i, 2);
    f_pointers(ind1) = i;
    f_pointers(ind2) = i;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%

% --- 
visited = [];
for i=1: numel(V.LeafNames)
    if V.LeafNames{i}(6) == '1'
        indexes = i;
        cur_ind = i;
        visited = i;
        while cur_ind <= V.NumNodes-1 & sum(ismember(visited, f_pointers(cur_ind) )) == 0
            indexes = [indexes, f_pointers(cur_ind)];
            visited = [visited, f_pointers(cur_ind)];
            cur_ind = f_pointers(cur_ind);
        end
    end
end

points = [];
bifurcations=[];
for i=1: numel(indexes)
    bifurcations = [bifurcations; edges{indexes(numel(indexes)-i+1)}(end, :)];
    points = [points; edges{indexes(numel(indexes)-i+1)}];
end
trunk1.points = points;
trunk1.bifurcations = bifurcations;
trunk1.indexes = indexes;

%%
k =1;
for i=1: numel(V.LeafNames)
    clear indexes
    if V.LeafNames{i}(6) == '2'
        indexes = i;
        cur_ind = i;
        visited = [visited, i];
        while cur_ind <= V.NumNodes-1 & sum(ismember(visited, f_pointers(cur_ind) )) == 0
            indexes = [indexes, f_pointers(cur_ind)];
            visited = [visited, f_pointers(cur_ind)];
            cur_ind = f_pointers(cur_ind);
        end
        points = [];
        bifurcations = [];
        for ii=1: numel(indexes)
            if ii ==1
                bifurcations = [bifurcations; edges{indexes(numel(indexes)-ii+1)}(end, :)];
                points = [points;edges{indexes(numel(indexes)-ii+1)}];
            elseif  isequal( edges{indexes(numel(indexes)-ii+1)}(1, 1:3), points(end, 1:3) )  == 1 
                bifurcations = [bifurcations; edges{indexes(numel(indexes)-ii+1)}(end, :)];
                points = [points;edges{indexes(numel(indexes)-ii+1)}];
            else
                %here guarantee again the edge are tight
                move_vec = points(end, 1:3) - edges{indexes(numel(indexes)-ii+1)}(1, 1:3);
                edges{indexes(numel(indexes)-ii+1)}(:, 1) = edges{indexes(numel(indexes)-ii+1)}(:, 1) + ones(5,1)*move_vec(1);
                edges{indexes(numel(indexes)-ii+1)}(:, 2) = edges{indexes(numel(indexes)-ii+1)}(:, 2) + ones(5,1)*move_vec(2);
                edges{indexes(numel(indexes)-ii+1)}(:, 3) = edges{indexes(numel(indexes)-ii+1)}(:, 3) + ones(5,1)*move_vec(3);

                bifurcations = [bifurcations; edges{indexes(numel(indexes)-ii+1)}(end, :)];
                points = [points;edges{indexes(numel(indexes)-ii+1)}];
            end                
        end
        
        children{k}.points = points;
        children{k}.bifurcations = bifurcations;
        children{k}.indexes = indexes;
        children{k}.name = V.LeafNames{i};
        
        k = k+1;
    end
end

%%
% --- search the all the Layer3 branches
k =1;
children_children = { };
for i=1: numel(V.LeafNames)
    clear indexes
    if V.LeafNames{i}(6) == '3'
        indexes = i;
        cur_ind = i;
        visited = [visited, i];
        while cur_ind <= V.NumNodes-1 & sum(ismember(visited, f_pointers(cur_ind) )) == 0
            indexes = [indexes, f_pointers(cur_ind)];
            visited = [visited, f_pointers(cur_ind)];
            cur_ind = f_pointers(cur_ind);
        end
        points = [];
        bifurcations = [];
        for ii=1: numel(indexes)
            bifurcations = [bifurcations; edges{indexes(numel(indexes)-ii+1)}(end, :)];
            points = [points;edges{indexes(numel(indexes)-ii+1)}];
        end
        
        children_children{k}.points = points;
        children_children{k}.bifurcations = bifurcations;
        children_children{k}.indexes = indexes;
        children_children{k}.name = V.LeafNames{i};
        
        k = k+1;
    end
end

    
%%
%%
k =1;
end_children = { };
for i=1: numel(V.LeafNames)
    
    clear indexes
    if V.LeafNames{i}(6) == '4'
        
        points = edges{i};
        bifurcations = edges{i}(end, :);
        end_children{k}.points = points;
        end_children{k}.bifurcations = bifurcations;
        end_children{k}.index = i;
        end_children{k}.name = V.LeafNames{i};
        k = k+1;
    end
end



leafNames = V.LeafNames;
numLeaves = V.NumLeaves;

for i=1: numel(children)
    I= children{i}.indexes;
    A = [];
    for j=1: numel(I)
        if I(j) >= V.NumLeaves+1
            A = [A, pointers(I(j),1), pointers(I(j),2)];
        end
    end
    
    children{i}.cIndexes = setdiff(A, I);
    
    children{i}.length = calcu_branch_length(children{i}.points);
end


for i=1: numel(edges)
    edges_length(i) = calcu_branch_length(edges{i});
end


disp('haha');

end

function length = calcu_branch_length(branch)

% branch ÊÇn*4µÄ¾ØÕó
length = 0;
for i=1: size(branch, 1)-1
    length = length+ norm( branch(i, 1:3) - branch(i+1, 1:3) )
end
    
end


function [trunk, branch, branch_num] = LoadAllTrees_3layers(folder_name)
% Read the .txtskl tree file and output their trunk representation


F = dir([folder_name, '/*.txtskl']);
% F = F(1:3, :)
for i=1: size(F, 1)
    s =  F(i).name;
%     s(find(isspace(s))) = [];
    Files{i} = s;
end


for i_tree = 1: size(F, 1)
    
    [branch{i_tree}, branch_num{i_tree}] = ReadSkelFile([folder_name, '/', Files{i_tree}]);
        
    if numel(branch_num{i_tree}) == 1
        branch_num{i_tree}(2) = 0;
        branch{i_tree}(2, 1) = branch{i_tree}(1, 1);
    end
    
    if numel(branch_num{i_tree}) == 2
        branch_num{i_tree}(3) = 0;
        branch{i_tree}(3, 1) = branch{i_tree}(1, 1);
    end
    
    if numel(branch_num{i_tree}) == 3
        branch_num{i_tree}(4) = 0;
        branch{i_tree}(4, 1) = branch{i_tree}(1, 1);
    end
    
    clear trunk1 branch1
    trunk1 = TrunkStruction(branch{i_tree}, branch_num{i_tree});
    branch1 = branch{i_tree};
    
    
    trunk{i_tree} = trunk1;
     
end


end


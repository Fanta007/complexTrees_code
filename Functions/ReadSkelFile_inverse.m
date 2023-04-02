function [branch, branch_num] = ReadSkelFile_inverse( skelFile )
%READSKELFILE Summary of this function goes here
%   Detailed explanation goes here

fp1 = fopen(skelFile, 'r');
total_levelNum = fscanf(fp1, '%d', [1,1]);

for i = 1:total_levelNum
    
    if i == 1
        layer_string = fscanf(fp1, '%s', [1,1]);
        layer_id = fscanf(fp1, '%d', [1,1]);                        %layer_id是指的第几层layer.
        branch_num(i) = fscanf(fp1, '%d', [1,1])
       
        fatherBranch_id = fscanf(fp1, '%d', [1,1]);                       %父亲在上一层的id
        fatherBranch_point_id = fscanf(fp1, '%d', [1,1]);                     %父亲枝干中具体的节点
        branch_point_num = fscanf(fp1, '%d', [1,1]);                %记录每个孩子的点的个数
        
        branch(i,1).father_branch_id = fatherBranch_id;
        branch(i,1).father_point_id = fatherBranch_point_id;
            
            for j = 1 : branch_point_num                     %具体每个孩子branch的skeleton的坐标值和对应的半径
                branch(i,1).point(j).x = -fscanf(fp1, '%f', [1,1]);% inverse x
                branch(i,1).point(j).y = -fscanf(fp1, '%f', [1,1]);% inverse y
                branch(i,1).point(j).z = fscanf(fp1, '%f', [1,1]);
                branch(i,1).point(j).r = fscanf(fp1, '%f', [1,1]);
            end
    end
  
    if i~=1        
        layer_string = fscanf(fp1, '%s', [1,1]);
        layer_id = fscanf(fp1, '%d', [1,1]);                                    %layer_id是指的第几层layer.
        branch_num(i) = fscanf(fp1, '%d', [1,1]);

        for k = 1:branch_num(i)
            fatherBranch_id = fscanf(fp1, '%d', [1,1]);                              %父亲在上一层的id
            fatherBranch_point_id = fscanf(fp1, '%d', [1,1]);                              %这个branch所对应的孩子数
            branch_point_num = fscanf(fp1,'%d',[1,1]);                        %记录每个孩子的点的个数
            
            branch(i,k).father_branch_id = fatherBranch_id;
            branch(i,k).father_point_id = fatherBranch_point_id;
            
            for j = 1:branch_point_num                                       %具体每个孩子branch的skeleton的坐标值和对应的半径
                branch(i,k).point(j).x = -fscanf(fp1,'%f',[1,1]);
                branch(i,k).point(j).y = -fscanf(fp1,'%f',[1,1]);
                branch(i,k).point(j).z = fscanf(fp1,'%f',[1,1]);
                branch(i,k).point(j).r = fscanf(fp1,'%f',[1,1]);
            end
        end      
    end
end

% 把branch_num转换成列向量
branch_num = branch_num';
fclose(fp1);
    

end


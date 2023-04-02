function [ array ] = calcu_depth_num( array, root, root_depth )
%CALCU_LEVEL_NUM Summary of this function goes here
%   Detailed explanation goes here

    if isempty(array(root).c1_index) == 1 && isempty(array(root).c2_index) ==1
        array(root).depth = [];
        return;
    end
    
    array(root).depth = root_depth;
    
    a = array(root).c1_index;
    array = calcu_depth_num(array, a, root_depth+1);
    
    b = array(root).c2_index;
    array = calcu_depth_num(array, b, root_depth+1);

end


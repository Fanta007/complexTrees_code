function [ T1, T2 ] = make_zeroBranch_equal( T1, T2 )
%ADD_ZERO_BRANCH Summary of this function goes here
%   Detailed explanation goes here
% 只考虑双层枝干问题

    child_num_1 = numel(T1.children);
    child_num_2 = numel(T2.children);
    if T1.zero_num > T2.zero_num
        trunk1 = T1; trunk2 = T2; flag =0;
    else
        trunk1 = T2; trunk2 = T1; flag =1;
    end
    
   

    change_num = floor((trunk1.zero_num - trunk2.zero_num)/2);
    I = setdiff(trunk1.zeroChild_index, trunk2.zeroChild_index);
    
    P = randperm(numel(I));
    N_zero_ind = I(P(1:change_num));
    zero_ind = setdiff(I, N_zero_ind);
    
    for i=1: numel(N_zero_ind)
        trunk1.children{N_zero_ind(i)}.point = trunk2.children{N_zero_ind(i)}.point;
        trunk1.children{N_zero_ind(i)}.length = trunk2.children{N_zero_ind(i)}.length;
        
    end
    
    for i=1: numel(zero_ind)
        trunk2.children{zero_ind(i)}.point = trunk1.children{zero_ind(i)}.point;
        trunk2.children{zero_ind(i)}.length = trunk1.children{zero_ind(i)}.length;
    end
    
    %%
    zero_num = 0;
    zeroChild_index = [];
    for i=1: numel(trunk1.children)
        if trunk1.children{i}.length == 0
            zero_num = zero_num+1;
            zeroChild_index = [zeroChild_index, i];
        end
    end

    trunk1.zero_num = zero_num;
    trunk1.zeroChild_index = zeroChild_index;
    %%
    zero_num = 0;
    zeroChild_index = [];
    for i=1: numel(trunk2.children)
        if trunk2.children{i}.length == 0
            zero_num = zero_num+1;
            zeroChild_index = [zeroChild_index, i];
        end
    end

    trunk2.zero_num = zero_num;
    trunk2.zeroChild_index = zeroChild_index;
    
    
    
    if flag == 0
        T1 = trunk1; T2 = trunk2;
    elseif flag ==1
        T1= trunk2; T2 = trunk1;
    end
end



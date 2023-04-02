function [T1, T2] = make_zeroBranch_equal_multi(T1, T2)
%ADD_ZERO_BRANCH_MLUTI Summary of this function goes here
%   Detailed explanation goes here

[T1, T2] = make_zeroBranch_equal(T1,T2);
for i=1: numel(T1.children)
    
    [T1.children{i}, T2.children{i}] = make_zeroBranch_equal(T1.children{i}, T2.children{i});
end
     
end

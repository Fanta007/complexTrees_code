function [ array ] = TransformThreeLayer( trunk )
%TRANSFORMTHREELAYER Summary of this function goes here
%   Detailed explanation goes here
%-%
array1 = TransformTwoLayer(trunk);

array2 = {};
for i=1: length(trunk.children)
    sub_trunk = trunk.children{i};
    arr = TransformTwoLayer(sub_trunk);
    array2{i} = arr;
end

array = [array2(1:end)];

for i = ceil(numel(array1)/2): numel(array1)
    array = [array, array1(i)];
end

% save TransformThreeLayer
end


function [ edges ] = makeBranchesTight( edges, pointers, root, leafNum )
%MAKEBRANCHESTIGHT Summary of this function goes here
%   Detailed explanation goes here


c1 = pointers(root-leafNum, 1);
c2 = pointers(root-leafNum, 2);
clear m_vec1 m_vec2
m_vec1 = edges{root}(5,1:4) - edges{c1}(1, 1:4);
m_vec2 = edges{root}(5,1:4) - edges{c2}(1, 1:4);


edges{c1}(:, 1) = edges{c1}(:, 1) + ones(5,1)*m_vec1(1);
edges{c1}(:, 2) = edges{c1}(:, 2) + ones(5,1)*m_vec1(2);
edges{c1}(:, 3) = edges{c1}(:, 3)+ ones(5,1)* m_vec1(3);
% edges{c1}(1, 4) = edges{c1}(1, 4)+ m_vec1(4);




edges{c2}(: ,1) = edges{c2}(:, 1) + ones(5,1)*m_vec2(1);
edges{c2}(: ,2) = edges{c2}(:, 2) + ones(5,1)*m_vec2(2);
edges{c2}(: ,3) = edges{c2}(:, 3)+ ones(5,1)* m_vec2(3);
% edges{c2}(1 ,4) = edges{c2}(1, 4)+ m_vec2(4);

if c1<=leafNum
    return;
else
    edges = makeBranchesTight(edges, pointers, c1, leafNum);
end

if c2<= leafNum
    return;
else
    edges = makeBranchesTight(edges, pointers, c2, leafNum); 
end






end


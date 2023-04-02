function draw_airwayTree_II(edges, pointers, root, leafNum)
%DRAWAIRWAYTREE Summary of this function goes here
%   Detailed explanation goes here

axis equal; hold on;
axis off;
% axis([-1, 54, 0, 6.5,-5, 5]);
hold on;


c1 = pointers(root-leafNum, 1);
c2 = pointers(root-leafNum, 2);
clear m_vec1 m_vec2
m_vec1 = edges{root}(5,1:4) - edges{c1}(1, 1:4);
m_vec2 = edges{root}(5,1:4) - edges{c2}(1, 1:4);
% m_vec1 = [0,0,0];
% m_vec2 = [0,0,0];

    
% x1 = edges{c1}(:, 1);
% y1 = edges{c1}(:, 2);
% z1 = edges{c1}(:, 3);
% line_handle = plot3(x1, y1, z1, 'r', 'LineWidth', 3);
% set(line_handle, 'linesmoothing', 'on'); hold on;

edges{c1}(:, 1) = edges{c1}(:, 1) + ones(5,1)*m_vec1(1);
edges{c1}(:, 2) = edges{c1}(:, 2) + ones(5,1)*m_vec1(2);
edges{c1}(:, 3) = edges{c1}(:, 3)+ ones(5,1)* m_vec1(3);
edges{c1}(1, 4) = edges{c1}(1, 4)+ m_vec1(4);

for k = 1 : 4
    X1 = [edges{c1}(k+1, 1), edges{c1}(k+1, 2) , edges{c1}(k+1, 3)];
    X2 = [edges{c1}(k, 1) ,   edges{c1}(k, 2) ,   edges{c1}(k, 3) ];
    r =  [edges{c1}(k+1, 4), edges{c1}(k, 4)];

    nn = 10;
    cyl_color = 'b';
    closed = 0;
    Draw_Cone(X1, X2, r, nn, cyl_color, closed, 1);
    hold on;
end

% line_handle = plot3(edges{c1}(:, 1), edges{c1}(:, 2), edges{c1}(:, 3), 'b', 'LineWidth', 2); hold on;
% set(line_handle, 'linesmoothing', 'on'); hold on;



% x2 = edges{c2}(:, 1);
% y2 = edges{c2}(:, 2);
% z2 = edges{c2}(:, 3);
% line_handle = plot3(x2, y2, z2, 'r', 'LineWidth', 3);
% set(line_handle, 'linesmoothing', 'on'); hold on;


edges{c2}(: ,1) = edges{c2}(:, 1) + ones(5,1)*m_vec2(1);
edges{c2}(: ,2) = edges{c2}(:, 2) + ones(5,1)*m_vec2(2);
edges{c2}(: ,3) = edges{c2}(:, 3)+ ones(5,1)* m_vec2(3);
edges{c2}(1 ,4) = edges{c2}(1, 4)+ m_vec2(4);

for k = 1 : 4
    X1 = [edges{c2}(k+1, 1), edges{c2}(k+1, 2), edges{c2}(k+1, 3)];
    X2 = [edges{c2}(k, 1),   edges{c2}(k, 2),   edges{c2}(k, 3)];
    r =  [edges{c2}(k+1, 4), edges{c2}(k, 4)];

    nn = 10;
    cyl_color = 'b';
    closed = 0;
    Draw_Cone(X1, X2, r, nn, cyl_color, closed, 1);
    hold on;
end

% line_handle = plot3(edges{c2}(: ,1), edges{c2}(: ,2), edges{c2}(: ,3), 'b', 'LineWidth', 2); hold on;
% set(line_handle, 'linesmoothing', 'on'); hold on;

if c1<=leafNum
    return;
else
    draw_airwayTree_II(edges, pointers, c1, leafNum); hold on;
end

if c2<= leafNum
    return;
else
    draw_airwayTree_II(edges, pointers, c2, leafNum); hold on;
end

end


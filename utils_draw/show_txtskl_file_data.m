clc;
clear;
% branch是二维数组，二维数组里面的每个元素是一个结构体，代表一个结构体

% [branch, branch_num] = ReadSkelFile('txtskl_data\Weeping Willow.txtskl');
% 
% [branch, branch_num] = ReadSkelFile('txtskl_data\AL06a.txtskl');
% 
[branch, branch_num] = ReadSkelFile('txtskl_data\AL12a.txtskl');
% 
% [branch, branch_num] = ReadSkelFile('txtskl_data\AL14a.txtskl');
% [branch, branch_num] = ReadSkelFile('txtskl_data\American Elm.txtskl');
% [branch, branch_num] = ReadSkelFile('txtskl_data\BL01A_Aesculus hippocastanu.txtskl');
% [branch, branch_num] = ReadSkelFile('txtskl_data\BL02A_Betula lenta.txtskl');
% [branch, branch_num] = ReadSkelFile('txtskl_data\Blue Spruce.txtskl');
% [branch, branch_num] = ReadSkelFile('txtskl_data\BS07a.txtskl');

% [branch, branch_num] = ReadSkelFile('txtskl_data\Acer saccharum y1.txtskl');

figure;
set(gcf,'color','white');
axis equal;
box off;
hold on;
xlabel('X axis');
ylabel('Y axis');
zlabel('Z axis');

% i表示层数
for i = 1: 3% size(branch, 1)
    for j = 1:branch_num(i)
        point_num = length(branch(i,j).point);
        clear point_x point_y point_z;
        point_x = [];
        point_y = [];
        point_z = [];
        
        for k = 1: point_num
            point_x = [point_x, branch(i,j).point(k).x];
            point_y = [point_y, branch(i,j).point(k).y];
            point_z = [point_z, branch(i,j).point(k).z];
        end
        
        if i == 1
            line_handle = plot3(point_x, point_y, point_z, 'r','LineWidth', 2);
            set(line_handle, 'linesmoothing', 'on');
            hold on;
        end
        if i == 2
            line_handle = plot3(point_x, point_y, point_z, 'b','LineWidth', 2);
            set(line_handle, 'linesmoothing', 'on');
            hold on;
        end
        if i == 3
            line_handle = plot3(point_x, point_y, point_z, 'g','LineWidth', 2);
            set(line_handle, 'linesmoothing', 'on');
            hold on;
        end
        
    end
end
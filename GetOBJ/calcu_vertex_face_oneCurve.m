function [vertex, face] = calcu_vertex_face_oneCurve(circles)
%CALCU_VERTEX_FACE Summary of this function goes here
%   Detailed explanation goes here

vertex = [];

cir_point_num = size(circles{1}, 1);

for i=1: numel(circles)
    vertex = [vertex; circles{i}];
end


face = [];
for i=1: numel(circles)-1
    for j=1: cir_point_num -1
        first_ind = (i-1)*cir_point_num +j;
        second_ind = first_ind +1;
        third_ind = second_ind + cir_point_num;
        fourth_ind = third_ind -1;
        
        face = [face; first_ind, second_ind, third_ind];
        face = [face; first_ind, third_ind, fourth_ind];
    end
end

floor_x = mean(circles{1}(:, 1));
floor_y = mean(circles{1}(:, 2));
floor_z = mean(circles{1}(:, 3));

ceiling_x = mean(circles{end}(:, 1));
ceiling_y = mean(circles{end}(:, 2));
ceiling_z = mean(circles{end}(:, 3));

vertex = [vertex; [floor_x, floor_y, floor_z]; [ceiling_x, ceiling_y, ceiling_z]];
floor_center_ind = size(vertex, 1) -1;
ceiling_center_ind = size(vertex, 1);

for i=1: size(circles{1}, 1)-1
    ind1 = i;
    ind2 = i+1;
    ind3 = floor_center_ind;
    
    face_cur = [ind1, ind2, ind3];
    face = [face; face_cur];
end

for i=1: size(circles{end}, 1)-1
    ind1 = ceiling_center_ind-2 -(i-1);
    ind2 = ind1-1;
    ind3 = ceiling_center_ind;
    face_cur = [ind1, ind2, ind3];
    face = [face; face_cur];
end

end


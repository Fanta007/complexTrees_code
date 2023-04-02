function trunk1 = calcu_vertex_face(trunk1)
%CALCU_VERTEX_FACE Summary of this function goes here
%   Detailed explanation goes here

trunk1.vertex = [];



trunk1.cir_point_num = size(trunk1.circles{1}, 1);

for i=1: numel(trunk1.circles)
    trunk1.vertex = [trunk1.vertex; trunk1.circles{i}];
end


trunk1.face = [];
for i=1: numel(trunk1.circles)-1
    for j=1: trunk1.cir_point_num -1
        first_ind = (i-1)*trunk1.cir_point_num +j;
        second_ind = first_ind +1;
        third_ind = second_ind + trunk1.cir_point_num;
        fourth_ind = third_ind -1;
        
        trunk1.face = [trunk1.face; first_ind, second_ind, third_ind];
        trunk1.face = [trunk1.face; first_ind, third_ind, fourth_ind];
    end
end

floor_x = mean(trunk1.circles{1}(:, 1));
floor_y = mean(trunk1.circles{1}(:, 2));
floor_z = mean(trunk1.circles{1}(:, 3));

ceiling_x = mean(trunk1.circles{end}(:, 1));
ceiling_y = mean(trunk1.circles{end}(:, 2));
ceiling_z = mean(trunk1.circles{end}(:, 3));

trunk1.vertex = [trunk1.vertex; [floor_x, floor_y, floor_z]; [ceiling_x, ceiling_y, ceiling_z]];
floor_center_ind = size(trunk1.vertex, 1) -1;
ceiling_center_ind = size(trunk1.vertex, 1);

for i=1: size(trunk1.circles{1}, 1)-1
    ind1 = i;
    ind2 = i+1;
    ind3 = floor_center_ind;
    
    face_cur = [ind1, ind2, ind3];
    trunk1.face = [trunk1.face; face_cur];
end

for i=1: size(trunk1.circles{end}, 1)-1
    ind1 = ceiling_center_ind-2 -(i-1);
    ind2 = ind1-1;
    ind3 = ceiling_center_ind;
    face_cur = [ind1, ind2, ind3];
    trunk1.face = [trunk1.face; face_cur];
end

end



function wg_tree_showOneOBJ_botanicalTrees(file_name, mov_x, mov_y, mov_z)

fp1 = fopen(file_name, 'r');
vertex_num = fscanf(fp1, '# V %d\n',[1,1]);
face_num =  fscanf(fp1, '# F %d\n',[1,1]);

for i=1: vertex_num
    
    point(i, :) = fscanf(fp1, 'v %f %f %f\n', [1, 3]) + [mov_x, mov_y, mov_z];
end

for i=1: face_num
    face(i, :) = fscanf(fp1, 'f %d %d %d\n', [1, 3]);
end


% trisurf(face, point(:, 1), point(:, 2), point(:, 3));
trisurf(face, point(:, 1), point(:, 2), point(:, 3), 'edgecolor', [0.2 0.1 0], 'facecolor', [0.2 0.1 0]);

end


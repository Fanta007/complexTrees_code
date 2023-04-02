function  [Vertex, Face] = compTree2obj_rad_4layer( CT, filename )


% First point moved to origin
first_pt_x = (CT.beta0(1, 1));
first_pt_y = (CT.beta0(2, 1));
first_pt_z = (CT.beta0(3, 1));

move_x = -first_pt_x;
move_y = -first_pt_y;
move_z = -first_pt_z;

CT = calcu_circles_ST(CT);

for i=1: numel(CT.beta_children)

    CT.beta_children{i} = calcu_circles_ST(CT.beta_children{i});
    
    %
    for j=1: numel(CT.beta_children{i}.beta_children)
            
        CT.beta_children{i}.beta_children{j} = ...
                                    calcu_circles_ST(CT.beta_children{i}.beta_children{j});
    end
        
end

 %%
 
% --- Compute the vertex data and face data ---
[CT.beta0_vertex, CT.beta0_face] = calcu_vertex_face_oneCurve(CT.beta0_circles);

for i=1: numel(CT.beta_children)
    [CT.beta_children{i}.beta0_vertex, CT.beta_children{i}.beta0_face ] = ...
                                        calcu_vertex_face_oneCurve(CT.beta_children{i}.beta0_circles);
    
    for j=1: numel(CT.beta_children{i}.beta_children)
      
            [CT.beta_children{i}.beta_children{j}.beta0_vertex, CT.beta_children{i}.beta_children{j}.beta0_face] = ...
                                                                        calcu_vertex_face_oneCurve( CT.beta_children{i}.beta_children{j}.beta0_circles);
            
                                                                    
            for k=1: numel(CT.beta_children{i}.beta_children{j}.beta)
                    [CT.beta_children{i}.beta_children{j}.beta_vertex{k}, CT.beta_children{i}.beta_children{j}.beta_face{k}] = ...
                                                                calcu_vertex_face_oneCurve( CT.beta_children{i}.beta_children{j}.beta_circles{k});
               
            
            end
            
    end
end


Face = [];
Vertex = [];

cur_idx = 0;
Vertex = [Vertex; CT.beta0_vertex];
Face = [Face; CT.beta0_face];
cur_idx = cur_idx + size(Vertex, 1);

% 2nd layer
for i=1: numel(CT.beta_children)
    
    Vertex = [Vertex; CT.beta_children{i}.beta0_vertex];
    new_face = CT.beta_children{i}.beta0_face + cur_idx;
    Face = [Face; new_face];
    cur_idx = cur_idx + size(CT.beta_children{i}.beta0_vertex, 1);
    
    if numel(find(isnan(Vertex))) >0
        break;
    end
        
end

% 3rd layer
for i=1: numel(CT.beta_children)
    for j=1: numel(CT.beta_children{i}.beta_children)

        Vertex = [Vertex; CT.beta_children{i}.beta_children{j}.beta0_vertex];
        new_face = CT.beta_children{i}.beta_children{j}.beta0_face + cur_idx;
        Face = [Face; new_face];
        cur_idx = cur_idx + size(CT.beta_children{i}.beta_children{j}.beta0_vertex, 1);
    end
end

% 4th layer
for i=1: numel(CT.beta_children)
    for j=1: numel(CT.beta_children{i}.beta_children)
        for k= 1: numel(CT.beta_children{i}.beta_children{j}.beta)

            Vertex = [Vertex; CT.beta_children{i}.beta_children{j}.beta_vertex{k}];
            new_face = CT.beta_children{i}.beta_children{j}.beta_face{k} + cur_idx;
            Face = [Face; new_face];
            cur_idx = cur_idx + size(CT.beta_children{i}.beta_children{j}.beta_vertex{k}, 1);
        end
    end
end

%%
fp_a = fopen([filename, '.obj'], 'w');
fprintf(fp_a, ['# V ',num2str(size(Vertex, 1)), '\n']);
fprintf(fp_a, ['# F ',num2str(size(Face, 1)), '\n']);
for i=1: size(Vertex, 1)
    fprintf(fp_a, 'v ');
    fprintf(fp_a, '%f %f %f\n', Vertex(i, :) + [move_x, move_y, move_z]);
end

for i=1: size(Face, 1)
    fprintf(fp_a, 'f ');
    fprintf(fp_a, '%d %d %d\n', Face(i, :));
end


end


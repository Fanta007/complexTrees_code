function  [Vertex, Face] = complexTree2Obj_3layers( CT, filename, move_x, move_y, move_z )
%TRUNK2OBJ Summary of this function goes here
%   Detailed explanation goes here
% Branch = [trunk1.points(:, 1)'; trunk1.points(:, 2)'; trunk1.points(:, 3)'; trunk1.points(:, 4)'];

Branch = CT.beta0;

n = size(Branch, 2);
s_n = ceil(n/3);

SplineFunc=cscvn(Branch);      %�����i��branch����Ϻ���
length=SplineFunc.breaks(end);   %�������
sample=0: length/s_n :length;           %�����������,����ɳ�101����
spline_data=fnval(SplineFunc, sample);
% plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
CT.spline_beta0 = spline_data;

CT = calcu_circles(CT);


for i=1: numel(CT.beta_children)
    clear Branch
%     Branch = [trunk1.n_children{i}.points(:, 1)';trunk1.n_children{i}.points(:, 2)';trunk1.n_children{i}.points(:, 3)';trunk1.n_children{i}.points(:, 4)'];
   
    Branch = CT.beta{i};
    n = size(Branch, 2);
    s_n = ceil(n/2);
    SplineFunc=cscvn(Branch);      %�����i��branch����Ϻ���
    length=SplineFunc.breaks(end);   %�������
    sample=0: length/s_n :length;           %�����������,����ɳ�101����
    spline_data=fnval(SplineFunc, sample);
    % plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
    
    CT.beta_children{i}.spline_beta0 = spline_data;
    CT.beta_children{i} = calcu_circles(CT.beta_children{i});
    
    %
    for j=1: numel(CT.beta_children{i}.beta_children)
        clear Branch
        if isempty(CT.beta_children{i}.beta_children{j}) ==0
%             Branch = [trunk1.n_children{i}.children{j}.points(:, 1)';trunk1.n_children{i}.children{j}.points(:, 2)';...
%                                                 trunk1.n_children{i}.children{j}.points(:, 3)';trunk1.n_children{i}.children{j}.points(:, 4)'];
            

            if isnan(CT.beta_children{i}.beta{j}(1,1)) == 1
                      
                      CT.beta_children{i}.beta{j} = ......
                          [0,0.0001,0,0;
                          0,    0,  0,0;
                          0,    0,  0,0;
                          0.0001,0001,0001,0001];
                    
            end
            
            
            
            Branch = CT.beta_children{i}.beta_children{j}.beta0;
%             Branch = CT.beta_children{i}.beta{j};
            max_r = 0.005;
            min_r = 0.001;
            Branch(4, :) = flip(min_r: (max_r-min_r)/(numel(Branch(4, :))-1):max_r);

            
            n = size(Branch, 2);
            s_n = ceil(n/3);
            SplineFunc=cscvn(Branch);      %�����i��branch����Ϻ���
            length=SplineFunc.breaks(end);   %�������
            sample=0: length/s_n :length;           %�����������,����ɳ�101����
            spline_data=fnval(SplineFunc, sample);
            % plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
            CT.beta_children{i}.beta_children{j}.spline_beta0 = spline_data;
%             CT.beta_children{i}.beta_children{j}.spline_beta0 = Branch;

            
            CT.beta_children{i}.beta_children{j} = calcu_circles(CT.beta_children{i}.beta_children{j});
            
            
            
            % --- postprocessing for safe --
%             CT.beta_children{i}.beta_children{j}.func_t_parasAndRad = ......
%                 spline(CT.beta_children{i}.beta_children{j}.t_paras, CT.beta_children{i}.beta_children{j}.beta0(4, :));
            
            
            % --- 
            
            
            
        end 
    
    end
        
end

 %%
 
% --- Compute the vertex data and face data ---
CT = calcu_vertex_face(CT);

for i=1: numel(CT.beta_children)
    CT.beta_children{i} = calcu_vertex_face(CT.beta_children{i});
    
    for j=1: numel(CT.beta_children{i}.beta_children)
        if isempty(CT.beta_children{i}.beta_children{j}) ==0
            CT.beta_children{i}.beta_children{j} = calcu_vertex_face(CT.beta_children{i}.beta_children{j});
                      
                
        end
    end
end


Face = [];
Vertex = [];

cur_index = 0;
Vertex = [Vertex; CT.vertex];
Face = [Face; CT.face];
cur_index = cur_index + size(CT.vertex, 1);

for i=1: numel(CT.beta_children)
    if isnan(CT.beta_children{i}.vertex(1, 1)) ==0
        Vertex = [Vertex; CT.beta_children{i}.vertex];
        new_face = CT.beta_children{i}.face + cur_index;
        Face = [Face; new_face];
        cur_index = cur_index + size(CT.beta_children{i}.vertex, 1);
    end
end
% 
for i=1: numel(CT.beta_children)
    for j=1: numel(CT.beta_children{i}.beta_children)
        if isempty(CT.beta_children{i}.beta_children{j}) ==0
            if isnan(CT.beta_children{i}.beta_children{j}.vertex(1, 1)) ==0
                Vertex = [Vertex; CT.beta_children{i}.beta_children{j}.vertex];
                new_face = CT.beta_children{i}.beta_children{j}.face + cur_index;
                Face = [Face; new_face];
                cur_index = cur_index + size(CT.beta_children{i}.beta_children{j}.vertex, 1);
            end
            
            
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


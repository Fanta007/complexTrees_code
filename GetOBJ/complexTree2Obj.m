function  [Vertex, Face] = complexTree2Obj( CT, filename, move_x, move_y, move_z )
%TRUNK2OBJ Summary of this function goes here
%   Detailed explanation goes here
% Branch = [trunk1.points(:, 1)'; trunk1.points(:, 2)'; trunk1.points(:, 3)'; trunk1.points(:, 4)'];

Branch = CT.beta0;

n = size(Branch, 2);
s_n = ceil(n/1)*2;

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
            
            n = size(Branch, 2);
            s_n = ceil(n/2);
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
            
            if isfield(CT.beta_children{i}.beta_children{j}, 'beta') == 1
        
        
                for k = 1: numel(CT.beta_children{i}.beta_children{j}.beta)

                clear Branch
                if isempty(CT.beta_children{i}.beta_children{j}.beta) ==0
                    
%                    CT.beta_children{i}.beta_children{j}.beta_children{k}.circles = cell(1, 1);
                   
                  if isnan(CT.beta_children{i}.beta_children{j}.beta{k}(1,1)) == 1
                      
                      CT.beta_children{i}.beta_children{j}.beta{k} = ......
                          [0,0.0001,0,0;
                          0,    0,  0,0;
                          0,    0,  0,0;
                          0.0001,0001,0001,0001];
                      
%                       CT.beta_children{i}.beta_children{j}.beta{k} = ......
%                                         CT.beta_children{i}.beta_children{j}.beta_children{k}.beta0;
                  end
        %             
                    Branch = CT.beta_children{i}.beta_children{j}.beta{k};
                    
%                     Branch = Branch1 + rand(size(Branch1, 1), size(Branch1, 2)) * 0.0000001;

                    n = size(Branch, 2);
                    s_n = ceil(n/2);
                    SplineFunc=cscvn(Branch);      %�����i��branch����Ϻ���
                    length=SplineFunc.breaks(end);   %�������
                    sample=0: length/s_n :length;           %�����������,����ɳ�101����
                    spline_data=fnval(SplineFunc, sample);
                    % plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
                    CT.beta_children{i}.beta_children{j}.spline_beta{k} = spline_data;
                    
                    % --- special processing of 4th layer radius ---
                    
                    func = CT.beta_children{i}.beta_children{j}.func_t_parasAndRad;
%                     data_t_parasAndRad = CT.beta_children{i}.beta_children{j}.data_t_parasAndRad;
                    
                    if isfield(CT.beta_children{i}.beta_children{j}, 'data_t_parasAndRad') == 1
                       if isempty(CT.beta_children{i}.beta_children{j}.data_t_parasAndRad) == 0
                    
%                         start_r = ppval(func, CT.beta_children{i}.beta_children{j}.tk_sideLocs(k))* 0.5;
                        
                        data_t_parasAndRad = CT.beta_children{i}.beta_children{j}.data_t_parasAndRad;
                        start_r = interp1(data_t_parasAndRad(1, :), data_t_parasAndRad(2, :), ......
                                            CT.beta_children{i}.beta_children{j}.tk_sideLocs(k)) * 0.5;
                        start_r = 0.005;
                        end_r = 0.002;
                       else
                           start_r = 0;
                           end_r = 0;
                       end
                       
                    else
                        start_r = 0;
                        end_r = 0;
                    end
                        
                    
                    spline_data(4, :) = linspace(start_r, end_r, size(spline_data, 2));
                    
                    % --- special processing ends here ---
                    
                    
%                     spline_data(4, :) = ones(1, size(spline_data, 2)) * 0.005;
                    CT.beta_children{i}.beta_children{j}.beta_children{k}.spline_beta0 = spline_data;


                    CT.beta_children{i}.beta_children{j}.beta_children{k} = calcu_circles(CT.beta_children{i}.beta_children{j}.beta_children{k});
                


                end
        
                end
                
            end
            
            
            
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
            
            if isfield(CT.beta_children{i}.beta_children{j}, 'beta_children')
                for k = 1: numel(CT.beta_children{i}.beta_children{j}.beta_children)
                
                if isempty(CT.beta_children{i}.beta_children{j}.beta_children{k}) ==0
                    CT.beta_children{i}.beta_children{j}.beta_children{k}......
                                    = calcu_vertex_face(CT.beta_children{i}.beta_children{j}.beta_children{k});
                end
                
                end
            end
            
                
                
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

% --- Process the 4-th layers' circles ---
for i=1: numel(CT.beta_children)
    for j=1: numel(CT.beta_children{i}.beta_children)
        
        if isfield(CT.beta_children{i}.beta_children{j}, 'beta')
            for k = 1: numel(CT.beta_children{i}.beta_children{j}.beta)
            
%         if isempty(CT.beta_children{i}.beta_children{j}) ==0
            if isnan(CT.beta_children{i}.beta_children{j}.beta_children{k}.vertex(1, 1)) ==0
                Vertex = [Vertex; CT.beta_children{i}.beta_children{j}.beta_children{k}.vertex];
                new_face = CT.beta_children{i}.beta_children{j}.beta_children{k}.face + cur_index;
                Face = [Face; new_face];
                cur_index = cur_index + size(CT.beta_children{i}.beta_children{j}.beta_children{k}.vertex, 1);
            end
%         end
        
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


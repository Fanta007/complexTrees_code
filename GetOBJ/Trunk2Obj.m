function  Trunk2Obj( trunk1, filename, interval )
%TRUNK2OBJ Summary of this function goes here
%   Detailed explanation goes here
Branch = [trunk1.points(:, 1)'; trunk1.points(:, 2)'; trunk1.points(:, 3)'; trunk1.points(:, 4)'];

n = size(Branch, 2);
s_n = ceil(n/1);

SplineFunc=cscvn(Branch);      %求出第i个branch的拟合函数
length=SplineFunc.breaks(end);   %求出弧长
sample=0: length/s_n :length;           %求出采样步长,这里采出101个点
spline_data=fnval(SplineFunc, sample);
% plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
trunk1.spline_branch = spline_data;
trunk1 = calcu_circles(trunk1);

for i=1: numel(trunk1.n_children)
    clear Branch
    Branch = [trunk1.n_children{i}.points(:, 1)';trunk1.n_children{i}.points(:, 2)';trunk1.n_children{i}.points(:, 3)';trunk1.n_children{i}.points(:, 4)'];
   
    n = size(Branch, 2);
    s_n = ceil(n/1);
    SplineFunc=cscvn(Branch);      %求出第i个branch的拟合函数
    length=SplineFunc.breaks(end);   %求出弧长
    sample=0: length/s_n :length;           %求出采样步长,这里采出101个点
    spline_data=fnval(SplineFunc, sample);
    % plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
    trunk1.n_children{i}.spline_branch = spline_data;
    trunk1.n_children{i} = calcu_circles(trunk1.n_children{i});
    
    %
    for j=1: numel(trunk1.n_children{i}.children)
        clear Branch
        if isempty(trunk1.n_children{i}.children{j}) ==0
            Branch = [trunk1.n_children{i}.children{j}.points(:, 1)';trunk1.n_children{i}.children{j}.points(:, 2)';...
                                                trunk1.n_children{i}.children{j}.points(:, 3)';trunk1.n_children{i}.children{j}.points(:, 4)'];

            n = size(Branch, 2);
            s_n = ceil(n/1);
            SplineFunc=cscvn(Branch);      %求出第i个branch的拟合函数
            length=SplineFunc.breaks(end);   %求出弧长
            sample=0: length/s_n :length;           %求出采样步长,这里采出101个点
            spline_data=fnval(SplineFunc, sample);
            % plot3(spline_data(1, :), spline_data(2, :), spline_data(3, :), 'k', 'LineWidth', 15); hold on;
            trunk1.n_children{i}.children{j}.spline_branch = spline_data;

            trunk1.n_children{i}.children{j}.spline_branch = spline_data;
            trunk1.n_children{i}.children{j} = calcu_circles(trunk1.n_children{i}.children{j});
        end
    
    end
        
end

 %%
 trunk1 = calcu_vertex_face(trunk1);

for i=1: numel(trunk1.n_children)
    trunk1.n_children{i} = calcu_vertex_face(trunk1.n_children{i});
    
    for j=1: numel(trunk1.n_children{i}.children)
        if isempty(trunk1.n_children{i}.children{j}) ==0
            trunk1.n_children{i}.children{j} = calcu_vertex_face(trunk1.n_children{i}.children{j});
        end
    end
end


Face = [];
Vertex = [];

cur_index = 0;
Vertex = [Vertex; trunk1.vertex];
Face = [Face; trunk1.face];
cur_index = cur_index + size(trunk1.vertex, 1);

for i=1: numel(trunk1.n_children)
    if isnan(trunk1.n_children{i}.vertex(1, 1)) ==0
        Vertex = [Vertex; trunk1.n_children{i}.vertex];
        new_face = trunk1.n_children{i}.face + cur_index;
        Face = [Face; new_face];
        cur_index = cur_index + size(trunk1.n_children{i}.vertex, 1);
    end
end

for i=1: numel(trunk1.n_children)
    for j=1: numel(trunk1.n_children{i}.children)
        if isempty(trunk1.n_children{i}.children{j}) ==0
            if isnan(trunk1.n_children{i}.children{j}.vertex(1, 1)) ==0
                Vertex = [Vertex; trunk1.n_children{i}.children{j}.vertex];
                new_face = trunk1.n_children{i}.children{j}.face + cur_index;
                Face = [Face; new_face];
                cur_index = cur_index + size(trunk1.n_children{i}.children{j}.vertex, 1);
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
    fprintf(fp_a, '%f %f %f\n', Vertex(i, :) + interval);
end

for i=1: size(Face, 1)
    fprintf(fp_a, 'f ');
    fprintf(fp_a, '%d %d %d %d\n', Face(i, :));
end


end


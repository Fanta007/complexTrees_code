clc
% close all;
gcf = figure('position', [100, 100, 800, 800]);
set(gcf,'visible', 'on');
set(gcf, 'color', 'w');
view(0, 90);
axis equal; hold on;

% A10 is the geodesic
% CT = A10;
% CT = mu;
CT = {mu};
addpath Yanirk_code

c = get_colormap(50);

for i=1: numel(CT)
    
    y_added = ceil(i/19) * -15;
    x_added = (i-1) * -400;
    
    clear first_pt_x first_pt_y first_pt_z
    
    min_pt_x = min(CT{i}.beta0(1, :));
    min_pt_y = min(CT{i}.beta0(2, :));
    min_pt_z = min(CT{i}.beta0(3, :));
    
    X0 = CT{i}.beta0(1, :);
    Y0 = CT{i}.beta0(2, :);
    Z0 = CT{i}.beta0(3, :);
    
    plot3(X0 -min_pt_x + x_added, Y0 - min_pt_y + y_added, Z0 - min_pt_z, 'k', 'LineWidth', 2); hold on;
%     text(X0(1) -min_pt_x + x_added, Y0(1) - min_pt_y + y_added, Z0(1) - min_pt_z, num2str(i)); hold on;
    
    for j=1: numel(CT{i}.beta)
        clear X Y Z
        
%         X = CT{i}.beta{j}(1, :);
%         Y = CT{i}.beta{j}(2, :);
%         Z = CT{i}.beta{j}(3, :);
        X = CT{i}.beta_children{j}.beta0(1, :);
        Y = CT{i}.beta_children{j}.beta0(2, :);
        Z = CT{i}.beta_children{j}.beta0(3, :);
        plot3(X- min_pt_x + x_added, Y- min_pt_y+ y_added, Z- min_pt_z, 'Color',c(j,:), 'LineWidth', 2); hold on;
        
        for k = 1: numel(CT{i}.beta_children{j}.beta)
            clear X Y Z
            X = CT{i}.beta_children{j}.beta{k}(1, :);
            Y = CT{i}.beta_children{j}.beta{k}(2, :);
            Z = CT{i}.beta_children{j}.beta{k}(3, :);
            if j == -1
                plot3(X- min_pt_x + x_added, Y- min_pt_y+ y_added, Z- min_pt_z, 'Color',c(j,:), 'LineWidth', 2); hold on;
            else
                plot3(X- min_pt_x + x_added, Y- min_pt_y+ y_added, Z- min_pt_z, 'Color',c(j,:), 'LineWidth', 2); hold on;
            end
        end
        
    end
end

return;
%%

% clc
close all;
gcf = figure('position', [100, 100, 1000, 600]);
set(gcf,'visible', 'on');
set(gcf, 'color', 'w');
view(0, 90);
axis equal; hold on;
box on; hold on;

    
% Mean info
S1 = sprintf('Mean, NeuronTree, %s, %d trees: %s, --- ', data_path, length(used_idxes), num2str(used_idxes) );
Lambda_str = ['\lambda_{m}=', num2str(lam_m), ', \lambda_{s}=', num2str(lam_s), ', \lambda_{p}=', num2str(lam_p), ' --- E-total=', num2str(G.E)];
TotalTime_str = ['totalTime :', num2str(T3)];

title({[S1, Lambda_str] , TotalTime_str});
% Concatenate Input Trees and Mean
% CT = [used_compTrees, A10(2)];
CT = [used_compTrees(1:end), A10{2}];

% addpath Yanirk_code
% c = distinguishable_colors(10);

default_c = get(gca,'colororder');
% set(groot,'defaultFigureColor',default_c(1,:))

for i=1: numel(CT)
    
    y_added = ceil(i/20) * -1500;
    x_added = mod(i-1, 20) * 400;
    
    clear first_pt_x first_pt_y first_pt_z
    
    first_pt_x = (CT{i}.beta0(1, 1));
    first_pt_y = (CT{i}.beta0(2, 1));
    first_pt_z = (CT{i}.beta0(3, 1));
    
    X0 = CT{i}.beta0(1, :) -first_pt_x + x_added;
    Y0 = CT{i}.beta0(2, :) -first_pt_y + y_added;
    Z0 = CT{i}.beta0(3, :)- first_pt_z;
    R0 = CT{i}.beta0_rad;
    
    count = 1;
    plot3(X0, Y0, Z0, 'Color', default_c(1,:), 'LineWidth', 1); hold on;
    text(X0(1), Y0(1)-220, Z0(1), num2str(i), 'FontSize', 12);
    hold on;

    count = count+1;

    for j=1: numel(CT{i}.beta)
        clear X Y Z
        
        X = CT{i}.beta{j}(1, :) - first_pt_x + x_added;
        Y = CT{i}.beta{j}(2, :) - first_pt_y + y_added;
        Z = CT{i}.beta{j}(3, :) - first_pt_z;
        R= CT{i}.beta_rad{j};
        
        plot3(X, Y, Z, 'Color', default_c(1,:),'LineWidth', 1); hold on;
%         plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(count,:), 'LineWidth', 2); hold on;
        
        count = count+1;
        
        for k = 1: numel(CT{i}.beta_children{j}.beta)
            clear X Y Z
            X = CT{i}.beta_children{j}.beta{k}(1, :) - first_pt_x + x_added;
            Y = CT{i}.beta_children{j}.beta{k}(2, :) - first_pt_y + y_added;
            Z = CT{i}.beta_children{j}.beta{k}(3, :)- first_pt_z;
            R= CT{i}.beta_children{j}.beta_rad{k};
            
            plot3(X, Y, Z,'Color', default_c(1,:),'LineWidth', 1); hold on;
            
            for t = 1: numel(CT{i}.beta_children{j}.beta_children{k}.beta)
                clear X Y Z
                X = CT{i}.beta_children{j}.beta_children{k}.beta{t}(1, :) - first_pt_x + x_added;
                Y = CT{i}.beta_children{j}.beta_children{k}.beta{t}(2, :) - first_pt_y + y_added;
                Z = CT{i}.beta_children{j}.beta_children{k}.beta{t}(3, :) - first_pt_z;
                R = CT{i}.beta_children{j}.beta_children{k}.beta_rad{t};
                
                plot3(X, Y, Z,'Color', default_c(1,:),'LineWidth', 1); hold on;
                
            end
            count = count+1;
            
        end
        
    end
    
 
end

saveas(gcf,[num2str(tNum),'InputCompTreesAndMean_4layers.png'])

return;
%%
% for i=1: numel(CT)
%     
%     y_added = ceil(i/19) * -0;
%     x_added = (mod(i, 19)+1) * -000;
%     
%     clear first_pt_x first_pt_y first_pt_z
%     
%     first_pt_x = (CT{i}.beta0(1, 1));
%     first_pt_y = (CT{i}.beta0(2, 1));
%     first_pt_z = (CT{i}.beta0(3, 1));
%     
%     X0 = CT{i}.beta0(1, :);
%     Y0 = CT{i}.beta0(2, :);
%     Z0 = CT{i}.beta0(3, :);
%     
%     plot3(X0 -first_pt_x + x_added, Y0 - first_pt_y + y_added, Z0 - first_pt_z, 'Color',c(1,:), 'LineWidth', 3); hold on;
% %     text(X0(1) -first_pt_x + x_added, Y0(1) - first_pt_y + y_added, Z0(1) - first_pt_z, num2str(i)); hold on;
%     
%     for j=1: numel(CT{i}.beta)
%         clear X Y Z
%         
%         X = CT{i}.beta{j}(1, :);
%         Y = CT{i}.beta{j}(2, :);
%         Z = CT{i}.beta{j}(3, :);
%         plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(2,:), 'LineWidth', 3); hold on;
%         
%         for k = 1: numel(CT{i}.beta_children{j}.beta)
%             clear X Y Z
%             X = CT{i}.beta_children{j}.beta{k}(1, :);
%             Y = CT{i}.beta_children{j}.beta{k}(2, :);
%             Z = CT{i}.beta_children{j}.beta{k}(3, :);
%             if j == -1
%                 plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(3,:), 'LineWidth', 3); hold on;
%             else
%                 plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(3,:), 'LineWidth', 3); hold on;
%             end
%             
%             
%             for t = 1: numel(CT{i}.beta_children{j}.beta_children{k}.beta)
%                 clear X Y Z
%                 X = CT{i}.beta_children{j}.beta_children{k}.beta{t}(1, :);
%                 Y = CT{i}.beta_children{j}.beta_children{k}.beta{t}(2, :);
%                 Z = CT{i}.beta_children{j}.beta_children{k}.beta{t}(3, :);
%                 if j == -1
%                     plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(4,:), 'LineWidth', 3); hold on;
%                 else
%                     plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(4,:), 'LineWidth', 3); hold on;
%                 end
%             end
%             
%         end
%         
%     end
%     
%     
%     if i~=1 & i~= numel(CT)
%         pause(.001); cla;
%     elseif i == 1
%         pause(1); cla;
%     end
% end
% 
% return;

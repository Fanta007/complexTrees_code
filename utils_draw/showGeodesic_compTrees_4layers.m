clc
% close all;
gcf = figure('position', [100, 100, 1000, 400]);
set(gcf,'visible', 'on');
set(gcf, 'color', 'w');
view(0, 90);
axis equal; hold on;
box on; hold on;

S1 = sprintf('Geodesic, NeuroTree %d with %d, ', idx1, idx2);
title({[S1,  '\lambda_{m}=', num2str(lam_m), ', \lambda_{s}=', num2str(lam_s), ', \lambda_{p}=', num2str(lam_p)], ' '});

% A10 is the geodesic
CT = A10;

addpath Yanirk_code

c = distinguishable_colors(30,[.9,.9,.9;0,0,0],[20,20]);

% c = distinguishable_colors(70);

default_c = get(gca,'colororder');
% c = get_colormap(100);
% 
% 
for i=1: numel(CT)
    
    y_added = ceil(i/19) * -0;
    x_added = (mod(i, 19)+1) * 350;
    
    clear first_pt_x first_pt_y first_pt_z
    
    first_pt_x = (CT{i}.beta0(1, 1));
    first_pt_y = (CT{i}.beta0(2, 1));
    first_pt_z = (CT{i}.beta0(3, 1));
    
    X0 = CT{i}.beta0(1, :);
    Y0 = CT{i}.beta0(2, :);
    Z0 = CT{i}.beta0(3, :);
    
    count = 1;
    
    plot3(X0 -first_pt_x + x_added, Y0 - first_pt_y + y_added, Z0 - first_pt_z, 'Color',default_c(1,:)*0, 'LineWidth', 1); hold on;
%     text(X0(1) -first_pt_x + x_added, Y0(1) - first_pt_y + y_added, Z0(1) - first_pt_z, num2str(i)); hold on;
    count = count+1;

    for j=1: numel(CT{i}.beta)
        clear X Y Z
        
        X = CT{i}.beta{j}(1, :);
        Y = CT{i}.beta{j}(2, :);
        Z = CT{i}.beta{j}(3, :);
        plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(j,:), 'LineWidth', 1); hold on;
        
        count = count+1;
        
        for k = 1: numel(CT{i}.beta_children{j}.beta)
            clear X Y Z
            X = CT{i}.beta_children{j}.beta{k}(1, :);
            Y = CT{i}.beta_children{j}.beta{k}(2, :);
            Z = CT{i}.beta_children{j}.beta{k}(3, :);
            if j == -1
                plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(j,:), 'LineWidth', 1); hold on;
            else
                plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(j,:), 'LineWidth', 1); hold on;
            end
%             count = count+1;
            
            for t = 1: numel(CT{i}.beta_children{j}.beta_children{k}.beta)
                clear X Y Z
                X = CT{i}.beta_children{j}.beta_children{k}.beta{t}(1, :);
                Y = CT{i}.beta_children{j}.beta_children{k}.beta{t}(2, :);
                Z = CT{i}.beta_children{j}.beta_children{k}.beta{t}(3, :);
                if j == -1
                    plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(j,:), 'LineWidth', 1); hold on;
                else
                    plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(j,:), 'LineWidth', 1); hold on;
                end
                
%             count = count+1;
            end
            count = count+1;
            
        end
        
    end
    
 
end

% save as .png
saveas(gcf,[num2str(idx1),'with', num2str(idx2), '-Geod_CompTrees_4layers.png'])

% save as .pdf
axis off;
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h, [num2str(idx1),'with', num2str(idx2), '-Geod_CompTrees_4layers'],'-dpdf','-r0')

% saveas(gcf,[num2str(idx1),'with', num2str(idx2), '-Geod_CompTrees_4layers.pdf'])

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
%% --- Make animation of tree variation ---

% --- save the animation into a file ---
video_name = ['Geodesic_', num2str(4), '-', num2str(7), '.avi'];
avi_obj = VideoWriter(video_name);%�½���example.avi���ļ�
open(avi_obj); %��

% gcf1 = figure('position', [100, 100, 600, 600]);
% set(gcf1,'visible', 'on');
% set(gcf1, 'color', 'w');
% axis([-4, 4, 0, 8]); hold on
% 
% axis equal; hold on;

gcf1 = figure('position', [100, 100, 800, 800]);
set(gcf1,'visible', 'on');
set(gcf1, 'color', 'w');
view(0, 90);
axis equal; hold on;
box on; hold on;
axis([-3, 3, 0, 6]); hold on;

c = get_colormap(100);

for i=1: numel(CT)
    
    y_added = ceil(i/19) * -0;
    x_added = (mod(i, 19)+1) * -000;
    
    clear first_pt_x first_pt_y first_pt_z
    
    first_pt_x = (CT{i}.beta0(1, 1));
    first_pt_y = (CT{i}.beta0(2, 1));
    first_pt_z = (CT{i}.beta0(3, 1));
    
    X0 = CT{i}.beta0(1, :);
    Y0 = CT{i}.beta0(2, :);
    Z0 = CT{i}.beta0(3, :);
    
    count = 1;
    
    plot3(X0 -first_pt_x + x_added, Y0 - first_pt_y + y_added, Z0 - first_pt_z, 'Color',c(1,:), 'LineWidth', 3); hold on;
%     text(X0(1) -first_pt_x + x_added, Y0(1) - first_pt_y + y_added, Z0(1) - first_pt_z, num2str(i)); hold on;
    count = count+1;

    for j=1: numel(CT{i}.beta)
        clear X Y Z
        
        X = CT{i}.beta{j}(1, :);
        Y = CT{i}.beta{j}(2, :);
        Z = CT{i}.beta{j}(3, :);
        plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(count,:), 'LineWidth', 3); hold on;
        
        count = count+1;
        
        for k = 1: numel(CT{i}.beta_children{j}.beta)
            clear X Y Z
            X = CT{i}.beta_children{j}.beta{k}(1, :);
            Y = CT{i}.beta_children{j}.beta{k}(2, :);
            Z = CT{i}.beta_children{j}.beta{k}(3, :);
            if j == -1
                plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(count,:), 'LineWidth', 3); hold on;
            else
                plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(count,:), 'LineWidth', 3); hold on;
            end
%             count = count+1;
            
            for t = 1: numel(CT{i}.beta_children{j}.beta_children{k}.beta)
                clear X Y Z
                X = CT{i}.beta_children{j}.beta_children{k}.beta{t}(1, :);
                Y = CT{i}.beta_children{j}.beta_children{k}.beta{t}(2, :);
                Z = CT{i}.beta_children{j}.beta_children{k}.beta{t}(3, :);
                if j == -1
                    plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(count,:), 'LineWidth', 3); hold on;
                else
                    plot3(X- first_pt_x + x_added, Y- first_pt_y+ y_added, Z- first_pt_z, 'Color',c(count,:), 'LineWidth', 3); hold on;
                end
                
%                 count = count+1;
            end
            count = count+1;
            
        end
        
    end
    
    
%     if i~=1 & i~= numel(CT)
%         pause(.001); cla;
%     elseif i == 1
%         pause(1); cla;
%     end
    
    
    for k=1: 3
        frame = getframe(gcf1);
    %     aviobj = addframe(aviobj, frame);
        writeVideo(avi_obj,frame);
    end
    
    if i == 1
        for k=1: 30
            frame = getframe(gcf1);
            writeVideo(avi_obj,frame);
        end
    end
    
    if i == numel(CT)
        for k=1: 100
            frame = getframe(gcf1);
            writeVideo(avi_obj,frame);
        end
    end
    
    if i~= numel(CT)
        cla;
    end
end



close(avi_obj); %�ر�

return;


% ---- here the mean tree is showed ---

first_pt_x = mu.beta0(1, 1);
first_pt_y = mu.beta0(2, 1);
first_pt_z = mu.beta0(3, 1);
%     scatter3(STp{i}.beta0(1, 1)+(i-1)*30, STp{i}.beta0(2, 1), STp{i}.beta0(3, 1), 'k');
%     hold on;

X0 = mu.beta0(1, :);
Y0 = mu.beta0(2, :);
Z0 = mu.beta0(3, :);

plot3(X0 -first_pt_x +1*1000, Y0 - first_pt_y, Z0 - first_pt_z, 'k', 'LineWidth', 1); hold on;


for j=1: numel(mu.beta)
    clear X Y Z
    X = mu.beta{j}(1, :);
    Y = mu.beta{j}(2, :);
    Z = mu.beta{j}(3, :);
    plot3(X- first_pt_x + 1*1000, Y- first_pt_y, Z- first_pt_z, 'Color',c(1,:), 'LineWidth', 1); hold on;
end 

return;




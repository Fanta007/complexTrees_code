function [ trunk1 ] = calcu_circles( trunk1 )
%CALCU_CIRCLES Summary of this function goes here
%   Detailed explanation goes here
% 计算每个branch的节点处的圆环
skel = trunk1.spline_beta0';
num = size(skel, 1);
c_i = 1;

% figure('color', 'white');
% box on; hold on;
% axis equal; hold on;

for k =1: num-1
    
    X2 = [skel(k+1, 1), skel(k+1, 2), skel(k+1, 3)];
    X1 = [skel(k, 1),   skel(k, 2),   skel(k, 3)];
    r =  [skel(k, 4),   skel(k+1, 4)];
    
    length=norm(X2-X1);
    t = linspace(0, 2*pi, 11);
    
    Y_1=r(1)*cos(t);
    Z_1=r(1)*sin(t);
    Y_2=r(2)*cos(t);
    Z_2=r(2)*sin(t);
    
    X_1 = ones(1, numel(t)) * 0;
    X_2 = ones(1, numel(t)) * length;
    
    circle_1 = [X_1', Y_1', Z_1'];
    circle_2 = [X_2', Y_2', Z_2'];
    
    
    angle_X1X2 = acos( dot( [1, 0, 0],(X2-X1) )/( norm([1, 0, 0])*norm(X2-X1)) );

    axis_rot=cross([1 0 0],(X2-X1) );
    
    r_circle_1 = rot3d(circle_1, [0,0,0], axis_rot ,angle_X1X2);
    r_circle_2 = rot3d(circle_2, [0,0,0], axis_rot ,angle_X1X2);
    
    move_vec = X1;
    
    for i=1: size(r_circle_1, 1)
        Circle1(i, 1) = r_circle_1(i, 1) + X1(1);
        Circle1(i, 2) = r_circle_1(i, 2) + X1(2);
        Circle1(i, 3) = r_circle_1(i, 3) + X1(3);
    end
    
    for i=1: size(r_circle_2, 1)
        Circle2(i, 1) = r_circle_2(i, 1) + X1(1);
        Circle2(i, 2) = r_circle_2(i, 2) + X1(2);
        Circle2(i, 3) = r_circle_2(i, 3) + X1(3);
    end
    
    if k == 1
        previous_cir = Circle1;
        trunk1.circles{c_i} = Circle1;
        c_i = c_i +1;
        
    end
    
    % 只画previous_cir和Circle2
    
    for i=1: size(Circle2, 1)
%         line([previous_cir(i, 1), Circle2(i, 1)], [previous_cir(i, 2), Circle2(i, 2)], [previous_cir(i, 3), Circle2(i, 3)]); 
%         pause(0.01);
        hold on;
    end
    
%     plot3(previous_cir(:, 1), previous_cir(:, 2), previous_cir(:, 3)); hold on;
%     line([previous_cir(end, 1), previous_cir(1, 1)], [previous_cir(end, 2), previous_cir(1, 2)],[previous_cir(end, 3), previous_cir(1, 3)]); hold on;
    
%     plot3(Circle2(:, 1), Circle2(:, 2), Circle2(:, 3)); hold on;
%     line([Circle2(end, 1), Circle2(1, 1)], [Circle2(end, 2), Circle2(1, 2)],[Circle2(end, 3), Circle2(1, 3)]); hold on;
    
    trunk1.circles{c_i}= Circle2;
    c_i = c_i +1;
    
    previous_cir = Circle2;
    
end


end


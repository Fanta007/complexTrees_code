function [ output_args ] = drawTubulars( skel, n )

set(groot,'defaultLineLineWidth',1);
num = size(skel, 1);

for k =1: num-1
    
    P2 = [skel(k+1, 1), skel(k+1, 2), skel(k+1, 3)];
    P1 = [skel(k, 1),   skel(k, 2),   skel(k, 3)];
    r =  [skel(k, 4),   skel(k+1, 4)];
    
    assert(r(1)>0 & r(2)>0);
    
    length =norm(P2 - P1);
    t = linspace(0, 2*pi, n);
    
    Y_1=r(1)*cos(t);
    Z_1=r(1)*sin(t);
    Y_2=r(2)*cos(t);
    Z_2=r(2)*sin(t);
    
    X_1 = ones(1, numel(t)) * 0;
    X_2 = ones(1, numel(t)) * length;
    
    circle_1 = [X_1', Y_1', Z_1'];
    circle_2 = [X_2', Y_2', Z_2'];
    
    
    angle_P1P2 = acos( dot( [1, 0, 0],(P2-P1) )/( norm([1, 0, 0])*norm(P2-P1)) );

    axis_rot=cross([1 0 0],(P2- P1) );
    
    r_circle_1 = rot3d(circle_1, [0,0,0], axis_rot ,angle_P1P2);
    r_circle_2 = rot3d(circle_2, [0,0,0], axis_rot ,angle_P1P2);
    
    move_vec = P1;
    
    for i=1: size(r_circle_1, 1)
        Circle1(i, 1) = r_circle_1(i, 1) + P1(1);
        Circle1(i, 2) = r_circle_1(i, 2) + P1(2);
        Circle1(i, 3) = r_circle_1(i, 3) + P1(3);
    end
    
    for i=1: size(r_circle_2, 1)
        Circle2(i, 1) = r_circle_2(i, 1) + P1(1);
        Circle2(i, 2) = r_circle_2(i, 2) + P1(2);
        Circle2(i, 3) = r_circle_2(i, 3) + P1(3);
    end
    
    if k == 1
        previous_cir = Circle1;
    end
    
    % ֻ��previous_cir��Circle2
    
    for i=1: size(Circle2, 1)
        line([previous_cir(i, 1), Circle2(i, 1)], [previous_cir(i, 2), Circle2(i, 2)], [previous_cir(i, 3), Circle2(i, 3)]); hold on;
    end
    
    line(previous_cir(:, 1), previous_cir(:, 2), previous_cir(:, 3)); hold on;
    line([previous_cir(end, 1), previous_cir(1, 1)], [previous_cir(end, 2), previous_cir(1, 2)],[previous_cir(end, 3), previous_cir(1, 3)]); hold on;
    
    line(Circle2(:, 1), Circle2(:, 2), Circle2(:, 3)); hold on;
    line([Circle2(end, 1), Circle2(1, 1)], [Circle2(end, 2), Circle2(1, 2)],[Circle2(end, 3), Circle2(1, 3)]); hold on;
    
    previous_cir = Circle2;
    
end
    



end


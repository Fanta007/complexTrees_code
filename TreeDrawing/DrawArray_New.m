function DrawArray_New(array_new, root)


c1= array_new(root).c1_index;
c2 = array_new(root).c2_index;

m_vec = array_new(root).edge_spline(5, :) - array_new(c1).edge_spline(1, :);
m_vec2 = array_new(root).edge_spline(5, :) - array_new(c2).edge_spline(1, :);


    x = array_new(c1).edge_spline(:, 1) + ones(5,1)* m_vec(1);
    y = array_new(c1).edge_spline(:, 2) + ones(5,1)* m_vec(2);
    z = array_new(c1).edge_spline(:, 3)+ ones(5,1)* m_vec(3)
    plot3(x, y, z, 'k'); hold on;
    
    x2 = array_new(c2).edge_spline(:, 1) + ones(5,1)* m_vec2(1);
    y2 = array_new(c2).edge_spline(:, 2) + ones(5,1)* m_vec2(2);
    z2 = array_new(c2).edge_spline(:, 3)+ ones(5,1)* m_vec2(3);
    plot3(x2, y2, z2, 'k'); hold on;

    if isempty(array_new(c1).c1_index) && isempty(array_new(c1).c2_index)
        return;
    else
        DrawArray_New(array_new, c1); hold on;
    end
    
    if isempty(array_new(c2).c1_index) && isempty(array_new(c2).c2_index)
        return;
    else
        DrawArray_New(array_new, c2); hold on;
    end
end
       


% legend(string_matrix);



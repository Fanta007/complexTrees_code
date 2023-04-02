function DrawArray_Phytree(array_phytree, root)


c1= array_phytree(root).c1_phyIndex;
c2 = array_phytree(root).c2_phyIndex;

m_vec = array_phytree(root).edge_spline(5, :) - array_phytree(c1).edge_spline(1, :);
m_vec2 = array_phytree(root).edge_spline(5, :) - array_phytree(c2).edge_spline(1, :);


    x = array_phytree(c1).edge_spline(:, 1) + ones(5,1)* m_vec(1);
    y = array_phytree(c1).edge_spline(:, 2) + ones(5,1)* m_vec(2);
    z = array_phytree(c1).edge_spline(:, 3)+ ones(5,1)* m_vec(3)
    plot3(x, y, z, 'k'); hold on;
    
    x2 = array_phytree(c2).edge_spline(:, 1) + ones(5,1)* m_vec2(1);
    y2 = array_phytree(c2).edge_spline(:, 2) + ones(5,1)* m_vec2(2);
    z2 = array_phytree(c2).edge_spline(:, 3)+ ones(5,1)* m_vec2(3);
    plot3(x2, y2, z2, 'k'); hold on;

    if (array_phytree(c1).c1_phyIndex) ==0 && (array_phytree(c1).c2_phyIndex) ==0
        return;
    else
        DrawArray_Phytree(array_phytree, c1); hold on;
    end
    
    if (array_phytree(c2).c1_phyIndex) ==0 && (array_phytree(c2).c2_phyIndex)==0
        return;
    else
        DrawArray_Phytree(array_phytree, c2); hold on;
    end
end
       


% legend(string_matrix);



function [folder_name] = saveGeoObjs_compTrees_rad_4layers(A10, data_path, idx1, idx2)
% save geodesic objects as obj files

    CT = A10;
    c = distinguishable_colors(70);
    
    folder_name = ['geodOBJs_', data_path, '-', num2str(idx1), 'and', num2str(idx2)];
    mkdir(folder_name);
    
    for i =1: numel(CT)
        compTree2obj_rad_4layer(CT{i}, [folder_name,'/',num2str(i)]);
    end
end
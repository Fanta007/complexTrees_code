function R = wg_neuro_flattenTreesRadii_3layers_rad(qCompTp_radii)


R = [];

for i = 1: numel(qCompTp_radii)

    k = 1;
    R(i, k) = qCompTp_radii{i}.len0; k = k+1;

    for j =1: numel(qCompTp_radii{i}.q_childrenR)

        R(i, k) = qCompTp_radii{i}.q_childrenR{j}.len0; k= k+1;

        for t = 1: numel(qCompTp_radii{i}.q_childrenR{j}.len)
            R(i, k) = qCompTp_radii{i}.q_childrenR{j}.len(t); k= k+1;
        end
    end
end

    

    


    



end
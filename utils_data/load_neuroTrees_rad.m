function [all_qCompTrees, compTrees] = load_neuroTrees_rad(data_path)

% --- get the swc files in the data_path ---
% data_path = 'NeuroData/chen/CNG version/';
cd utils_data/
swc_files = get_filenames(data_path);
tree_num = numel(swc_files);

%% read data and extract apical dendrite
raw_trees = cell(1,tree_num);
ST = cell(1,tree_num);
qST = cell(1,tree_num);
% figure;
% axis equal; hold on;
for i=1:tree_num
    
    raw_trees{i} = read_swcdata( strcat( data_path, swc_files{i}) );
    
%     figure;
%     axis equal; hold on;
%     title([num2str(i), '-th neuron tree']);
%     for t = 1: size(raw{i}, 1)
%         if t~=1
%             P1 = raw{i}(t, 3:5);
%             P2 = raw{i}(raw{i}(t, 7), 3:5);
%             if raw{i}(t, 2) == 4
%                 plot3([P1(1),P2(1)], [P1(2),P2(2)], [P1(3),P2(3)], 'k', 'LineWidth', 4); hold on;
%             elseif raw{i}(t, 2) == 3
%                 plot3([P1(1),P2(1)], [P1(2),P2(2)], [P1(3),P2(3)], 'k', 'LineWidth', 4); hold on;
%             else
%                 plot3([P1(1),P2(1)], [P1(2),P2(2)], [P1(3),P2(3)], 'k', 'LineWidth', 4); hold on;
%             end
%         end
%     end 
%     scatter3(0, 0, 0, 'r', '*', 'LineWidth', 10); hold on;
        
%     ST{i} = ST_from_swcdata(raw{i},4);

% --- this function convert the orginal raw data to layer-representation
    compTrees{i} = compTree_from_swcdata_rad(raw_trees{i}, 4);  
    
%     Q{i} = wg_neuro_ComplexTree_to_qComplexTree(CompT{i});
%     
%     T{i} = qComplexTree_to_ComplexTree(Q{i});
    
end
% return;
%
% % --- here we judge the orientation of the neuron trees ---
% Orien = zeros(1, N);
% for i = 1: N
%     if CompT{i}.beta0(2, end) > 0   % --- judge the orientation by the y-value of the end points in 1st layer ---
%         Orien(i) = 1;
%     else
%         Orien(i) = -1;
%     end
% end
% 
% % --- now only consider the "Orien(i) = 1" neuron trees ---
% CompT_test = cell(1, 0);
% for i=1:N
%     if Orien(i) == 1
%         CompT_test = [CompT_test, CompT{i}];
%     end
% end
% 
% CompT = CompT_test;

% return;

% --- swcdata to complex tree ---
% 
% CT_1 = wg_neuro_ComplexTree_to_qComplexTree(CompT{20});
% CT_2 = wg_neuro_ComplexTree_to_qComplexTree(CompT{19});
% 
% return;

% return;

%%
% Q2 = qCompT{1};
% Q1 = qCompT{2};

%%
% qCompTree_1 = CompTree_to_qCompTree_rad_4layers(compTrees{90});
% qCompTree_2 = CompTree_to_qCompTree_rad_4layers(compTrees{97});

% allTrees= [qCompTree_1, qCompTree_2];
all_qCompTrees = cell(1, tree_num);
for i= 1:tree_num
    all_qCompTrees{i} = CompTree_to_qCompTree_rad_4layers(compTrees{i});
end

cd ..

end


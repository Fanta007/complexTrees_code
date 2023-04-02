function [trunk1, trunk2] = Labeling_3_Layers(trunk1, trunk2)

num = 1;
for i=1: numel(trunk1.children)   
    for j=1: numel(trunk1.children{i}.children)               
        trunk1.children{i}.children{j}.label = ['Layer3_L' num2str(num)];
        trunk2.children{i}.children{j}.label = ['Layer3_L' num2str(num)];
        num = num+1;    
    end
    trunk1.children{i}.label = ['Layer2_L' num2str(num)];
    trunk2.children{i}.label = ['Layer2_L' num2str(num)];
    num = num+1;
end

%%
trunk1.label = 'Layer1_T';
trunk2.label = 'Layer1_T';
% end of the file 
end
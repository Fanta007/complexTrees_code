function [trunk1, trunk2] = Labeling_4_Layers_confused(trunk1, trunk2)

num = 1;
for i=1: numel(trunk1.children)   
    for j=1: numel(trunk1.children{i}.children)       
        for k = 1: numel(trunk1.children{i}.children{j}.children)
            trunk1.children{i}.children{j}.children{k}.label = ['Layer4_L' num2str(num)];
            trunk2.children{i}.children{j}.children{k}.label = ['Layer4_L' num2str(num)];
            num = num+1;
        end           
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

%% here confuse the labeling to make comparison

children_num = numel(trunk1.children);
% temp  = trunk1.children{2}.label;
% trunk1.children{2}.label = trunk1.children{children_num-1}.label;
% trunk1.children{children_num - 1}.label = temp;

confused_matchings = randperm(children_num);

for i=1: children_num
    trunk1.children{i}.label = trunk2.children{confused_matchings(i)}.label;
end

% --- write the confused_matchings into a file
fp_3 = fopen(['fig1','.txt'], 'w');
for i=1: numel(confused_matchings)
fprintf(fp_3, '%d\n',confused_matchings(i));
end
fclose(fp_3);
% end of the file 
end
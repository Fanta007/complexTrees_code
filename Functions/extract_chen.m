clc;
clear;
close all
% cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching;

data_path = 'NeuroData/chen/CNG version/';
% data_path = 'NeuroData/guerraderocha/cng version/TypeII/';

swc_files = get_filenames(data_path);
N = numel(swc_files);


%% read data and extract apical dendrite
raw = cell(1,N);
ST = cell(1,N);
qST = cell(1,N);
figure;
axis equal; hold on;
for i=1:5
    figure;
    axis equal; hold on;
    
    raw{i} = read_swcdata( strcat( data_path,swc_files{i} ));
    
    for t = 1: size(raw{i}, 1)
        if t~=1
            P1 = raw{i}(t, 3:5);
            P2 = raw{i}(raw{i}(t, 7), 3:5);
            plot3([P1(1),P2(1)], [P1(2),P2(2)], [P1(3),P2(3)], 'g', 'LineWidth', 4); hold on;
        end
    end 
    scatter3(0, 0, 0, 'r', '*', 'LineWidth', 10); hold on;
        
    ST{i} = ST_from_swcdata(raw{i},4);
    qST{i} = SimpleTree_to_qSimpleTree(ST{i});
end

%% get category labels from filenames

% brain region: 1 for hippocampus CA1; 2 for neocortex layer 5
region = zeros(1,N); 
% experimental condition: 1 for control; 2,3 for treatment groups
expcond = zeros(1,N);

for i=1:N
    s = swc_files{i};
    if s(1)=='C'
        expcond(i) = 1;
        if s(5)=='H'
            region(i) = 1;
        elseif s(5)=='V'
            region(i) = 2;
        end
    elseif strcmp(s(1:4),'BDL-')
        expcond(i) = 2;
        if s(5)=='H'
            region(i) = 1;
        elseif s(5)=='V'
            region(i) = 2;
        end
    elseif strcmp(s(1:4),'BDLH')
        expcond(i) = 3;
        if s(7)=='H'
            region(i) = 1;
        elseif s(7)=='V'
            region(i) = 2;
        end
    end
end

grps = 3*(region-1) + expcond;

expcond2 = expcond;
expcond2(expcond2>=2) = 2;
grps2 = 2*(region-1) + expcond2;

%% save data
% save('chen_data_12022016.mat', 'qST','ST',...
%     'region','expcond','grps','expcond2','grps2',...
%     'N','data_path','swc_files');

%% display

% lw=4;
% set(0,'defaultLineLinewidth',lw);
% set(0,'defaultScatterSizedata',4*lw^2);
% set(0,'defaultScatterMarkerFaceColor','flat');
% 
% i=2;
% figure(1);
% DisplaySimpleTree(ST{1},false,false);
% cameratoolbar
% cameratoolbar('setmode','orbit');
% cameratoolbar('setcoordsys','none');
% 
% set(0,'defaultLineLinewidth','remove');
% set(0,'defaultScatterSizedata','remove');
% set(0,'defaultScatterMarkerFaceColor','remove');





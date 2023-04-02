clear;close all
cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching
load('Razetti_data_smoothed_02262016.mat');

%%

% i = 9; 
% i = 66; 

i = 55;
B = ST{i};
Q = qST{55};

q0 = Q.q0;
q = Q.q(2:3);

Qsw1 = make_qST(q0,q, [.45,.55]);
Qsw2 = make_qST(q0,q, [.55,.45]);

Bsw1 = qSimpleTree_to_SimpleTree(Qsw1);
Bsw2 = qSimpleTree_to_SimpleTree(Qsw2);

[Asw5,qAsw5] = GeodSimpleTreesPrespace(Qsw1,Qsw2,5);

%%
close all

lw=4;
set(0,'defaultLineLinewidth',lw);
set(0,'defaultScatterSizedata',4*lw^2);
set(0,'defaultScatterMarkerFaceColor','flat');


figure(1);
set(gcf,'outerposition', [100,350, 1500,483]);
DisplaySimpleTreeGeodesic(Asw5,true,5);
cameratoolbar
cameratoolbar('setmode','orbit');
cameratoolbar('setcoordsys','none');

% figure(100);
% DisplaySimpleTree(B,true,true)

set(0,'defaultLineLinewidth','remove');
set(0,'defaultScatterSizedata','remove');
set(0,'defaultScatterMarkerFaceColor','remove');

%%

ex_when = 'post_02262016';
ex_name = 'concept_demos';

fig_path = strcat('../../communication/figs/disc_sides/',...
    ex_when,'/geod/',ex_name,'/');

mkdir(fig_path);

fprintf('Exporting figures...\n');


fprintf('%d...\n',1);
export_fig(strcat(fig_path,'simple_switch'),...
    '-png','-a1','-eps','-transparent','-p0.02',1);
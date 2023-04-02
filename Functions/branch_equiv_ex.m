clear;close all
cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching

%%

load('Razetti_data_smoothed_02262016.mat');

i1 = 32;
% initial tree
ST1 = ST{i1};

% swap branch indices
ST2 = ST1;
s2 = [2,1];
ST2.beta = ST1.beta(s2);
ST2.T = ST1.T(s2);
ST2.tk = ST1.tk(s2);

% add a null branch
t3new = 0.2;
ST3 = AddZeroBranchesAt_ST(ST1,t3new);

% add two null and swap b2,b3
t4new = 0.2;
ST4 = AddZeroBranchesAt_ST(ST1,t4new);
s4 = [3,1,2];
ST4.beta = ST4.beta(s4);
ST4.T = ST4.T(s4);
ST4.tk = ST4.tk(s4);

% add three null and permute all
t5new = [0.95,0.4,0.5];
ST5 = AddZeroBranchesAt_ST(ST1,t5new);
s5 = [3,4,5,1,2];
ST5.beta = ST5.beta(s5);
ST5.T = ST5.T(s5);
ST5.tk = ST5.tk(s5);

t6new = [0.2,0.4,0.95];
ST6 = AddZeroBranchesAt_ST(ST1,t6new);
s6 = [3,1,2,4,5];
ST6.beta = ST6.beta(s6);
ST6.T = ST6.T(s6);
ST6.tk = ST6.tk(s6);


%%
close all

lw=4;
set(0,'defaultLineLinewidth',lw);
% set(0,'defaultLineMarkerSize',5*lw);
set(0,'defaultScatterSizedata',4*lw^2);
set(0,'defaultScatterMarkerFaceColor','flat');

figure(2);
set(gcf,'outerposition', [100,350, 1500,483]);
% set(gcf,'outerposition', [100,350, 750,300]);
A = {ST1, ST2, ST3, ST4, ST5};
DisplaySimpleTreeGeodesic(A,true);

figure(3);
set(gcf,'outerposition', [100,350, 1200,483]);
% set(gcf,'outerposition', [100,350, 750,300]);
A = {ST1, ST2, ST3, ST6};
DisplaySimpleTreeGeodesic(A,true);

set(0,'defaultLineLinewidth','remove');
% set(0,'defaultLineMarkerSize','remove');
set(0,'defaultScatterSizedata','remove');
set(0,'defaultScatterMarkerFaceColor','remove');

%%

ex_when = 'post_02262016';

fig_path = strcat('../../communication/figs/disc_sides/',...
    ex_when,'/branch_eq/');

fprintf('Exporting figures...\n');

export_fig(strcat(fig_path,'ex2'),...
    '-png','-a1','-eps','-transparent','-p0.02',2);

export_fig(strcat(fig_path,'ex3'),...
    '-png','-a1','-eps','-transparent','-p0.02',3);


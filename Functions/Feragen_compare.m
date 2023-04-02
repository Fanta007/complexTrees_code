clear;close all
% cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching

%%

% data_filename = 'Razetti_data_smoothed_02262016.mat';
data_filename = 'wu_data_12072016.mat';
% data_filename = 'chen_data_12022016.mat';

load(data_filename);

% % ii = find(1==cellfun(@(q)q.K,qST));
% ii = 6:10;
% B = ST(ii);
% n = numel(ii);

i = 7; 
B1 = ST{i};

% first: one small side branch
k = 4;
B1.K = 1;
B1.beta = B1.beta(k);
B1.T = B1.T(k);
B1.tk = B1.tk(k);

%second: same but with no side branch
B2 = B1;
B2.K = 0;
B2.beta = cell(1,0);
B2.T = [];
B2.tk = [];

B2p = B1;
B2p.beta{1} = repmat(B2p.beta{1}(:,1),1,B1.T(1));

% q-trees
Q1 = SimpleTree_to_qSimpleTree(B1);
Q2p = SimpleTree_to_qSimpleTree(B2p);

% QED trees
ind = interp1(B1.t,1:B1.T0, B1.tk);
m = 3;
X1 = cell(1,m);
X1{1} = B1.beta0(:,1:ind);
X1{2} = B1.beta0(:,ind:end);
X1{3} = B1.beta{1};

T0 = B1.T0;
t0 = linspace(0,1,T0);
x0 = repmat( X1{1}(:,1), 1,T0 );
for i=1:m
    X = X1{i};
    T = size(X,2);
    t = linspace(0,1,T);
    X1{i} = interp1(t,X',t0)' - x0;
end

X2 = cell(1,m);
X2{1} = B2.beta0;
X2{1} = X2{1} - x0;
X2{2} = repmat(X2{1}(:,end), 1,T0);
X2{3} = repmat(X2{1}(:,end), 1,T0);

%%
% dists = -ones(1,3);
% O = cell(1,3);
% for i=1:m
%     X = X1{i};
%     X = X - repmat( X(:,1), 1,T0 );
%     
%     O{i} = Procrustes_Points(X,X2);
%     X = O{i}'*X;
%     
%     dists(i) = norm(X-X2,'fro');
% end
% 
% [~,i] = min(dists);
% O = O{i};
% X2 = O*X2;

%%
stp = 5;

[A, qA] = GeodSimpleTreesPrespace(Q1, Q2p, stp);
[v,u] = BestViewDir(A);

Y = cell(1,stp);
s = linspace(0,1,stp);
for i=1:stp
    Y{i} = cell(1,m);
    for j=1:m
        Y{i}{j} = (1-s(i))*X1{j} + s(i)*X2{j};
    end
end

%%
x0 = X2{1};
x1 = X1{1};
x2 = X1{2};
x3 = X1{3};


gapsz = 20;

x2p = x2;
vgap = x2p(:,5)-x2p(:,1);
vgap = gapsz*vgap/norm(vgap);
x2p = x2p+repmat(vgap,1,T0);

x3p = x3;
vgap = x3p(:,5)-x3p(:,1);
vgap = gapsz*vgap/norm(vgap);
x3p = x3p+repmat(vgap,1,T0);

n = 4;
XX = cell(n);
XX{1} = {x0};
XX{2} = {x0,x3};
XX{3} = {x1,x2p,x3p};
XX{4} = {x0,x3p};

%%
close all

%%% set figure props for displaying trees
lw=4;
set(0,'defaultLineLinewidth',lw);
% set(0,'defaultLineMarkerSize',5*lw);
set(0,'defaultScatterSizedata',4*lw^2);
set(0,'defaultScatterMarkerFaceColor','flat');


for i=1:n
    
    figure(i);
    DisplayCurveSet(XX{i},false);
    axis off
    
    camtarget([0,0,0]);
    campos(v);
    camup(u);
    camlookat

    cameratoolbar
    cameratoolbar('setmode','orbit');
    cameratoolbar('setcoordsys','none');
    
end

% SRVF geod
figure(100);
set(gcf,'outerposition', [100,350, 1500,483]);
DisplaySimpleTreeGeodesic(A,true);

% QED geod
figure(101);
set(gcf,'outerposition', [100,350, 1500,483]);
DisplayCurveSetGeodesic(Y,true);
camtarget([0,0,0]);
campos(v);
camup(u);
camlookat

return;
%%% restore default figure properties
set(0,'defaultLineLinewidth','remove');
% set(0,'defaultLineMarkerSize','remove');
set(0,'defaultScatterSizedata','remove');
set(0,'defaultScatterMarkerFaceColor','remove');


%%
fig_path = 'tmp_figs/Feragen_compare/';
mkdir(fig_path);

fprintf('Exporting figures...\n');

return;
%%% trees
fprintf('%d...\n',1);
export_fig(strcat(fig_path,'X2'),...
    '-png','-eps','-transparent','-nocrop',1);

fprintf('%d...\n',2);
export_fig(strcat(fig_path,'X1'),...
    '-png','-eps','-transparent','-nocrop',2);

fprintf('%d...\n',3);
export_fig(strcat(fig_path,'X1_child'),...
    '-png','-eps','-transparent','-nocrop',3);

fprintf('%d...\n',4);
export_fig(strcat(fig_path,'X1_side'),...
    '-png','-eps','-transparent','-nocrop',4);


%%% geods
fprintf('%d...\n',100);
export_fig(strcat(fig_path,'geod_SRVF'),...
    '-png','-a1','-eps','-transparent','-p0.02',100);

fprintf('%d...\n',101);
export_fig(strcat(fig_path,'geod_QED'),...
    '-png','-a1','-eps','-transparent','-p0.02',101);



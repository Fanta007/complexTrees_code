clear;close all
cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching

%%

%%% get the tree data
disp('Reading in tree data...');
TM_path = '../../data/Razetti/';
TM_files = get_filenames(TM_path);

grps = [ ones(1,31), 2*ones(1,14), 3*ones(1,15), 4*ones(1,31) ];

N = numel(TM_files);

All_TM = cell(1,N);
All_ST = cell(1,N);
All_qST = cell(1,N);
for i=1:N
    load(strcat(TM_path,TM_files{i}));
    All_TM{i} = Tree_Master;
    All_ST{i} = master_to_SimpleTree(All_TM{i});
    All_qST{i} = SimpleTree_to_qSimpleTree(All_ST{i});    
end


%%
scl_xy = 0.093967;
scl_z = 0.814067 / 8;

scl_mat = diag([scl_xy,scl_xy,scl_z]);

All_ST_scl = cell(1,N);
All_qST_scl = cell(1,N);
for i=1:N
    All_ST_scl{i} = All_ST{i};
    All_ST_scl{i}.beta0 = scl_mat*All_ST_scl{i}.beta0;
    for k=1:All_ST{i}.K
        All_ST_scl{i}.beta{k} = scl_mat*All_ST_scl{i}.beta{k};
    end
    
    All_qST_scl{i} = SimpleTree_to_qSimpleTree(All_ST_scl{i});
end

%% save with simple names
TM = All_TM;
ST = All_ST_scl;
qST = All_qST_scl;

save('Razetti_data_scaled',...
    'TM_path','TM_files','grps','N','scl_mat','TM','ST','qST')


%% various diagnostic stuff related to scale and pixel size
% 
% all_pts = zeros(3,0);
% min_xyz = zeros(3,N);
% max_xyz = zeros(3,N);
% 
% for i=1:N
%     min_xyz(:,i) = min(cell2mat(cellfun(@(b)min(b,[],2), ...
%         All_ST{i}.beta, 'uniformoutput',false)), [],2);
%     min_xyz(:,i) = min([ min_xyz(:,i), All_ST{i}.beta0],[],2);
%     
%     max_xyz(:,i) = max(cell2mat(cellfun(@(b)max(b,[],2), ...
%         All_ST{i}.beta, 'uniformoutput',false)), [],2);
%     max_xyz(:,i) = max([ max_xyz(:,i), All_ST{i}.beta0],[],2);
%     
%     all_pts = [all_pts, All_ST{i}.beta0];
%     all_pts = [all_pts, cell2mat(All_ST{i}.beta)];
% end
% 
% xyzrange = max_xyz-min_xyz;
% 
% all_disp0 = cellfun(...
%     @(B) abs(B.beta0(:,1)-B.beta0(:,end)), All_ST,...
%     'uniformoutput',false);
% all_disp0 = cell2mat(all_disp0);
% 
% % all_disp0_scl = cellfun(...
% %     @(B) (B.beta0(:,1)-B.beta0(:,end)), All_ST_scl,...
% %     'uniformoutput',false);
% % all_disp0_scl = cell2mat(all_disp0_scl);
% 
% all_len0 = cellfun(@(q)q.len0,All_qST);
% all_sum_of_len = cellfun(@(q)(q.len0 + sum(q.len)),All_qST);
% all_len0_scl = cellfun(@(q)q.len0,All_qST_scl);
% all_sum_of_len_scl = cellfun(@(q)(q.len0 + sum(q.len)),All_qST_scl);
% 
% [M_disp,I_disp] = sort(abs(all_disp0(3,:)),'descend');
% [M_len0,I_len0] = sort(all_len0,'descend');
% [M_len0_scl,I_len0_scl] = sort(all_len0_scl,'descend');
% [M_len,I_len] = sort(all_sum_of_len,'descend');
% [M_len_scl,I_len_scl] = sort(all_sum_of_len_scl,'descend');
% [M_xr,I_xr] = sort(xyzrange(1,:),'descend');
% [M_yr,I_yr] = sort(xyzrange(2,:),'descend');
% [M_zr,I_zr] = sort(xyzrange(3,:),'descend');
% 
% %%
% close all
% 
% nbins = 30;
% nnbins = 100;
% 
% % figure; 
% % hist(all_len0,nbins);
% % 
% % figure; 
% % hist(all_sum_of_len,50);
% % 
% % figure; 
% % hist(all_len0_scl,nbins);
% % 
% % figure; 
% % hist(all_sum_of_len_scl,50);
% 
% for i = [46];
%     figure;
%     DisplaySimpleTree(All_ST{i})
%     figure;
%     DisplaySimpleTree(All_ST_scl{i})
% end
% 
% % figure;
% % hist(all_pts(1,:),nnbins);
% % figure;
% % hist(all_pts(2,:),nnbins);
% % figure;
% % hist(all_pts(3,:),nnbins);
% 
% % figure;
% % hist(scl_xy*all_pts(1,:),nnbins);
% % figure;
% % hist(scl_xy*all_pts(2,:),nnbins);
% % figure;
% % hist(scl_z*all_pts(3,:),nnbins);
% 
% % figure;
% % hist(abs(all_disp0(3,:)),nbins);
% 
% % figure;
% % hist( sqrt(sum(all_disp0.^2,1)),nbins);
% % figure;
% % hist( sqrt(sum((scl_mat*all_disp0).^2,1)),nbins);
% 
% % figure;
% % hist(min_z,nbins);
% % figure;
% % hist(max_z,nbins);
% % 
% % figure;
% % hist(abs(all_disp0(3,:)),nbins);
% 
% figure;
% hist(xyzrange(3,:)/8,nbins);
% figure;
% hist(xyzrange(1,:),nbins);
% figure;
% hist(xyzrange(2,:),nbins);
% 
% 




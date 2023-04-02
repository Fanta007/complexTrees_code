clear;close all
% cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching

%%% get the (properly scaled) tree data
load('Razetti_data_scaled')

%% diagnostic stuff wrt smoothing and discretization
% 
% % smooth_diam = 1;
% % smooth_sz = 2*smooth_diam +1;
% % kern = gausswin(smooth_sz)';
% % kern = kern/sum(kern);
% % 
% % gkcum = cumsum(kern);
% % front_correct = 
% 
% ST_sm = ST;
% qST_sm = cell(1,N);
% % p=.999;
% for i=1:1
%     fprintf('%i, q0\n',i);
%     for d=1:3
%         t = ST{i}.t;
%         [b,~,o] = fit(t',ST{i}.beta0(d,:)','smoothingspline', ...
%             'SmoothingParam', p);
%         ST_sm{i}.beta0(d,:) = b(t)';
%     end
%     for k=1:ST{i}.K
% %         fprintf('%i, q%i (K=%i)\n',i,k,ST{i}.K);
%         for d=1:3
%             t = linspace(0,1,ST{i}.T(k));
%             [b,~,o] = fit(t',ST{i}.beta{k}(d,:)','smoothingspline', ...
%             'SmoothingParam', p);
%             ST_sm{i}.beta{k}(d,:) = b(t)';
%         end
% %         bp = interp1(ST_sm{i}.t,ST_sm{i}.beta0',ST_sm{i}.tk(k))';
% %         dbp = bp-ST_sm{i}.beta{k}(:,1);
% %         ST_sm{i}.beta{k} = ST_sm{i}.beta{k} ...
% %             + repmat(dbp,1,ST_sm{i}.T(k));
%     end
%     
%     qST_sm{i} = SimpleTree_to_qSimpleTree(ST_sm{i});
% end

%% completely diferent approach
ds = .2;

ST_sm = ST;
qST_sm = cell(1,N);

rad = 6;
sp = 2*rad*[1,1,7]+1;
flt = 'sgolay';


for i = 1:N
    
    %%% clean up sides
    for k=1:ST{i}.K
        % pick new discretization size
        Tnew = 2^ceil(log2( qST{i}.len(k)/ds ))+1;
        Tnew = max(Tnew,2);
        ST_sm{i}.T(k) = Tnew;
        
        % resample by arc-length
        t = linspace(0,1,Tnew);
        t_old = linspace(0,1,ST{i}.T(k));
        s = cumtrapz(t_old, sum( qST{i}.q{k}.^2, 1) );
        s = s/s(end);
	    ST_sm{i}.beta{k} = spline(s,ST_sm{i}.beta{k},t);
        
        % smooth
        for d = 1:3
            ST_sm{i}.beta{k}(d,:) = smooth(ST_sm{i}.beta{k}(d,:)',...
                sp(d),flt,1)';
        end
    end
    
    %%% clean up main
    % pick new discretization size
    Tnew = 2^ceil(log2( qST{i}.len0/ds ))+1;
    ST_sm{i}.T0 = Tnew;
    
    % resample by arc-length
    t = linspace(0,1,Tnew);
    s = qST{i}.s;
    ST_sm{i}.beta0 = spline(s,ST_sm{i}.beta0,t);
    ST_sm{i}.tk = qST{i}.sk;
    ST_sm{i}.t = t;
    
    % smooth
    for d = 1:3
        ST_sm{i}.beta0(d,:) = smooth(ST_sm{i}.beta0(d,:)',...
            sp(d),flt,1)';
    end
    
    % adjust position of sides
    bp = spline(t, ST_sm{i}.beta0, ST_sm{i}.tk);
    for k=1:ST{i}.K
        dbp = bp(:,k)-ST_sm{i}.beta{k}(:,1);
        ST_sm{i}.beta{k} = ST_sm{i}.beta{k} ...
            + repmat(dbp,1,ST_sm{i}.T(k));
    end
    
    % compute qtree as well
    qST_sm{i} = SimpleTree_to_qSimpleTree(ST_sm{i});
    
end

%% save with simple names
ST = ST_sm;
qST = qST_sm;

save('Razetti_data_smoothed_02262016.mat',...
    'TM_path','TM_files','grps','N','TM','ST','qST')


%%
% close all

for i = 83
    figure(1);
    DisplaySimpleTree(ST{i})
    figure(2);
    DisplaySimpleTree(ST_sm{i})
%     keyboard 
end

% img_path = 'razetti_smooth_02262016';
% figure;
% for i = 1:N;
%     DisplaySimpleTree(ST_sm{i})
%     saveas(gcf, sprintf('%s/%02d_%s.png',...
%         img_path,i,TM_files{i}(1:end-4)) );
% end

%%
% close all

% nb = 30;
% nnb = 100;
% 
% % various about old discretizations
% all_T0 = cellfun(@(B)B.T0,ST);
% all_T = cellfun(@(B)B.T,ST, 'uniformoutput',false);
% all_Ti = cell2mat(all_T);
% 
% all_len0 = cellfun(@(q)q.len0,qST);
% all_len = cellfun(@(q)q.len,qST, 'uniformoutput',false);
% all_leni = cell2mat(all_len);
% 
% ds_pooled = [all_len0./(all_T0-1), all_leni./(all_Ti-1)];
% ds_mean = mean(ds_pooled);
% ds_95 = quantile(ds_pooled,[.025,.975]);
% ds_90 = quantile(ds_pooled,[.05,.95]);
% 
% % various about new discretizations
% all_T0_sm = cellfun(@(B)B.T0,ST_sm);
% all_T_sm = cellfun(@(B)B.T,ST_sm, 'uniformoutput',false);
% all_Ti_sm = cell2mat(all_T_sm);
% 
% all_len0_sm = cellfun(@(q)q.len0,qST_sm);
% all_len_sm = cellfun(@(q)q.len,qST_sm, 'uniformoutput',false);
% all_leni_sm = cell2mat(all_len_sm);
% 
% ds_pooled_sm = [all_len0_sm./(all_T0-1), all_leni_sm./(all_Ti-1)];
% ds_mean_sm = mean(ds_pooled_sm);
% ds_95_sm = quantile(ds_pooled_sm,[.025,.975]);
% ds_90_sm = quantile(ds_pooled_sm,[.05,.95]);
% 
% len_ratios = [all_len0_sm./all_len0,all_leni_sm./all_leni];
% 
% figure;
% hist([all_T0,all_Ti],nnb);
% title('Discretization Sizes (before)');
% figure;
% hist([all_T0_sm,all_Ti_sm],nnb);
% title('Discretization Sizes (after)');
% 
% figure;
% hist(ds_pooled,nnb)
% title('Average Stepsize (before)');
% figure;
% hist(ds_pooled_sm,nnb)
% title('Average Stepsize (after)');
% 
% figure;
% hist(len_ratios,nnb)
% title('Length change ratio');


clear;close all
cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching;

data_filename = 'chen_data_12022016.mat';
load(data_filename);

ex_path = 'chen_12022016/allpairs/';
results_path = ['tmp_results/',ex_path];
files = get_filenames(results_path);

for i=1:numel(files)
    %%% make plots, save plots and data
    f = files{i};
    load( [results_path, f] );
    
%     pstr = f(9:end-4);
%         
%     prevdir = cd();
%         
%     cd('tmp_figs');
%     mkdir(ex_path);
%     cd(ex_path);
%     mkdir(pstr);
%     cd(pstr);
%     
%     set(0,'defaultFigureVisible','off');
%     
%     % grp_labels = cellfun(@num2str,num2cell(grps),'uniformoutput',false);
%     % grp_labels = cellfun(@(s,i)sprintf('%s\\newline%d',s,i),grp_labels,...
%     %     num2cell(1:N), 'uniformoutput',false);
%     grp_names = {'1','2','3','4','5','6'};
%     grp_names = grp_names(grps);
%     grp_labels = cellfun(...
%         @(i,g)sprintf('%d{\\bf %s}',i,g), num2cell(1:N), grp_names,...
%         'uniformoutput',false);
%     
%     
%     Z1 = linkage(all_dists,'average');
%     figure(11);
%     [~,~,outp] = dendrogram(Z1,N);
%     set(gca,'XTickLabels',grp_labels(outp),'XTickLabelRotation',90);
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     saveas(gcf,sprintf('dendro_avg_%s.png',pstr));
%     
%     Z2 = linkage(all_dists,'complete');
%     figure(12);
%     [~,~,outp] = dendrogram(Z2,N);
%     set(gca,'XTickLabels',grp_labels(outp),'XTickLabelRotation',90);
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     saveas(gcf,sprintf('dendro_max_%s.png',pstr));
%     
%     Z3 = linkage(all_dists,'single');
%     figure(13);
%     [~,~,outp] = dendrogram(Z3,N);
%     set(gca,'XTickLabels',grp_labels(outp),'XTickLabelRotation',90);
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     saveas(gcf,sprintf('dendro_min_%s.png',pstr));
%     
%     Z4 = linkage(all_dists,'weighted');
%     figure(14);
%     [~,~,outp] = dendrogram(Z4,N);
%     set(gca,'XTickLabels',grp_labels(outp),'XTickLabelRotation',90);
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     saveas(gcf,sprintf('dendro_wtd_%s.png',pstr));
%     
%     [Y,e] = cmdscale(distmat);
%     J = 4;
%     figure(4);
%     gplotmatrix(Y(:,1:J),Y(:,1:J),grps);
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     saveas(gcf,sprintf('mds_plots_%s.png',pstr));
%     
%     % for i=1:N;
%     %     figure(i+10);
%     %     DisplaySimpleTree(All_ST{i});
%     %     saveas(gcf, sprintf('%02i_%02i.png',i,keep_ind(i)));
%     % end
%     
%     set(0,'defaultFigureVisible','factory');
%     
%     cd(prevdir)
    %%
    
%     mkdir(results_path);
    save([results_path,f],...
        'data_filename','lam_m','lam_s','lam_p',...
        'all_G','all_O','all_dists','distmat',...
        'region','expcond','grps','expcond2','grps2');
end
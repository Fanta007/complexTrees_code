clear;
close all
% cd ~/Dropbox/AxonalTreeGeometry/code/DiscreteSideMatching

%%

% data_file = 'chen_data_12022016.mat';
% data_name = 'chen_12022016';
% pstr = '0.01000_0.01000_1.0';

data_file = 'wu_data_12072016.mat';
data_name = 'wu_12072016';
pstr = '0.020_1.000_1.0';

results_file = ['tmp_results/',data_name,'/allpairs/distmat_',pstr,'.mat'];

load(data_file);
load(results_file);

% N = size(distmat,1);

inds = zeros(size(all_dists,2),2);
k=1;
for i=1:N-1
    for j=i+1:N
        inds(k,1) = i;
        inds(k,2) = j;
        k = k+1;
    end
end

[~,kmin] = min(all_dists);
fprintf('Min at: %d,%d\n',inds(kmin,1),inds(kmin,2));
[~,kmax] = max(all_dists);
fprintf('Max at: %d,%d\n',inds(kmax,1),inds(kmax,2));

[sorted_dists,kord] = sort(all_dists);
inds_sorted = inds(kord,:);

fprintf('Smallest dists:\n');
inds_sorted(1:5,:)'
sorted_dists(1:5)

fprintf('Largest dists:\n');
inds_sorted(end-4:end,:)'
sorted_dists(end-4:end)


% Algorithms 3 and 4 in paper

% qST           sample of SRVF trees to multiply-align
% lam_(m,s,p)   tuning params for metric
% R             number of passes to align sample trees to mean
% Nitr_relax    num iter for coord relax in individual alignments
% S             permutation of sample indices for making initial muQ
function [muQ, qCompTp, E, G,O] ...
    = func_MultiAlign_qCompT_4layers_r(qCompT, lam_m,lam_s,lam_p, R, Nitr_relax, S)

N = numel(qCompT);

% set default iteration parameters if not provided
if nargin < 5 || R==0
    R = 5;
end
if nargin < 6 || Nitr_relax==0
    Nitr_relax = 3;
end
if nargin < 7
    S = 1:N;
end

%%%%% MAKE INITIAL MEAN ESTIMATE %%%%%
fprintf('\nMake Initial muQ: \n\n');

i = S(1); j = S(2);

fprintf('Aligning first two trees (%d and %d)...\n',i,j);
tm = tic;
% [~,muQ,qCompTp{j}] = ReparamPerm_qST_complex_4layers_rad(qCompT{i},qCompT{j}, lam_m,lam_s,lam_p);

% [~,qA] = GeodComplexTreesPrespace_4layers_rad(muQ,qCompTp{j}, [0, 1/2, 1] );
% muQ = qA{1};
muQ = qCompT{i};
% --- draw the mean tree ---
% tmp_mu = qComplexTree_to_ComplexTree(muQ);
% wg_root_showOneComplexTree(tmp_mu);

toc(tm)
fprintf('\n');

for i_num=1:N
    
    j_num = S(i_num);
    fprintf('Aligning tree %d (no. %d of %d)...\n',j_num,i_num,N);
    tm = tic;
    
    [~,muQ,qCompTp{j_num}] = ReparamPerm_qST_complex_4layers_rad(muQ, qCompT{j_num}, lam_m,lam_s,lam_p);
    % --- draw the mean tree ---

    [A,qA] = GeodComplexTreesPrespace_4layers_rad(muQ,qCompTp{j_num}, [0, 1/i_num, 1] );
    
%     [A1,qA1] = GeodComplexTreesPrespace(muQ,qCompTp{j_num}, 0:0.2:1 );
%     run showCompNeuroTrees_4layers_r.m
%     title(['geodesic between mean tree and ', num2str(j_num), ' tree']); hold off;
%     
    mu = AddOneFieldForNeuro_4layers(A{2});
    muQ = ComplexTree_to_qComplexTree_4layers_rad(mu);
    
%     run wg_neuro_showComplexNeuroTrees_4layers_rad.m
    % --- draw the mean tree ---
%     tmp_mu = qComplexTree_to_ComplexTree_4layers_rad(muQ);
%     run showCompNeuroTrees_4layers_r_mean.m
%     wg_root_showOneComplexTree(tmp_mu);
%     title(['current mean tree', num2str(i_num),'-loops']);
    
    %% Re-construct the mean tree (delete the unecessary sub-trees)
%     inds = find(muQ.len ~= 0);
%     
%     Mu_new.q_children = muQ.q_children(inds);
%     Mu_new.b00 = muQ.b00;
%     Mu_new.d = 3;
%     Mu_new.sk = muQ.sk(inds);
%     Mu_new.tk = muQ.tk(inds);
%     Mu_new.len = muQ.len(inds);
%     Mu_new.T = muQ.T(inds);
%     Mu_new.q = muQ.q(inds);
%     Mu_new.K = numel(Mu_new.q);
%     Mu_new.len0 = muQ.len0;
%     Mu_new.T0 = muQ.T0;
%     Mu_new.q0 = muQ.q0;
%     Mu_new.s = muQ.s;
%     Mu_new.t = muQ.t;
%     
%     Mu_new = orderfields(Mu_new, ...
%         {'t','s','q0','T0','len0','K','q','T','len','tk','sk','d','b00','q_children'});
%     
%     muQ = Mu_new;
%     tmp_tree = qComplexTree_to_ComplexTree(qCompTp{j_num});
%     wg_root_showOneComplexTree(tmp_tree);

%     disp(['muQ children number is :', num2str(numel(muQ.q_children))]);
%     
%     disp([num2str(j_num), '-th tree children number is', num2str(numel(qCompT{j_num}.q_children)) ])
%     
    time = toc(tm);
    disp(['Elapsed time: ',num2str(floor(time/60)), ' ','minutes ', num2str(mod(time, 60)),' ' ,'seconds']);
    
    fprintf('\n');
end




fprintf('%d side branches in result (first pass)\n',muQ.K_sideNum);

E = zeros(1,R);
% qCompTp = cell(1,N);
G = cell(1,N);
O = cell(1,N);

% --- Align all input trees to the mean tree ---
% for i=1:N
%     fprintf('Aligning to mean, tree %d of %d...\n',i,N);
%     tm = tic;
%     [qCompTp_align{i},G{i},O{i}, muQ_2] = AlignFull_qComplexTree(qCompT{i},muQ, ...
%         lam_m,lam_s,lam_p, Nitr_relax);
%     toc(tm)
% %     E(r) = E(r) + G{i}.E;
% 
%     fprintf('%d side branches (tree %d)\n',qCompTp{i}.K,i);
% 
%     fprintf('\n');
% end



for r = 1:1
    fprintf('\nPass No. %d (of %d): \n\n',r,R);
    E(r) = 0;
    
    %%%%% ALIGN SAMPLE TREES TO MEAN ESTIMATE %%%%%
    
%     for i=1:N
%         fprintf('Aligning to mean, tree %d of %d...\n',i,N);
%         tm = tic;
%         [qCompTp_align{i},G{i},O{i}] = AlignFull_qComplexTree(qCompT{i},muQ, ...
%             lam_m,lam_s,lam_p, Nitr_relax);
%         toc(tm)
%     %     E(r) = E(r) + G{i}.E;
% 
%         fprintf('%d side branches (tree %d)\n',qCompTp_align{i}.K,i);
% 
%         fprintf('\n');
%     end
%%
    %%%%% CONSTRUCT NEW MEAN ESTIMATE %%%%%
    

    
%     q0All = qCompTp{1}.q0;
%     qAll = qCompTp{1}.q;
%     for i=2:N
%         q0All = cat(3,q0All,qCompTp{i}.q0);
%         for k=1:muQ.K
%             qAll{k} = cat(3,qAll{k},qCompTp{i}.q{k});
%         end
%     end
%     
%     muQ.q0 = mean(q0All,3);
%     muQ.s = cumtrapz(muQ.t, sum(muQ.q0.^2,1),2);
%     muQ.len0 = muQ.s(end);
%     muQ.s = muQ.s/muQ.len0;
%     
%     for k=1:muQ.K
%         muQ.q{k} = mean(qAll{k},3);
%         t = linspace(0,1,muQ.T(k));
%         muQ.len(k) = trapz(t,sum(muQ.q{k}.^2,1),2);
%         muQ.sk(k) = mean(cellfun(@(Q)Q.sk(k),qSTp));
%     end
%     muQ.tk = interp1(muQ.s,muQ.t,muQ.sk);
%     
%     branch_present = (muQ.len~=0);
%     
%     muQ.K = sum(branch_present);
%     muQ.q = muQ.q(branch_present);
%     muQ.T = muQ.T(branch_present);
%     muQ.len = muQ.len(branch_present);
%     muQ.tk = muQ.tk(branch_present);
%     muQ.sk = muQ.sk(branch_present);

end

    
end
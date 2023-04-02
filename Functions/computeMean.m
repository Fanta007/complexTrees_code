% Algorithms 3 and 4 in paper

% qST           sample of SRVF trees to multiply-align
% lam_(m,s,p)   tuning params for metric
% R             number of passes to align sample trees to mean
% Nitr_relax    num iter for coord relax in individual alignments
% S             permutation of sample indices for making initial muQ
function [muQ, qCompTp, E, G,O] ...
    = computeMean(qCompT, lam_m,lam_s,lam_p, R, Nitr_relax, S)

N = numel(qCompT);  % number of input trees

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

%% initial mean estimate
i = S(1);
j = S(2);

fprintf('Aligning first two trees (%d and %d)...\n',i,j);
tm = tic;

muQ = qCompT{1};        % initialize withthe first tree

nIter = 1;              % let's test with just one step
% for it=1:nIter
%     
%     qV = cell(N);       % The shooting vectors
%     for j=2:N,  % for each tree
%         
%         % Correspondence 
%         [~, ~, qCompTp{j}] = ReparamPerm_qST_complex_3layers_rad(muQ, qCompT{j}, lam_m,lam_s,lam_p);
%         % I need a shooting vector from muQ to qCompTp{j}
%         qV{j} = ShootingVectorComplexTreesPrespace(muQ, qCompTp{j}, lam_m,lam_s,lam_p);
%         % [~,qA] = GeodComplexTreesPrespace(muQ, qCompTp{j}, [0.0, 0.5, 1.0] );
%         muQ = qA{1};
%         
%     end
%     
%     % Update muQ
%     
%     
% end

[G, muQ, qCompTp{j}] = ReparamPerm_qST_complex_3layers_rad(qCompT{i}, qCompT{j}, lam_m,lam_s,lam_p);
[~, qA] = GeodComplexTreesPrespace(muQ, qCompTp{j}, [0.0, 0.5, 1.0], [lam_m,lam_s,lam_p] ); % Why is it needed??
muQ     = qA{1};
% muQ = qCompT{i};
% --- draw the mean tree ---
% tmp_mu = qComplexTree_to_ComplexTree(muQ);
% wg_root_showOneComplexTree(tmp_mu);

toc(tm)
% fprintf('\n');

for i_num=1:N
    j_num = S(i_num);
    fprintf('Aligning tree %d (no. %d of %d)...\n',j_num,i_num,N);
    tm = tic;
    
    [G, muQ, qCompTp{j_num}] = ReparamPerm_qST_complex_3layers_rad(muQ, qCompT{j_num}, lam_m,lam_s,lam_p);      
    [A, qA] = GeodComplexTreesPrespace(muQ, qCompTp{j_num}, [0, 1/i_num, 1], true); %, [lam_m,lam_s,lam_p]);

     TT = qComplexTree_to_ComplexTree_rad(qA{2});
%     figure(200); clf; 
%     plotTree(TT, 23);
%     axis equal; cameramenu; 
%     pause
    
    run wg_tree_showComplexTrees.m
    
    figure (i_num * 10);
    mu  = AddOneFieldFor_complexNeuro(A{2});
    muQ = ComplexTree_to_qComplexTree_rad(mu);  
    %    
    
    time = toc(tm);
    disp(['Elapsed time: ',num2str(floor(time/60)), ' ','minutes ', num2str(mod(time, 60)),' ' ,'seconds']);
    
    fprintf('\n');
end

% fprintf('%d side branches in result (first pass)\n',muQ.K);

E = zeros(1,R);
% qCompTp = cell(1,N);
G = cell(1,N);
O = cell(1,N);


    
end
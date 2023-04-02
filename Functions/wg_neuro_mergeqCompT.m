function [qCompT] = wg_neuro_mergeqCompT(qCompT_t, qCompT_b)


% CompT = CompT{1};
% CompT_t = CompT;
% CompT_b = CompT;

qCompT.t_paras = qCompT_t.t_paras;
qCompT.s = qCompT_t.s;
qCompT.q0 = qCompT_t.q0;
qCompT.T0_pointNum = qCompT_t.T0_pointNum;
qCompT.len0 = qCompT_t.len0;
qCompT.K_sideNum = qCompT_t.K_sideNum +  qCompT_b.K_sideNum; 
qCompT.q = [qCompT_t.q, qCompT_b.q];
qCompT.T_sidePointNums = [qCompT_t.T_sidePointNums, qCompT_b.T_sidePointNums];
qCompT.len = [qCompT_t.len, qCompT_b.len];
qCompT.tk_sideLocs = [qCompT_t.tk_sideLocs, zeros(1, numel(qCompT_b.tk_sideLocs) )];
qCompT.sk = [qCompT_t.sk, zeros(1, numel(qCompT_b.sk) )];
qCompT.dimension = 4;
qCompT.b00_startP = qCompT_t.b00_startP;
qCompT.q_children = [qCompT_t.q_children, qCompT_b.q_children];
% qCompT.q_children_p = [qCompT_t.q_children_p, qCompT_b.q_children_p];
qCompT.func_t_parasAndRad = qCompT_t.func_t_parasAndRad;
qCompT.data_t_parasAndRad = qCompT_b.data_t_parasAndRad;

end
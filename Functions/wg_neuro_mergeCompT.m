function CT = wg_neuro_mergeCompT(CT_t, CT_b)

CT.t_paras = CT_t.t_paras;
CT.s = CT_t.s;
CT.q0 = CT_t.q0;
CT.T0 = CT_t.T0;
CT.len0 = CT_t.len0;
CT.K = CT_t.K +  CT_t.K; 
CT.q = [CT_t.q, CT_t.q];
CT.T = [CT_t.T, CT_t.T];
CT.len = [CT_t.len, CT_t.len];
CT.tk = [CT_t.tk, zeros(1, numel(CT_t.tk) )];
CT.sk = [CT_t.sk, zeros(1, numel(CT_t.sk) )];
CT.d = 3;
CT.b00 = CT_t.b00;
CT.q_children = [CT_t.q_children, CT_b.q_children];  % --- maybe wrong ---
CT.q_children_p = [CT_t.q_children_p, CT_b.q_children_p];  % --- maybe wrong ---

CT.beta0 = CT_t.beta0;
CT.beta = [CT_t.beta, CT_b.beta];
CT.beta_children = [CT_t.beta_children, CT_b.beta_children];





end





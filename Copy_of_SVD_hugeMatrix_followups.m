% load qX
load('qX.mat');

% covariance
covMat = cov(qX);
qX_mean = mean(qX);

% SVD
[V,E,U] = svd(covMat);
save('V_E_U.mat', 'V', 'E', 'U');
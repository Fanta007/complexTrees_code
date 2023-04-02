function [Tn, L] = normalizeScale(T)
%
% L is the original scale, in case we want to recover the scale at the end
%

%% 1. Length of the main branch
L = 0;

for i=1:size(T.beta0, 2)-1   
    L = L + norm(T.beta0(1:3, i+1) - T.beta0(1:3, i)); 
end

%% 2. Divide by the length of the main branch
Tn = scaleTree(T, L);
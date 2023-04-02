function L = calcuLen_simpleTree(T)


L = 0;

for i=1:size(T.beta0, 2)-1   
    L = L + norm(T.beta0(1:3, i+1) - T.beta0(1:3, i)); 
end



end
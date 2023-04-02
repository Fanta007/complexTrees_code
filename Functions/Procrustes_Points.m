function O = Procrustes_Points(X1,X2)

A = X2*X1';

if norm(A,'fro') < 0.00001
    O = eye(size(A));
else
    [U,~,V] = svd(A);
    
    if det(A)> 0
        O = U*V';
    else
        O = U*([V(:,1) V(:,2) -V(:,3)])';
    end
end
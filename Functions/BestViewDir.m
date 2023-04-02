function [fwd,up] = BestViewDir(ST)

if ~iscell(ST)
    ST = {ST};
end

N = numel(ST);
d = ST{1}.d;
main_displacement = zeros(d,N);
X = zeros(d,0);
for i=1:N
    main_displacement(:,i) = ST{i}.beta0(:,end)-ST{i}.beta0(:,1); 
    B = [ST{i}.beta0, ST{i}.beta{~isnan(ST{i}.tk)}];
    for j=1:d
        B(j,:) = B(j,:) - mean(B(j,:));
    end
    X = [X, B];
end

main_displacement = mean(main_displacement,2);

C = X*X';
[V,~] = eig(C);

fwd = V(:,1)';

up = V(:,2)'+V(:,3)';
up = up/norm(up);

% size(up)
% size(main_displacement)

if up*main_displacement < 0
    up = -up;
end
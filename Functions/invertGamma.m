function gamI = invertGamma(gam)

N = length(gam);
x = [1:N]/N;
gamI = spline(gam,x,x);
gamI = gamI/gamI(N);

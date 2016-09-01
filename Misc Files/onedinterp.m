function y = onedinterp(x,k)


d = max(diff(x))

dnew = d/(2^(k-1))
y = [x(1):dnew:x(end)];


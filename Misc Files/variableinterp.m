function y = variableinterp(x, varinterp)

xsize = size(x);
disp('variableinterp')
disp(varinterp)
disp(xsize)
disp(length(xsize))
if length(xsize) == 3
    %third element is time, so you need to do size(x,3) interp2s on the
    %data
    timeend = xsize(3);
    for k = 1:timeend
        y(:,:,k) = interp2(x(:,:,k),varinterp);
    end
elseif length(xsize) == 4
    %fourth element is time so you need to do size(x,4) interp3s on the
    %data
    timeend = xsize(4);
    disp(timeend)
    for k = 1:timeend
        y(:,:,:,k) = interp3(x(:,:,:,k), varinterp);
    end
else
    %error or something
end
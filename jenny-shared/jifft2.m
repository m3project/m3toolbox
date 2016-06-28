function F = jifft2(freqx,freqy,FT,x,y);
% F = jifft2(freqx,freqy,FT,x,y);
% Suppose you used my function [FT,freqx,freqy] = jfft2(x,y,F) to obtain the FT of a function F,
% and now you want to use ifft2 to get the original function back again.
[fx2,fy2]=meshgrid(freqx,freqy);
[ny,nx]=size(fx2);
sx = isodd(nx);
sy = isodd(ny);
if length(x)>1
    dx=min(diff(x));
else
    dx=1;
end
if length(y)>1
    dy=min(diff(y));
else
    dy=1;
end
F = ifft2(shiftx(shifty(fftshift(FT.* exp(2*pi*i*x(1).* fx2 + 2*pi*i*y(1).*fy2)),sy),sx))/dx/dy;

end


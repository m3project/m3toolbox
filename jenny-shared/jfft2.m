function [FT,freqx,freqy] = jfft2(x,y,F);
% This is to make it easier for me to use the Matlab function fft2.
% Suppose you have the function F, evaluated as a function of (x,y), and you
% want its Fourier Transform, defined as
% FT(freqy,freqx) = integral over all x of ( F exp(-2*pi*i*(x*freqx+y*freqy)) ).
% This function gives you that: [FT,freqx,freqy] = jfft(x,y,F) returns the values of the
% FT evaluated at the frequencies stated, using the fast Fourier transform.
% x and y must have constant spacing and be monotonically increasing.
% F must be given in the standard matlab way, with the y-index first:
% F(jy,jx). FT is returned in the same way.
% freqx,freqy contains both negative and positive frequencies.
% To recover the existing function: first do
% >> [freqx2,freqy2] = meshgrid(freqx,freqy); dfx = min(diff(freqx)); dfy = min(diff(freqy));
% >> F(jy,fx) = dfx*dfy * sum(sum(FT.*exp(2*pi*i*x(jx)*freqx2+2*pi*i*y(jy)*freqy2)))
% (this comes out to be real)
% To use ifft2, you have to do
%  F = ifft2(shiftx(shifty(fftshift(FT.* exp(2*pi*i*x(1).* fx2 + 2*pi*i*y(1).*fy2)),sy),sx))/dx/dy;
% I have therefore written a function jifft2 so that you don't have to
% remember this!
%
% while with dx=min(diff(x)); dy=min(diff(y));
% FT(jfy,jfx) = dx*dy * sum(sum(F.*exp(-2*pi*i*x2*freqx(jfx)-2*pi*i*y2*freqy(jfy))))
[ny,nx]=size(F);
if nx==1
    dx=1;
else
    dx=min(diff(x));
end
if ny==1
    dy=1;
else
    dy=min(diff(y));
end

freqxunshift=[0:nx-1]/nx/dx;
freqxunshift(freqxunshift>=0.5/dx) = freqxunshift(freqxunshift>=0.5/dx) - 1/dx;
freqyunshift=[0:ny-1]/ny/dy;
freqyunshift(freqyunshift>=0.5/dy) = freqyunshift(freqyunshift>=0.5/dy) - 1/dy;
[freqxunshift2,freqyunshift2]=meshgrid(freqxunshift,freqyunshift);
FT = fftshift(fft2(F) .* dx*dy  .* exp(-2*pi*i*x(1).*freqxunshift2 - 2*pi*i*y(1).*freqyunshift2));
freqx = fftshift(freqxunshift);
freqy = fftshift(freqyunshift);


% Nb if you ever want frquencies going from 0 up till twice the Nyquist
% limit, use freqxunshift and freqyunshift and take out the fftshift in the
% definition of FT above


% How to invert:
% NB fftshift(freqxunshift2) = shiftx(fx2,sx)
% and fftshift(freqyunshift2) = shifty(fy2,sy)
% where sx=0 if nx is even and 1 if ny is odd, etc.
% In general, fftshift(fftshift(A)) = shiftx(shifty(A,-sy),-sx), where [ny,nx]=size(A)
% FT = fftshift(fft2(F) .* dx*dy  .* exp(-2*pi*i*x(1).*freqxunshift2 - 2*pi*i*y(1).*freqyunshift2));
% and freqxunshift2 = fftshift(shiftx(fx2,sx)); and freqyunshift2 = fftshift(shifty(fy2,sy));
% so
% FT = fftshift(fft2(F) .* dx*dy  .* exp(-2*pi*i*x(1).* fftshift(shiftx(fx2,sx)) - 2*pi*i*y(1).*fftshift(shifty(fy2,sy))));
% FT = fftshift(fft2(F) .* dx*dy  .* fftshift(exp(-2*pi*i*x(1).* shiftx(fx2,sx) - 2*pi*i*y(1).*shifty(fy2,sy))));
% FT/dx/dy = fftshift(fft2(F)  .* fftshift(exp(-2*pi*i*x(1).* shiftx(fx2,sx) - 2*pi*i*y(1).*shifty(fy2,sy))));
% FT/dx/dy = fftshift(fft2(F))  .* fftshift(fftshift(exp(-2*pi*i*x(1).* shiftx(fx2,sx) - 2*pi*i*y(1).*shifty(fy2,sy))));
% FT/dx/dy = fftshift(fft2(F))  .* exp(-2*pi*i*x(1).* fx2 - 2*pi*i*y(1).*fy2);
% FT.* exp(2*pi*i*x(1).* fx2 + 2*pi*i*y(1).*fy2)/dx/dy = fftshift(fft2(F));
% fftshift(FT.* exp(2*pi*i*x(1).* fx2 + 2*pi*i*y(1).*fy2))/dx/dy = fftshift(fftshift(fft2(F)));
% fftshift(FT.* exp(2*pi*i*x(1).* fx2 + 2*pi*i*y(1).*fy2))/dx/dy = shiftx(shifty(fft2(F),-sy),-sx);
% so finally
% F = ifft2(shiftx(shifty(fftshift(FT.* exp(2*pi*i*x(1).* fx2 + 2*pi*i*y(1).*fy2)),sy),sx))/dx/dy;




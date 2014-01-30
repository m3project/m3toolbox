function [FT,freq] = jfft(x,F);
% This is to make it easier for me to use the Matlab function fft.
% Suppose you have the function F, evaluated as a function of x, and you
% want its Fourier Transform, defined as
% FT(freq) = integral over all x of ( F exp(-2*pi*i*x*freq) ).
% This function gives you that: [FT,freq] = jfft(x,F) returns the values of the
% FT evaluated at the frequencies freq, using the fast Fourier transform.
% freq contains both negative and positive frequencies.
% To recover the existing function:
% F(jx) = min(diff(freq))*sum(FT.*exp(2*pi*i*x(jx)*freq))
% If you want to use ifft, it's a bit complicated unfortunately:
% F = real(ifft(shiftx(fftshift(FT.*exp(2*pi*i*freq*x(1))),1)))/dx;
% I've written this in jifft.m.
% while
% FT(jf) = min(diff(x))*sum(F.*exp(-2*pi*i*x*freq(jf)))
% x and f must have the same length, and constant spacing.
% x must be monotonically increasing.
n=length(F);
dx=min(diff(x));

frequnshift=[0:n-1]/n/dx;
frequnshift(frequnshift>=0.5/dx) = frequnshift(frequnshift>=0.5/dx) - 1/dx;
FT = dx.*fftshift(fft(F).*exp(-2*pi*i.*frequnshift.*x(1)));
freq = fftshift(frequnshift);

% Nb if you ever want frquencies going from 0 up till twice the Nyquist
% limit, use freq=[0:n-1]/n/Dx; and take out the fftshift in the definition
% of FT above.

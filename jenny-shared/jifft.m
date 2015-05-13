function F = jifft(freq,FT,x);
% Suppose you used my function [FT,freq] = jfft(x,F) to obtain the FT of a function F,
% and now you want to use ifft to get the original function back again.
% Then do F = jifft(freq,FT,x).
% JCAR 1st Oct 2008
F = real(ifft(ifftshift( FT.*exp(2*pi*i*freq*x(1)) ))) / min(diff(x));


% NB previously I had
% F = real(ifft(shiftx(fftshift(FT.*exp(2*pi*i*freq*x(1))),1)))/min(diff(x));
% but I now think this was wrong. -

%  F(jx) = min(diff(freq))*sum(FT.*exp(2*pi*i*x(jx)*freq))
%  This works, I've checked.
%  
%  The inverse DFT (computed by IFFT) is given by
%                      N
%        x(n) = (1/N) sum  X(k)*exp( j*2*pi*(k-1)*(n-1)/N), 1 <= n <= N.
%                     k=1
%                     
%                     This means that if y = ifft(FT)
%         then 
%         y(j) =  1/N sum  FT(k) * exp( 2*pi*i*(k-1)*(j-1)/N)
%         y(jx) = 1/N * sum( FT .* exp(2*pi*i.* [0:N-1] * (jx-1)/N))
%         
%         x = x(1) + [0:N-1]*dx;
%         x(jx) = x(1) + (jx-1)*dx;
%         
%         y(jx) = 1/N * sum( FT .* exp(2*pi*i.*[0:N-1]/N/dx * (x(jx)-x(1))))
%         
%        But, (fftshift(freq)-1/N/dx) = [0:N-1]/N/dx
%        so 
%         y(jx) = 1/N * sum( FT .* exp(2*pi*i.*(fftshift(freq)-1/N/dx) * (x(jx)-x(1))))
%         % which so happens that 
%         y(jx) = 1/N * sum( fftshift(FT) .* exp(2*pi*i.*freq * (x(jx)-x(1))))
% 
%         So, if z = ifft(ifftshift(FT))
%             then
%             z(jx) = 1/N * sum( FT .* exp(2*pi*i.*freq * (x(jx)-x(1))))
%             z(jx) = 1/N * sum( FT.*exp(-2*pi*i*freq*x(1)) .* exp(2*pi*i.*freq *x(jx)))
%             
%      If GT =  FT.*exp(-2*pi*i*freq*x(1))
%      z(jx) = 1/N * sum( GT .* exp(2*pi*i.*freq *x(jx)))
%      where
%      z =  ifft(ifftshift( GT.*exp(2*pi*i*freq*x(1)) ))
%      
%      If GT =  FT*dx.*exp(-2*pi*i*freq*x(1))
%      z(jx) = 1/N/dx * sum( GT .* exp(2*pi*i.*freq *x(jx))) = df * sum( GT .* exp(2*pi*i.*freq *x(jx)))
%      where
%      z = 1/dx * ifft(ifftshift( GT.*exp(2*pi*i*freq*x(1)) ))
%             
%             F(jx) = df*sum(FT.*exp(2*pi*i*x(jx)*freq))
%     w(jx) = df * sum( FT .* exp(2*pi*i.*freq *x(jx)))
%      where
%      F = 1/dx * ifft(ifftshift( FT.*exp(2*pi*i*freq*x(1)) ))
%             
%             
%             
%      
         
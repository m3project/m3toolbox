function pattern = gen3DPattern(expt)

% pattern dimensions

W = 512; % pixels (both horizontal and vertical)

F = 128; % frames

%% frequency parameters

fps = 60;

Fx = 0.005; % cycle/px

Sigx = 0.005; % cycle/px

Ft = 2.5; % Hz

SigT = 0.01; % Hz

if nargin>0
    
    unpackStruct(expt);
    
end

%% preparing spectrum

Ff = Ft / fps; % cycle/frame

SigF = SigT / fps;

xv = 1:W;
yv = 1:W;
fv = 1:F;

expoFunc = @(x, xc, sigma) (x-xc).^2 / (2 * sigma^2);

[x, y, f] = meshgrid(xv, yv, fv);

spec = zeros(size(x));

% spec is expressed in the output format of fftshift

for k = [-1 1]
    
    fc = k * Ff * F;
    
    expo1 = expoFunc(f-(F/2+1), fc, SigF * F);
    
    r = sqrt((x - (W/2+1)).^2 + (y - (W/2+1)).^2);
    
    rc = Fx * W;
    
    expo23 = expoFunc(r, rc, Sigx * W);
    
    spec = spec + exp(-expo1-expo23);
    
end

rnoise = rand(size(spec));

ph = fftshift(angle(fftn(rnoise)));

spec = spec .* exp(1i * ph);

s = ifftn(fftshift(spec));

pattern = real(s);

return

%% computing velocities

speed = Ft / Fx;

fprintf('Background speed = %d px/sec\n', round(speed));

% if showSpectrum
%    
%     fxt = abs(backSpec(:, H/2, :));
%     
%     fxt = permute(fxt, [3 1 2]);
%     
%     fxs = (1:W)/W - 0.5;
%     
%     fts = ((1:F)/F - 0.5) * fps;
%     
%     contour(fxs, fts, fxt);
%     
%     xlabel('fx (cpp)');
%     
%     ylabel('ft (Hz)');
%     
%     colormap(gray);
%     
%     grid on;
%     
%     drawnow
%     
% end

%% Jenny's debug code

% spec2=spec(:,:,F/2+1);
% 
% s2 = ifft2(fftshift(spec2));
% 
% max(abs(imag(s2(:))))
% 
% s2 = real(s2);
% 
% 
% figure(2);
% 
% subplot(2, 2, 1);
% imagesc(abs(spec2))
% title('|spec2| (in Matlab format)')
% subplot(2, 2, 2);
% imagesc(angle(spec2))
% title('phase(spec2) (in Matlab format)')
% subplot(2,2,3)
% imagesc(s2)
% title('s2 = IFT(spec2)')
% subplot(2,2,4)
% imagesc(abs(fftshift(fft2(s2))))
% title('|FT(s2)| should = |spec2|')
% 
% colormap(gray)
% 
% for j=1:4
%     subplot(2,2,j)
%     colorbar
%     axis  equal tight
%     xlabel('SFX')
%     ylabel('SFY')
% end
% 
% return
% 
% 
% figure(1);

%% rendering

subplot(3, 2, 1);

plot(squeeze(s(:,1,1)));

subplot(3, 2, 2);

imagesc(log10(abs(spec(:,:,floor(F/2+1)))));

hold on;

xlabel('x');

subplot(3, 2, 3);

plot(squeeze(s(1,:,1)));

xlabel('y');

subplot(3, 2, 4);

imagesc(log10(abs(fftshift(fft2(s(:, :, 1))))));

subplot(3,2,6)

imagesc(s(:, :, 1));

subplot(3, 2, 5);

plot(squeeze(abs(s(1,1,:))));

xlabel('f');

for i=[2 4 6]
   
    subplot(3, 2, i);
    
    colorbar;
    
    axis equal tight;
    
end

colormap(gray);

drawnow

s = scaleLumLevels(s, 0, 255);

expt = struct('backPattern', s);

runCamo(expt);

end
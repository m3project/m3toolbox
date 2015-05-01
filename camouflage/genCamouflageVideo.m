function s = genCamouflageVideo(expt)

W = 256;

H = 256;

F = 256;

% bacFx = 0.0;
% bugFx = 0.0;
% 
% bacFt = 0.00;
% bugFt = 0.00;
% 
% bacSigx = 0.1;
% bugSigx = 0.4;
% 
% bacSigT = 0.01;
% bugSigt = 0.05;

fps = 60;

Fx = 0.05; % cpp (cycle/px)

Sigx = 0.01; % cpp (cycle/px)

Ft = 5; % Hz

absFp = Ft / fps;

% backFx = absFx;

showSpectrum = 1;

% temp overrides

% bacFt = 0.042;
bacSigT = 0.001;

% bacFx = 0.05/10;
%bacSigx = 0.05;

% absFx = bacFx / 0.25; % cycle/px
% 
% absFt = (bacFt / 0.25) * 60; % Hz

speed = Ft / Fx;

fprintf('Background speed = %d px/sec\n', round(speed));

if nargin>0
    
    unpackStruct(expt);
    
end

% scaling relative to W and T

% bacFx = bacFx * W;

%bacSigx = bacSigx * W/2;

% bacFt = bacFt * T;

bacSigT = bacSigT * F;

% bugFx = bugFx * W;
% bugFt = bugFt * T;
% bugSigx = bugSigx * W;
% bugSigt = bugSigt * T;

xv = 1:W;
yv = 1:H;
fv = 1:F;

% anon functions

expoFunc = @(x, xc, sigma) (x-xc).^2 / (2 * sigma^2);

plotSpectrums = 0;

[x, y, f] = meshgrid(xv, yv, fv);

backSpec = zeros(size(x));

for k2 = [-1 1]
    
    for k = [-1 1]
        
        fc = k2 * absFp * F;
        
        %temp1 = expoFunc(fv - F/2, fc, bacSigT);        
        %plot((fv - F/2)/F, exp(-temp1)); return
        
        expo1 = expoFunc(f - F/2, fc, bacSigT);
        
        r = sqrt((x - W/2).^2 + (y - H/2).^2);
        
        rc = k * Fx * W;
        
        expo23 = expoFunc(r, rc, Sigx * W);
        
        backSpec = backSpec + exp(-expo1-expo23);
        
    end
    
end

if showSpectrum
   
    fxt = abs(backSpec(:, H/2, :));
    
    fxt = permute(fxt, [3 1 2]);
    
    fxs = (1:W)/W - 0.5;
    
    fts = ((1:F)/F - 0.5) * fps;
    
    contour(fxs, fts, fxt);
    
    xlabel('fx (cpp)');
    
    ylabel('ft (Hz)');
    
    colormap(gray);
    
    grid on;
    
    drawnow
    
end

% for k = [-1 1]
%     
%     tc = xcFunc(T, k, bugFt);
%     
%     expo1 = expoFunc(t, tc, bugSigt);
%     
%     r = sqrt((x - W/2).^2 + (y - H/2).^2);
%     
%     rc = bugFx;    
%     
%     sigr = bugSigx;
%     
%     expo23 = expoFunc(r, rc, sigr);
%     
%     backSpec2 = exp(-expo1-expo23);
%    
% end

if plotSpectrums
    
    % plots
    
    figure(gcf);   
    
    subplot(3, 1, 1);
    
    plot(xv-W/2, backSpec(:, H/2, F/2));
    
    xlim([-1 1]*W/2); xlabel('x'); grid on;
    
    subplot(3, 1, 2);
    
    plot(yv-H/2, backSpec(W/2, :, F/2));
    
    xlim([-1 1]*H/2); xlabel('y'); grid on;
    
    subplot(3, 1, 3);
    
    plot(fv-F/2, squeeze(backSpec(W/2, H/2, :)));
    
    xlim([-1 1]*F/2); xlabel('t'); grid on;
    
    drawnow
    
end

return

backSpec = backSpec .* exp(1i * rand(size(backSpec))*2*pi);

addBug = 0;

if addBug
    
    bug = createBug(W, H, F, dir);
    
    bugSpec = fftn(bug) .* abs(backSpec2);
    
    bugEnergy = sum(abs(bugSpec(:)).^2);
    
    backEnergy = sum(abs(backSpec(:)).^2);
    
    backSpec = backSpec + bugSpec * backEnergy/ bugEnergy * bugScalingFactor;
    
end

s = ifftn(fftshift(backSpec));

bugTexture = abs(s(1:100,1:30,1));

bugTexture = bugTexture / max(abs(s(:)));

expt = struct('bugTexture', bugTexture);

plot(permute(abs(s(1,1,:)), [3 2 1]))

xlim([1 60]);

return;

runCamo(s, expt);

end
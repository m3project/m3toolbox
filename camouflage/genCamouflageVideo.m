function s = genCamouflageVideo(expt)

W = 512;

H = 512;

T = 256;

dir = 1;

bugScalingFactor = 1;

bacFx = 0.0;
bugFx = 0.0;

bacFt = 0.00;
bugFt = 0.00;

bacSigx = 0.1;
bugSigx = 0.4;

bacSigT = 0.01;
bugSigt = 0.05;

if nargin>0
    
    unpackStruct(expt);
    
end

% scaling relative to W and T

bacFx = bacFx * W;
bugFx = bugFx * W;

bacFt = bacFt * T;
bugFt = bugFt * T;

bacSigx = bacSigx * W;
bugSigx = bugSigx * W;

bacSigT = bacSigT * T;
bugSigt = bugSigt * T;




xv = 1:W;
yv = 1:H;
tv = 1:T;

% anon functions

expoFunc = @(x, xc, sigma) (x-xc).^2 / (2 * sigma^2);

xcFunc = @(W, i, fx) W/2 + i * fx;

%xExp1 = @(W, i, fx, xv, sigx) exp(-expoFunc(xv, xcFunc(W, i, fx), sigx));

plotSpectrums = 0;

[x, y, t] = meshgrid(xv, yv, tv);

for k = [-1 1]
    
    tc = xcFunc(T, k, bacFt);
    
    expo1 = expoFunc(t, tc, bacSigT);
    
    r = sqrt((x - W/2).^2 + (y - H/2).^2);
    
    rc = bacFx;    
    
    sigr = bacSigx;
    
    expo23 = expoFunc(r, rc, sigr);
    
    backSpec = exp(-expo1-expo23);
   
end

for k = [-1 1]
    
    tc = xcFunc(T, k, bugFt);
    
    expo1 = expoFunc(t, tc, bugSigt);
    
    r = sqrt((x - W/2).^2 + (y - H/2).^2);
    
    rc = bugFx;    
    
    sigr = bugSigx;
    
    expo23 = expoFunc(r, rc, sigr);
    
    backSpec2 = exp(-expo1-expo23);
   
end

if plotSpectrums
    
    % plots
    
    figure(gcf);   
    
    subplot(3, 1, 1);
    
    plot(xv-W/2, backSpec(:, H/2, T/2));
    
    xlim([-1 1]*W/2); xlabel('x'); grid on;
    
    subplot(3, 1, 2);
    
    plot(yv-H/2, backSpec(W/2, :, T/2));
    
    xlim([-1 1]*H/2); xlabel('y'); grid on;
    
    subplot(3, 1, 3);
    
    plot(tv-T/2, squeeze(backSpec(W/2, H/2, :)));
    
    xlim([-1 1]*T/2); xlabel('t'); grid on;
    
    drawnow
    
end

backSpec = backSpec .* exp(1i * rand(size(backSpec))*2*pi);

addBug = 0;

if addBug
    
    bug = createBug(W, H, T, dir);
    
    bugSpec = fftn(bug) .* abs(backSpec2);
    
    bugEnergy = sum(abs(bugSpec(:)).^2);
    
    backEnergy = sum(abs(backSpec(:)).^2);
    
    backSpec = backSpec + bugSpec * backEnergy/ bugEnergy * bugScalingFactor;
    
end

s = ifftn(fftshift(backSpec));

end
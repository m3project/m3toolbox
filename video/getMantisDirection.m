function [direction, potentialMiss] = getMantisDirection(videoFile)

makePlot = 0;

if nargin < 1
    
    home
    
    videoFile = 'V:\readlab\Ghaith\m3\data\mantisVideoCapture\F10 28-04-2014 15.17 (3) (GHAITH)\trial1.mp4';
    
    makePlot = 1;
    
end

if ~exist(videoFile, 'file') 
    
    direction = nan;
    
    potentialMiss = nan;
    
    return;
    
end

reader = VideoReader(videoFile);

video = read(reader, [1 Inf]);

%video = temporalfilter(video);

h = size(video, 1);
w = size(video, 2);

regx = 1:w;

regy = 100:350;

frames = size(video, 4);

d = ones(frames, 1) * nan;

m = ones(frames, 1) * nan;

for i = 1:frames
    
    img = video(regy, regx, 2, i);
    
    level = 0.85;
    
    img = im2bw(img, level);
    
    [~, x] = find(img);
    
    d(i) = mean(x) / h;
    
    if makePlot
        
        subplot(2, 1, 1);
        
        imshow(img);
        
        subplot(2, 1, 2); cla
        
        plot(1:frames, d - d(1));
        
        axis([1 frames -0.1 0.1]);
        
        xlabel('Frame');
        
        ylabel('Centre of Mass (units)');
        
        grid on;
        
        drawnow
        
    end
    
end

k = find(~isnan(d), 1);

if isempty(k)
    k=1;
end

p = polyfit(k:frames, d(k:end)', 1);

m = p(1);

direction = -1;

if m>0
    
    direction = 1;
    
end

potentialMiss = 0; % default

nd = (d - d(1));

[amp, ~, fitError] = fitExponentialDecay(1:frames, nd', makePlot);

direction = -1;

if amp>0
    
    direction = 1;
    
end

if abs(amp)>0.2 || abs(amp)<0.02 || fitError > 5e-2
    
    potentialMiss = 1;
    
end

if makePlot
   
    str = 'Left';
    
    if direction==1
        
        str = 'Right';
        
    end
    
    if potentialMiss
        
        str = sprintf('%s (Potential Misclassification)', str);
        
    end
    
    subplot(2, 1, 1); title(str);
    
end

end

function [amp, tau, fitError] = fitExponentialDecay(x, y, makePlot)

fitFunc = @(X, x) X(1)*(1-exp(-x/X(2)));

rmsError = @(z,w) sum((z-w).^2);

costFunc = @(X) rmsError(fitFunc(X, x), y);

options = optimset('Display', 'off');

sol = fminsearch(costFunc, [1 1], options);

amp = sol(1);

tau = sol(2);

fitError = costFunc(sol);

if makePlot

    hold on; plot(x, fitFunc(sol, x), '--r'); hold off;

    title(sprintf('Tau = %1.2e, Error = %1.2e', tau, fitError));
    
end

end

function video = temporalfilter(video)

% this function applies a temporal filter to the video

duration = 5; % seconds

[~, ~, ~, frames] = size(video);

fps = frames/duration; % fps = temporal sampling frequency

cutoff_hz = 1;

Wn = cutoff_hz / fps; % normalized cutoff frequency

[B, A] = butter(1, Wn); % first order Butterworth filter

video = filter(B, A, double(video)/255, [], 4);

end
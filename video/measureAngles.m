function measureAngle(outputFile)

if nargin<1
    
    outputFile = 'results2.mat';
    
end

dir = pwd;

paramsFile = fullfile(dir, 'params.mat');

resultsFile = fullfile(dir, 'results.mat');

resultsFile2 = fullfile(dir, outputFile);

if ~exist(paramsFile, 'file') || ~exist(resultsFile, 'file')
    
    error(['Could not locate params and results files ' ...
        '(are you sure you are in an experiment results folder?)']);
    
end

load(paramsFile);

load(resultsFile);

n = size(paramSet, 1);

% make sure all video files are present before starting

for i=1:n
    
    vfile = sprintf('trial%i.mp4', i);
    
    vpath = fullfile(dir, vfile);
    
    if ~exist(vpath, 'file')
        
        %msg = ['could not locate file ' vfile];
        
        %error(msg);
        
        warning('this experiment is incomplete.')
        
    end
    
end

resultSet2 = nan(n, 3);

for i=1:n
    
    vfile = sprintf('trial%i.mp4', i);
    
    vpath = fullfile(dir, vfile);
    
    if ~exist(vpath, 'file')
        
        warning('Could not locate file %s, skipping ...', vfile);
        
        continue;
        
    end
    
    clc;
    
    fprintf('Processing file %s (%d out of %d) ...\n\n', vfile, i, n);
    
    figTitle = sprintf('Trial %d of %d', i, n);
    
    angles = getAllAngles(vpath, figTitle);
    
    fprintf('Enter parameters (or hit enter to replay video) ...\n\n');
    
    resultSet2(i, :) = angles;
    
    save(resultsFile2, 'resultSet2');
    
end

end


function angles = getAllAngles(file, figTitle)

xyloObj = VideoReader(file);

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);


img = read(xyloObj, [1 nFrames]);

KbName('UnifyKeyNames'); 

old_k = -1 ;

k = 1;

clf;

angle_selector = 1;

angles = nan(3, 1);

angle_names = {'Computer Frame', 'Initial Head', 'Saccade'};

h = imshow(img(:, :, :, k));

ht1 = text(10,20, sprintf('Angle 1 (Computer Frame) = %1.0f', angles(1)));
ht2 = text(10,40, sprintf('Angle 2 (Initial Head Angle) = %1.0f', angles(2)));
ht3 = text(10,60, sprintf('Angle 3 (Saccade Angle) = %1.0f', angles(3)));

set(gcf, 'Name', figTitle);

while (1)
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('RightArrow')))
        
        k  = min(k+1, nFrames);
        
    end
    
    if (keyCode(KbName('LeftArrow')))
        
        k  = max(k-1, 1);
        
    end
    
    if (keyCode(KbName('Space')))
        
        angles(angle_selector) = getAngle();
        
        old_k = -1;
        
     end
    
    if (keyCode('1'))
        
        angle_selector = 1;
        
        old_k = -1;
        
    end
    
    if (keyCode('2'))
        
        angle_selector = 2;
        
        old_k = -1;
        
    end
    
    if (keyCode('3'))
        
        angle_selector = 3;
        
        old_k = -1;
        
    end
    
    if ~(k==old_k)
        
        set(h, 'CData', img(:, :, :, k));
        
        title(sprintf('Frame = %i/%i, selected angle = %d (%s)', k, nFrames, angle_selector, angle_names{angle_selector}));
        
        set(ht1, 'String', sprintf('Angle 1 (Computer Frame) = %1.0f', angles(1)));
        set(ht2, 'String', sprintf('Angle 2 (Initial Head Angle) = %1.0f', angles(2)));
        set(ht3, 'String', sprintf('Angle 3 (Saccade Angle) = %1.0f', angles(3)));
        
        drawnow
        
        pause(0.025);
        
        old_k = k;
        
    end
    
    if (keyCode(KbName('Return')))
        
        return
        
    end
    
end

end

function angle = getAngle()

hold on;

p1 = ginput(1);

plot(p1(1), p1(2), 'rx', 'MarkerSize', 10);

p2 = ginput(1);

plot(p2(1), p2(2), 'rx', 'MarkerSize',  10);

x = [p1(1) p2(1)];

y = [p1(2) p2(2)];

plot(x, y);

fit = polyfit(x, y, 1); 

angle = atand(fit(1));

end
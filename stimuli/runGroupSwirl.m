function exitCode = runGroupSwirl()

bugColor = 0;

bugY = 0.62;

n = 20; % number of dots

iod = 0.7 ; % mantis inter-ocular distance (cm)

viewD = 10; % viewing distance (cm)

bugSize = 1; % bug size (cm) as perceived by the mantis

bugD = 2.5; % distance between mantis and virtual bug

sf = 37.0370; % screen scaling factor (px/cm) for Dell U2413

%% size calculations

bugScreenSize = bugSize / bugD * viewD; % cm

diameter = bugScreenSize * sf;

%% disparity calculations

disparity_mag = iod * (viewD/bugD - 1) * sf;

%% Initialization

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[sW, sH] = getResolution();

%% motion profile

fps = 60;

motionDuration = 2;

motionR0 = 500;

[X, Y] = getSwirl(fps, motionDuration, motionR0);

% set last position as inf so that dots at X(end), Y(end)
% are effectively hidden

X(end) = inf;
Y(end) = inf;

totalFrames = motionDuration * fps;

is = randi(totalFrames, [n 1]); % frame indexes

%% rendering

startTime = GetSecs();

oldKeyIsDown = 1;

centerX = rand(n, 1) * sW;

centerY = rand(n, 1) * sH;

isTarget = zeros(n, 1);

isTarget(1) = 1;

centerX(1) = sW/2;

centerY(1) = sH * bugY;

disparity = disparity_mag;

is(1) = totalFrames;

includeTargetDot = 1;

while (1)
    
    if includeTargetDot && is(1) == totalFrames
        
        includeTargetDot = 0;
        
    end
    
    k = 2 - includeTargetDot;
    
    is(k:end) = mod(is(k:end), totalFrames) + 1;
    
    t = GetSecs() - startTime;
    
    dotX = centerX + X(is);
    
    dotY = centerY + Y(is);
    
    %% channel 0
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    dotPos = [dotX-disparity/2.*isTarget dotY];
    
    dotRect = [dotPos-diameter/2 dotPos+diameter/2];
    
    Screen('FillOval', window, bugColor, dotRect');
    
    %% channel 1
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    dotPos = [dotX+disparity/2.*isTarget dotY];
    
    dotRect = [dotPos-diameter/2 dotPos+diameter/2];
    
    Screen('FillOval', window, bugColor, dotRect');
    
    Screen('Flip', window);
    
    %% processing keyboard shortcuts
    
    [keyIsDown, ~, keyCode] = KbCheck;
    
    if keyIsDown && ~oldKeyIsDown
        
        if keyCode(KbName('p'))
            
            disparity = disparity_mag;
            
        end
        
        if keyCode(KbName('n'))
            
            disparity = -disparity_mag;
            
        end
        
         if keyCode(KbName('Space'))
            
            includeTargetDot = 1;
            
            is(1) = 1;
            
        end
        
        if keyCode('0')
            
            disparity = 0;
            
        end
        
        if keyCode(KbName('Escape'))
            
            exitCode = 0;
            
            break;
            
        end
        
    end
    
    oldKeyIsDown = keyIsDown;
    
end

end

function [X, Y] = getSwirl(fps, motionDuration, motionR0)

theta1 = @(t) (t * 2 * pi * 4);

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

v = 0.5;

td = 1/fps;

t = transp(td : td : motionDuration);

X = cos(theta1(t) * v) .* motionR(t);
Y = sin(theta1(t) * v) .* motionR(t);

end

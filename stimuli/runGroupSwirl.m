function [is, centerX, centerY]  = runGroupSwirl(expt, is, centerX, centerY)

bugColor = 0;

bugY = 0.62;

n = 10; % number of dots

iod = 0.7 ; % mantis inter-ocular distance (cm)

viewD = 5; % viewing distance (cm)

bugSize = 1; % bug size (cm) as perceived by the mantis

bugD = 2.5; % distance between mantis and virtual bug

sf = 37.0370; % screen scaling factor (px/cm) for Dell U2413

disparityEnable = 1; % -1 ,0 or +1

duration = 7; % secs (-1 to disable)

moveOnStart = 1; % start bug motion on stimulus onset

bugJitter = 5; % px

%% parameter overloads

if nargin>0
    
    unpackStruct(expt);
    
end

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

motionDuration = 5;

finalPresentationTime = 2;

rotFreq = 4; % Hz

motionR0 = 800;


%[X, Y] = getSwirl(fps, motionDuration, motionR0);
[X, Y] = getSwirl2([], [], motionDuration, motionR0, rotFreq, fps, finalPresentationTime);

% set last position as inf so that dots at X(end), Y(end)
% are effectively hidden

X(end) = inf;
Y(end) = inf;

totalFrames = (motionDuration + finalPresentationTime) * fps;

if nargin < 4

    is = randi(totalFrames, [n 1]); % frame indexes
    
    centerX = rand(n, 1) * sW;

    centerY = rand(n, 1) * sH;

end

%% rendering

oldKeyIsDown = 1;

isTarget = zeros(n, 1);

isTarget(1) = 1;

centerX(1) = sW/2;

centerY(1) = sH * bugY;

is(1) = totalFrames;

includeTargetDot = 1;

if moveOnStart == 1
    
    is(1) = 1;
    
end

startTime = GetSecs();

while (1)
    
    t = GetSecs() - startTime;
    
    if duration ~= -1 && t>duration
        
        Screen('Flip', window);
        break;
        
    end        
    
    if includeTargetDot && is(1) == totalFrames
        
        includeTargetDot = 0;
        
    end
    
    k = 2 - includeTargetDot;
    
    is(k:end) = mod(is(k:end), totalFrames) + 1;
    
    t = GetSecs() - startTime;
    
    dotX = centerX + X(is);
    
    dotY = centerY + Y(is);
    
    disparity = disparityEnable * disparity_mag;
    
    %% calculate jitter
    
    jt = rand(n, 2) * bugJitter;
    
    %% channel 0
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    dotPos = [dotX-disparity/2.*isTarget dotY] + jt;
    
    dotRect = [dotPos-diameter/2 dotPos+diameter/2];
    
    Screen('FillOval', window, bugColor, dotRect');
    
    %% channel 1
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    dotPos = [dotX+disparity/2.*isTarget dotY] + jt;
    
    dotRect = [dotPos-diameter/2 dotPos+diameter/2];
    
    Screen('FillOval', window, bugColor, dotRect');
    
    Screen('Flip', window);
    
    %% processing keyboard shortcuts
    
    [keyIsDown, ~, keyCode] = KbCheck;
    
    if keyIsDown && ~oldKeyIsDown
        
        if keyCode(KbName('p'))
            
            disparityEnable = 1;
            
        end
        
        if keyCode(KbName('n'))
            
            disparityEnable = -1;
            
        end
        
         if keyCode(KbName('Space'))
            
            includeTargetDot = 1;
            
            is(1) = 1;
            
        end
        
        if keyCode('0')
            
            disparityEnable = 0;
            
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

function [X, Y] = getSwirl2(~, ~, motionDuration, motionR0, rotFreq, fps, finalPresentationTime)

[xfunc, yfunc] = getSwirl_runDotsAnaglyph(0, 0, motionDuration, motionR0, rotFreq);

td = 1/fps;

totalTime = motionDuration + finalPresentationTime;

t = transp(td : td : totalTime);

X = xfunc(t);
Y = yfunc(t);

end

function [X, Y] = getSwirl_runDotsAnaglyph(centerX, centerY, motionDuration, motionR0, rotFreq)

% this function was copied from getSwirl() in the script runDotsAnaglyph

theta1 = @(t) t * 2 * pi * rotFreq;

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

v = .5 ;

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t);
Y = @(t) centerY + sin(theta1(t) * v) .* motionR(t);

end


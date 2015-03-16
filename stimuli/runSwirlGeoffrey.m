function exitCode = runSwirlGeoffrey(expt)

logEvent = @(str) str; % dummy function

logEvent('runSwirlAnaglyph');

%% Initialization

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[sW, sH] = getResolution();

%% Stimulus Settings

% parameters particularly relevant to Ronny:

motionR0 = 300; % initial motion radius (pixels) (800px in behavioral expt)

motionDuration = 5; % duration of swirling (seconds) (5 secs in behavioral expt)

totalTime = 7; % duration of bug visibility(seconds) (7 secs in behavioral expt)

bugSizePx = 40;

cx = 970; % center in x coords (px) (screen center in behavioral expt)

% other parameters:

bugColor = 0; % [0, 1]

bugY = 0.62; % vertical location of bug (0 to 1)

bugJitter = 5; % bug jitter in pixels (0 to disable)

enableChannels = 0; % 0 = both, -1=only left, +1=only right

%% functions:

% disparity:

disparity = @(t, disparityEnable) 10;

% position:

[swirlX, swirlY, ~] = getSwirl(cx, sH * bugY, motionDuration, motionR0);

%% load overrides

if nargin > 0
    
    unpackStruct(expt);
    
end

%% rendering loop:

alignMsgDisplayed = 0;

startTime = GetSecs() ; % - totalTime * 2;

while 1
    
    t = GetSecs() - startTime;
    
    dotsL = [swirlX(t) swirlY(t)];
    
    dotsR = [swirlX(t) swirlY(t)];
    
    dotsL(1) = dotsL(1) - disparity(t)/2;
    
    dotsR(1) = dotsR(1) + disparity(t)/2;
    
    if t>totalTime && ~alignMsgDisplayed
        
        alignMsgDisplayed = 1;
        
    end
    
    jt =  rand(1, 2) * bugJitter;
    
    bugHeight = bugSizePx;
    
    dotsL = dotsL - [bugHeight/2 bugHeight] + jt;
    dotsR = dotsR - [bugHeight/2 bugHeight] + jt;
    
    rectL = [dotsL; dotsL(1)+bugHeight dotsL(2)+bugHeight];
    
    rectR = [dotsR; dotsR(1)+bugHeight dotsR(2)+bugHeight];
    
    Screen('Flip', window);
    
    if t>totalTime
        
        break;
        
    end    
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    if ismember(enableChannels, [0 +1])
        
        if t<totalTime
            
            Screen('FillOval', window, bugColor, rectL');
            
        end
        
    end
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    if ismember(enableChannels, [0 -1])
        
        if t<totalTime
            
            Screen('FillOval', window, bugColor, rectR');
            
        end
        
    end
    
end

Screen('Flip', window);

exitCode = 0;

end

function [X, Y, motionR] = getSwirl(centerX, centerY, motionDuration, motionR0)

theta1 = @(t) (t * 2 * pi * 4);

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

v = 0.5;

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t);
Y = @(t) centerY + sin(theta1(t) * v) .* motionR(t);

end


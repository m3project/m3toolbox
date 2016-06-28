function exitCode = runLoomAnaglyphStatic(varargin)

% Initialization

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[sW, sH] = getResolution();

HideCursor; f1 = @() ShowCursor; obj2 = onCleanup(f1);

%% Stimulus Settings

twait = 3; % seconds

duration = 1.0; % duration of motion from distance 1 to 2 (seconds)

viewD = 10;% viewing distance (cm)

bugSize = 2; % bug size (cm) as perceived by the mantis at virtDm2 position

lenseSelect = -1; % 1 for green lens on the left; -1 for green lens on the right
         
bugColor = [0 0 0]; % [0, 1]

iod = 0.7; % mantis inter-ocular distance (cm)

sf = 37.0370; % screen scaling factor (px/cm)

virtDm1 = 5.0; % virtual distance 1 from mantis (cm)

virtDm2 = 2.5; % virtual distance 2 from mantis (cm)

virtBS2 = viewD / virtDm2 * bugSize;

virtBS1= virtBS2 * virtDm2 / viewD;

bugY = 0.5; % vertical location of bug (0 to 1)

bugJitter = 0; % bug jitter in pixels (0 to disable)

enableLoomDisparity = 1;

%% functions:

ta = @(t) min(t, duration) / duration; % animation time [0, 1]

virtDm = @(t) virtDm1 + (virtDm2-virtDm1) * ta(t);

% disparity:

disparity = @(t) lenseSelect * iod * (viewD - virtDm(t)) ./ virtDm(t) * sf;

% size:
    
virtBugSize = @(t) virtBS1 .* viewD./ virtDm(t) ;

% radius:

radFunc = @(t) virtBugSize(t) * sf;

% position:

cx = sW/2;

cy = sH * bugY;

%% rendering loop:
% ts=linspace(0, 10, 1e3); plot(ts, timeFunc(ts, duration, twait)); return
fbox = createFlickerBox(150,55);

startTime = GetSecs() - 1e3;

while 1
    
    t = GetSecs() - startTime();
    
    if t>2*duration+twait
        
        flickLum = 0;
        
    elseif t>duration+twait
        
        flickLum = 0.05;
        
    elseif t>duration
        
        flickLum = 0.16;
        
    else
        
        flickLum = 0.5;
        
    end
        
    t = timeFunc(t, duration, twait);
    
    fbox.pattern = [0 1] * flickLum;

    r = radFunc(0);

    dotsL = [cx cy+r/2];
    dotsR = [cx cy+r/2];
    
    dotsL(1) = dotsL(1) - enableLoomDisparity * disparity(t)/2;
    dotsR(1) = dotsR(1) + enableLoomDisparity * disparity(t)/2;
    
    jt =  rand(1, 2) * bugJitter;
    
    bugHeight = r;
    
    dotsL = dotsL - [r/2 bugHeight] + jt;
    dotsR = dotsR - [r/2 bugHeight] + jt;
    
    rectL = [dotsL; dotsL(1)+r dotsL(2)+bugHeight];
    
    rectR = [dotsR; dotsR(1)+r dotsR(2)+bugHeight];
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('FillOval', window, bugColor(2), rectL');
    
    drawFlickerBox(window, fbox);
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('FillOval', window, bugColor(3), rectR');
    
    fbox = drawFlickerBox(window, fbox);
    
    Screen('Flip', window);
    
    [pressed, ~, keyCode] = KbCheck;
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode
        
        return
        
    end
    
    if pressed
        
        if keyCode(KbName('Space'))
            
            startTime = GetSecs(); % restarts animation
            
        end
        
    end
    
end

end

function t4 = timeFunc(t, duration, twait)

T = duration + twait/2;

t2 = T - abs(t - T);

t3 = max(t2, 0);

t4 = min(t3, duration);

end
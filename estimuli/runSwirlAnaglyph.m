function exitCode = runSwirlAnaglyph(logEvent)

if nargin<1
    
    logEvent = @(str) str; % dummy function
    
end

logEvent('runSwirlAnaglyph');

%% flicker brightness levels

flickerCols = [0.01 0.03;0.05 0.12; 0.01 0.06]; % -, 0 and + disparity (avoid using 0 since black is the non-flickering color)

flickerColsB = [0.5 1];
    
flickerColsG = [0.25 0.35];

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

disparityEnable = 1; % disparity setting (-1, 0 or +1)

previewMotionFunc = 0; % set to 1 to see a figure of the swirl function versus time

cx = 970; % center in x coords (px) (screen center in behavioral expt)

cy = 650; % center in y coords (px) (screen center in behavioral expt)

iod = 0.8; % 0.5 mantis inter-ocular distance (cm)

viewD = 10; % viewing distance (distance between mantis and monitor) (cm)

virtDm = 2.5; % distance between mantis and bug (virtual) (cm)

% other parameters:

virtDm1 = virtDm;

virtDm2 = virtDm;

makePlot = 0; % when set to 1, the script plots size and trajectory instead of rendering the stimulus

sizeScaleEnable = 1;

disparitySizeCondition = 0; % when set to 1, the bug size in the case of (disparityEnable=1, sizeEnable=0) is initially small

bugColor = 0; % [0, 1]

sf = 37; % screen scaling factor (px/cm)

bugSize = 0.5; % bug size (cm) as perceived by the mantis at virtDm2 position

virtBS2 = viewD / virtDm2 * bugSize;

virtBS1= virtBS2 * virtDm2 / viewD;

duration = 2.25; % duration of motion from distance 1 to 2 (seconds)

bugY = 0.62; % vertical location of bug (0 to 1)

bugJitter = 5; % bug jitter in pixels (0 to disable)

finalPresentationTime = 2; % time stimulus remains on screen after looming (seconds)

enableLoomDisparity = 1;

enableChannels = 0; % 0 = both, -1=only left, +1=only right

%% print keyboard shortcuts

shortcuts = {
    'p',                        'Set disparity to positive', ... 
    'n',                        'Set disparity to negative', ... 
    '0',                        'Set disparity to zero', ... 
    'b',                        'enable blue channel only', ... 
    'g',                        'enable green channel only', ... 
    'k',                        'enable both channels', ...     
    'Space or s',               'Start bug motion', ...
    'Escape or End',            'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% functions:

ta = @(t) min(t, duration) / duration; % animation time [0, 1]

virtDm = @(t) virtDm1 + (virtDm2-virtDm1) * ta(t);

% disparity:

disparity = @(t, disparityEnable) disparityEnable * iod * (viewD - virtDm(t)) ./ virtDm(t) * sf;

% size:

if sizeScaleEnable
    
    virtBugSize = @(t) virtBS1 .* viewD./ virtDm(t) ;
    
else
    
    if disparitySizeCondition
        
        virtBugSize = @(t) virtBS1 * ones(size(t)); % .* viewD./ virtDm2 ;
        
    else
        virtBugSize = @(t) virtBS1 .* viewD./ virtDm2 * ones(size(t)) ;
        
    end
    
end

% radius:

radFunc = @(t) virtBugSize(t) * sf;

% position:

x1 = @(t, disparityEnable) cx - disparity(t, disparityEnable)/2;

x2 = @(t, disparityEnable) cx + disparity(t, disparityEnable)/2;

y1 = @(t) cy;

y2 = @(t) cy;

[swirlX, swirlY, motionR] = getSwirl(cx, cy, motionDuration, motionR0);

if previewMotionFunc
    
    t = 0:1e-2:10; plot(t, [motionR(t); (t<motionDuration)*motionR0/2]);
    
    xlabel('time');
    
    legend('Swirl Radius', 'Flicker Enable');
    
    return

end

swirlActive = 1;

%% flicker box

flickSize = 50;

flickerRect = [0 sH-flickSize flickSize sH];

flicker = 0;

%% make plots

if makePlot
    
    t = 0:0.01:duration*1.5;
    
    subplot(2, 1, 1);
    
    plot(t, virtBugSize(t)); xlabel('Time'); ylabel('Virtual Bug Size (cm)');
    
    subplot(2, 1, 2);
    
    plot(t, disparity(t)); xlabel('Time'); ylabel('Disparity (cm)');
    
    return

end
%% rendering loop:

alignMsgDisplayed = 0;

startTime = GetSecs() - totalTime * 2;

frameTimes = nan(500, 1);

frameCounter = 1;  

oldKeyIsDown = 1;

while 1
    
    frameStart = GetSecs();
    
    t = GetSecs() - startTime;
    
    if swirlActive
        
        r = radFunc(0);
        
        dotsL = [swirlX(t) swirlY(t)];
        
        dotsR = [swirlX(t) swirlY(t)];
        
        dotsL(1) = dotsL(1) - enableLoomDisparity * disparity(t, disparityEnable)/2;
        
        dotsR(1) = dotsR(1) + enableLoomDisparity * disparity(t, disparityEnable)/2;
        
        if t>totalTime && ~alignMsgDisplayed
            
            %fprintf('\nPress escape to end alignment stimulus ...\n\n');
            
            alignMsgDisplayed = 1;
            
        end
        
        if t>totalTime
            
%             break;
            
        end
        
    else
        
        r = radFunc(t);
        
        dotsL = [x1(t, disparityEnable) y1(t)];
        
        dotsR = [x2(t, disparityEnable) y2(t)];
        
        if t>duration + finalPresentationTime
            
            break;
            
        end
        
    end
    
    jt =  rand(1, 2) * bugJitter;  
    
    bugHeight = r;
    
    dotsL = dotsL - [r/2 bugHeight] + jt;
    dotsR = dotsR - [r/2 bugHeight] + jt;
    
    rectL = [dotsL; dotsL(1)+r dotsL(2)+bugHeight];
    
    rectR = [dotsR; dotsR(1)+r dotsR(2)+bugHeight];
    
    flickerEna = t<totalTime;
    
    if flickerEna
        
        flicker = 1 - flicker;
        
    end
    
    if enableChannels == 0
        
        flickerCol = flickerCols(disparityEnable+2, flicker+1);
        
    elseif enableChannels == 1
        
        flickerCol = flickerColsB(flicker+1);
        
    elseif enableChannels == -1
        
        flickerCol = flickerColsG(flicker+1);
        
    end
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    if ismember(enableChannels, [0 +1])
        
        if t<totalTime
            
            Screen('FillOval', window, bugColor, rectL');
            
        end
        
    end
    
    Screen('FillRect', window, [1 1 1] * flickerEna * flickerCol, flickerRect);
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    if ismember(enableChannels, [0 -1])        
        
        if t<totalTime
            
            Screen('FillOval', window, bugColor, rectR');
            
        end
        
    end
    
    Screen('FillRect', window, [1 1 1] * flickerEna * flickerCol, flickerRect);
    
    Screen('Flip', window);
    
    [keyIsDown, ~, keycode] = KbCheck;
    
    if keyIsDown && ~oldKeyIsDown
        
        if keycode(KbName('p'))
            
            disparityEnable = +1;
            
            logEvent('set disparity to positive');
            
        end
        
        if keycode(KbName('n'))
            
            disparityEnable = -1;
            
            logEvent('set disparity to negative');
            
        end
        
        if keycode('0')
            
            disparityEnable = 0;
            
            logEvent('set disparity to 0');
            
        end
        
        if keycode(KbName('k'))
            
            enableChannels = 0;
            
            logEvent('enabled both channels');
            
        end
        
        if keycode(KbName('b'))
            
            enableChannels = +1;
            
            logEvent('enabled blue channel only');
            
        end
        
        if keycode(KbName('g'))
            
            enableChannels = -1;
            
            logEvent('enabled green channel only');
            
        end
        
        if keycode(KbName('Space')) || keycode(KbName('s'))
            
            startTime = GetSecs();
            
            logEvent('started swirl');
            
        end
        
        if keycode(KbName('Escape'))
            
            exitCode = 0;
            
            break;
            
        end
        
        if keycode(KbName('END'))
            
            exitCode = 1;
            
            break;
            
        end
        
    end
    
    oldKeyIsDown = keyIsDown;
    
    frameEnd = GetSecs();

    frameDuration = frameEnd - frameStart;

    frameTimes(frameCounter) = frameDuration;

    frameCounter = mod(frameCounter, 500)+1   ;
    
end
   
%hist(frameTimes);

ft = frameTimes(~isnan(frameTimes));

if any(ft-mean(ft)>1e-3)
    
    warning('Dropped frames detected!')
    
end

closeWindow();

end

function [X, Y, motionR] = getSwirl(centerX, centerY, motionDuration, motionR0)

theta1 = @(t) (t * 2 * pi * 4);

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

v = 0.5;

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t);
Y = @(t) centerY + sin(theta1(t) * v) .* motionR(t);

end


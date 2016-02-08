function exitCode = runSwirlAnaglyph(~, keyPress)

if nargin<2
    
    keyPress = @(keyCode) 1; % dummy function
    
end

sobj = initSerial();

ss = @(str) sendSerial(sobj, str);

%% flicker brightness levels

flickerCols = [0.01 0.03;0.05 0.12; 0.01 0.06]; % -, 0 and + disparity (avoid using 0 since black is the non-flickering color)

flickerDutyCycles = [0.25 0.5 0.75];

flickerPeriod = 10;

cyclingModeDelay = 8; % delay between presentations in cycling mode (sec)

%% Initialization

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[~, sH] = getResolution();

%% Stimulus Settings

% parameters particularly relevant to Ronny:

motionR0 = 300; % initial motion radius (pixels) (800px in behavioral expt)

motionDuration = 5; % duration of swirling (seconds) (5 secs in behavioral expt)

totalTime = 7; % duration of bug visibility(seconds) (7 secs in behavioral expt)

disparityEnable = 1; % disparity setting (-1, 0 or +1)

previewMotionFunc = 0; % set to 1 to see a figure of the swirl function versus time

cx = 960; % center in x coords (px) (screen center in behavioral expt)

cy = 710; % center in y coords (px) (screen center in behavioral expt)

iod = 0.8; % 0.5 mantis inter-ocular distance (cm)

viewD = 10; % viewing distance (distance between mantis and monitor) (cm)

virtDm = 2.5; % distance between mantis and bug (virtual) (cm)

% other parameters:

virtDm1 = virtDm;

virtDm2 = virtDm;

makePlot = 0; % when set to 1, the script plots size and trajectory instead of rendering the stimulus

sizeScaleEnable = 1;

bugColor = 0; % [0, 1]

sf = 37; % screen scaling factor (px/cm)

bugSize = 1; % bug size (cm) as perceived by the mantis at virtDm2 position

virtBS2 = viewD / virtDm2 * bugSize;

virtBS1= virtBS2 * virtDm2 / viewD;

duration = 2.25; % duration of motion from distance 1 to 2 (seconds)

bugJitter = 5; % bug jitter in pixels (0 to disable)

enableLoomDisparity = 1;

enableChannels = 0; % 0 = both, -1=only left, +1=only right

enableCyclingMode = 0;

%% print keyboard shortcuts

shortcuts = {
    'p',                        'set disparity to positive', ... 
    'n',                        'set disparity to negative', ... 
    '0',                        'set disparity to zero', ... 
    'b',                        'enable blue channel only', ... 
    'g',                        'enable green channel only', ... 
    'k',                        'enable both channels', ...
    'c',                        'start cycling mode', ...
    'Space or s',               'start bug motion', ...
    'Escape or End',            'exit stimulus'
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
    
    if disparitySizeCondition %#ok<UNRCH>
        
        virtBugSize = @(t) virtBS1 * ones(size(t)); % .* viewD./ virtDm2 ;
        
    else
        virtBugSize = @(t) virtBS1 .* viewD./ virtDm2 * ones(size(t)) ;
        
    end
    
end

% radius:

radFunc = @(t) virtBugSize(t) * sf;

% position:

[swirlX, swirlY, motionR] = getSwirl(cx, cy, motionDuration, motionR0); %#ok<NASGU>

if previewMotionFunc
    
    t = 0:1e-2:10; %#ok<UNRCH>
    
    plot(t, [motionR(t); (t<motionDuration)*motionR0/2]);
    
    xlabel('time');
    
    legend('Swirl Radius', 'Flicker Enable');
    
    return

end

%% flicker box

flickerRect = [0 sH-55 150 sH];

flicker = 0;

%% make plots

if makePlot
    
    t = 0:0.01:duration*1.5; %#ok<UNRCH>
    
    subplot(2, 1, 1);
    
    plot(t, virtBugSize(t)); xlabel('Time'); ylabel('Virtual Bug Size (cm)');
    
    subplot(2, 1, 2);
    
    plot(t, disparity(t)); xlabel('Time'); ylabel('Disparity (cm)');
    
    return

end

%% main loop:

while 1
    
    % input loop
    
    Screen(window, 'flip');
    
    oldKeyIsDown = 1;
    
    while ~enableCyclingMode
        
        [keyIsDown, ~, keyCode] = KbCheck;
        
        exitCode = checkEscapeKeys(keyCode);
        
        if exitCode, return, end
        
        if keyIsDown && ~oldKeyIsDown
            
            keyPress(keyCode);
            
            if keyCode(KbName('p'))
                
                disparityEnable = +1; ss('set disparity to positive');
                
            end
            
            if keyCode(KbName('n'))
                
                disparityEnable = -1; ss('set disparity to negative');
                
            end
            
            if keyCode('0')
                
                disparityEnable = 0; ss('set disparity to 0');
                
            end
            
            if keyCode(KbName('k'))
                
                enableChannels = 0; ss('enabled both channels');
                
            end
            
            if keyCode(KbName('b'))
                
                enableChannels = +1; ss('enabled blue channel only');
                
            end
            
            if keyCode(KbName('g'))
                
                enableChannels = -1; ss('enabled green channel only');
                
            end
            
            if keyCode(KbName('c'))
                
                enableCyclingMode = 1; ss('started cycling mode');
                
            end
            
            if keyCode(KbName('Space')) || keyCode(KbName('s'))
                
                break; % break out of input loop
                
            end
            
        end
        
        oldKeyIsDown = keyIsDown;
        
    end
    
    %% rendering loop
    
    dispStr = ifelse(disparityEnable==1, '+', '-');
    
    ss(sprintf('started swirl (%s disp)', dispStr));
    
    startTime = GetSecs();
    
    flickerCount= 0;
    
    t = 0;
    
    while t < totalTime
        
        t = GetSecs() - startTime;
        
        r = radFunc(0);
        
        dotsL = [swirlX(t) swirlY(t)];
        
        dotsR = [swirlX(t) swirlY(t)];
        
        dotsL(1) = dotsL(1) - enableLoomDisparity * disparity(t, disparityEnable)/2;
        
        dotsR(1) = dotsR(1) + enableLoomDisparity * disparity(t, disparityEnable)/2;
        
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
        
        flickerCol = flickerCols(disparityEnable+2, flicker+1);
        
        flickerDutyCycle = flickerDutyCycles(enableChannels+2);
        
        dutyOn = flickerCount < (flickerPeriod * flickerDutyCycle);        
        
        Screen('SelectStereoDrawBuffer', window, 0);
        
        if ismember(enableChannels, [0 +1])            
            
            Screen('FillOval', window, bugColor, rectL');
            
        end
        
        Screen('FillRect', window, [1 1 1] * flickerEna * flickerCol * dutyOn, flickerRect);
        
        Screen('SelectStereoDrawBuffer', window, 1);
        
        if ismember(enableChannels, [0 -1])
                
            Screen('FillOval', window, bugColor, rectR');
           
        end
        
        Screen('FillRect', window, [1 1 1] * flickerEna * flickerCol * dutyOn , flickerRect);
        
        flickerCount = mod(flickerCount + 1, flickerPeriod);
        
        Screen('Flip', window);
        
        [~, ~, keyCode] = KbCheck;
        
        exitCode = checkEscapeKeys(keyCode);
        
        if exitCode, return, end
        
    end
    
    %% cycling mode delay loop
    
    if enableCyclingMode
        
        Screen('Flip', window);
        Screen('Flip', window);
        
        t0 = GetSecs();
        
        while GetSecs() - t0 < cyclingModeDelay
            
            [~, ~, keyCode] = KbCheck;
            
            exitCode = checkEscapeKeys(keyCode);
            
            if exitCode
                
                return
                
            end
            
        end
        
        disparityEnable = -disparityEnable; % flip disparity
        
    end
    
end

end

function [X, Y, motionR] = getSwirl(centerX, centerY, motionDuration, motionR0)

theta1 = @(t) (t * 2 * pi * 4);

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

v = 0.5;

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t);
Y = @(t) centerY + sin(theta1(t) * v) .* motionR(t);

end
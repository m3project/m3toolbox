function dump = runLoomDonutBug(expt)
%% Initialization

KbName('UnifyKeyNames');

createWindow3D();

window = getWindow();

[sW, sH] = getResolution();

%% Stimulus Settings

makePlot = 0; % when set to 1, the script plots size and trajectory instead of rendering the stimulus

sizeScaleEnable = 1;

disparityEnable = 1;

disparitySizeCondition = 1; % when set to 1, the bug size in the case of (disparityEnable=1, sizeEnable=0) is initially small

bugColor = 0; % 0 (black), 1 (white) or inbetween

donutColor = 1; % 0 (black), 1 (white) or inbetween

backColor = 0; % 0 (black), 1 (white) or inbetween

donutRelRadius = 2.5; % relative to the bug size

iod = 0.4; % mantis inter-ocular distance (cm)

sf = 40; % screen scaling factor (px/cm)

viewD = 2.5; % viewing distance (cm)

virtDm1 = 2.5; % virtual distance 1 from mantis (cm)

virtDm2 = 2.5; % virtual distance 2 from mantis (cm)

bugSize = 1; % bug size (cm) as perceived by the mantis at virtDm2 position

virtBS2 = viewD / virtDm2 * bugSize;

virtBS1= virtBS2 * virtDm2 / viewD;

duration = 0.25; % duration of motion from distance 1 to 2 (seconds)

bugY = 0.57; % vertical location of bug (0 to 1)

bugJitter = 5; % bug jitter in pixels (0 to disable)

aligMinTime = 8; % minimum running time of alignment stimulus (seconds)

finalPresentationTime = 2; % time stimulus remains on screen after looming (seconds)

enableLoomDisparity = 1;

if nargin>0
    
    unpackStruct(expt)
    
end

dump = packWorkspace();

%% functions:

ta = @(t) min(t, duration) / duration; % animation time [0, 1]

virtDm = @(t) virtDm1 + (virtDm2-virtDm1) * ta(t);

% disparity:

disparity = @(t) disparityEnable * iod * (viewD - virtDm(t)) ./ virtDm(t) * sf;

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

cx = sW/2;

cy = sH/2 * bugY;

x1 = @(t) cx - disparity(t)/2;

x2 = @(t) cx + disparity(t)/2;

y1 = @(t) cy;

y2 = @(t) cy;

[swirlX, swirlY] = getSwirl(cx, cy);

swirlActive = 1;

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

startTime = GetSecs();

while 1
    
    t = GetSecs() - startTime();   
    
    if swirlActive
        
        r = radFunc(0);
        
        dotsL = [swirlX(t) swirlY(t)];
        
        dotsR = [swirlX(t) swirlY(t)];
        
        dotsL(1) = dotsL(1) - enableLoomDisparity * disparity(t)/2;
        
        dotsR(1) = dotsR(1) + enableLoomDisparity * disparity(t)/2;
        
        if t>aligMinTime && ~alignMsgDisplayed
            
            %fprintf('\nPress escape to end alignment stimulus ...\n\n');
            
            alignMsgDisplayed = 1;
            
        end
        
        if t>aligMinTime
           
            break;
            
        end
        
    else
        
        r = radFunc(t);
        
        dotsL = [x1(t) y1(t)];
        
        dotsR = [x2(t) y2(t)];
        
        if t>duration + finalPresentationTime
            
            break;
            
        end
        
    end
    
    jt =  rand(1, 2) * bugJitter;    
    
    dotsL = dotsL  + jt;
    dotsR = dotsR  + jt;   
    
    Screen('FillRect', window, [1 1 1] * backColor);    
    
    Screen('SelectStereoDrawBuffer', window, 0); 
    
    colX = (dotsL(1) + dotsR(1))/2;
    colY = (dotsL(2) + dotsR(2))/2;
    
    drawDot(window, colX, colY, r * donutRelRadius, donutColor)
    drawDot(window, dotsL(1), dotsL(2), r, bugColor)
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    drawDot(window, colX, colY, r * donutRelRadius, donutColor)
    drawDot(window, dotsR(1), dotsR(2), r, bugColor)
    
    Screen('Flip', window);
    
    [pressed, ~, keycode] = KbCheck;
    
    if swirlActive && pressed
        
        if t>aligMinTime && keycode(KbName('ESCAPE'))
            
            startTime = GetSecs();
            
            swirlActive = 0;
            
        end
        
        if keycode(KbName('s'))
            
            startTime = GetSecs(); % restarts animation
            
        end
        
    end
    
end

Screen('Flip', window);

end

function drawDot(window, x, y, r, color)
    
    rect = [x-r/2 y-r/4; x+r/2 y+r/4];
    
    Screen('FillOval', window, color, rect');

end

function [X, Y] = getSwirl(centerX, centerY)

theta1 = @(t) (t * 2 * pi * 4);

theta2 = @(t) min(t * 2 * pi * 0.1, pi);

motionR = @(t) 400 * (1+cos(theta2(t))) + 00;

v = 0.5;

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t);
Y = @(t) centerY-100+ sin(theta1(t) * v) .* motionR(t)/2;

end

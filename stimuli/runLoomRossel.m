function [t, finalD, dump] = runLoomRossel(expt)
%% Initialization

KbName('UnifyKeyNames');

createWindow3D();

window = getWindow();

[sW, sH] = getResolution();

%% constants

screenWidth_cm = 50.5;

bugY = 0.5; % vertical location of bug (0 to 1)

bugJitter = 38; % bug jitter in pixels (0 to disable)

bugAspectRatio = 1.5;

bugColor = 0; % 0 (black), 1 (white) or inbetween

backColor = 1; % 0 (black), 1 (white) or inbetween

iod = 0.5; % mantis inter-ocular distance (cm)

initialDelay = 3; % delay in seconds before bug starts looming

%% Stimulus Settings

viewD = 5; % viewing distance (cm)

virtDm2 = 2; % virtual distance 2 from mantis (cm)

bugSize = 1; % physical bug size (cm)

thetad = 0;

if nargin>0
    
    unpackStruct(expt)
    
end

%{
bugSize = 1; % human experiment
virtDm2 = 2; % human experiment
viewD = 47; % human experiment
iod = 5.5; % human
%}
dump = packWorkspace();

%% functions:

sf = sW / screenWidth_cm; % screen scaling factor (px/cm)

theta1 = 2 * atand(iod/2 / viewD);

theta2 = 2 * atand(iod/2 / virtDm2);

angularVelocity = 0.6; % degrees per second

duration = (theta2 - theta1) / angularVelocity;

theta = @(t) theta1 + angularVelocity * t;

disparity_cm = @(t) 2 * (viewD * tand((theta(t)+thetad)/2) - iod/2);

%t = [0:0.01:duration]; plot(t, disparity_cm(t)); return

disparity_px = @(t) disparity_cm(t) * sf;

virtDm = @(t) iod/2 ./ tand(theta(t)/2);

% Comment to Judith: uncomment the line below to produce the disparity
% plots
% Also, hold Ctrl, Shift and press Escp to launch Task Manager and kill the
% PTB window
%
%t = [0:0.01:duration]; plot(virtDm(t), disparity_cm(t)); xlabel('Distance from Screen'); ylabel('Disparity (cm)'); return

scrBS_cm = @(t) bugSize ./ virtDm(t) * viewD;

scrBS_px = @(t) scrBS_cm(t) * sf;

ta = @(t) min(t, duration); % animation time

% radius:

diaFunc = @(t) scrBS_px(t);

% position:

cx = sW/2;

cy = sH/2 * bugY;

xL = @(t) cx - disparity_px(t)/2;

xR = @(t) cx + disparity_px(t)/2;

yL = @(t) cy;

yR = @(t) cy;

%% rendering loop:

resetWindow();

startTime = GetSecs();

loomStarted = 0;

while 1
    
    t = GetSecs() - startTime();   

    if loomStarted
        t2 = t;
    else
        t2 = 0;
    end
    
    d = diaFunc(ta(t2));    
    
    dotsL = [xL(ta(t2)) yL(ta(t2))];
    dotsR = [xR(ta(t2)) yR(ta(t2))];
    
    if loomStarted && t>duration %+ finalPresentationTime
        
        t = 0;

        break;

    end
    
    jt =  [rand * bugJitter 0];
    
    dotsL = dotsL - [d/2 d/4] + jt;
    dotsR = dotsR - [d/2 d/4] + jt;   
    
    rectL = [dotsL; dotsL(1)+d dotsL(2)+d/2 * bugAspectRatio];
    
    rectR = [dotsR; dotsR(1)+d dotsR(2)+d/2 * bugAspectRatio];
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('FillRect', window, [1 1 1] * backColor);
    
    Screen('FillOval', window, bugColor, rectL');
    
    c = [xL(ta(t2)) yL(ta(t2))+d/8];
    
    drawLegs(window, bugColor, c, t, d);
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('FillRect', window, [1 1 1] * backColor);
    
    Screen('FillOval', window, bugColor, rectR');
    
    c = [xR(ta(t2)) yR(ta(t2))+d/8];
    
    drawLegs(window, bugColor, c, t, d);
    
    Screen('Flip', window);
    
    [pressed, ~, keycode] = KbCheck;
    
    if pressed && loomStarted
        
        if keycode(KbName('ESCAPE'))
            
            break;
            
        end
        
    end
    
    if t>initialDelay && ~loomStarted
        
        startTime = GetSecs();
        
        loomStarted = 1;
        
    end
    
end

if t>0

    finalD = virtDm(t);
    
else
       
    finalD = 0;
    
end

Screen('Flip', window);

end

function drawLegs(window, bugColor, c, t, d)

flapSpeed = 12;

legLength = 1;

alpha = cos(t *pi * flapSpeed) * 15;

rect = [c c(1)+legLength*d c(2)+0.1*d];

rotateWindow(c, alpha);

Screen('FillRect', window, bugColor, rect);

rotateWindow(c, 180);

Screen('FillRect', window, bugColor, rect);

rotateWindow(c, 180);

rotateWindow(c, -alpha);

end

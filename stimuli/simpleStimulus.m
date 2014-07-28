function simpleStimulus

KbName('UnifyKeyNames');

createWindow();

window = getWindow();

[sW, sH] = getResolution();

%% stimulus parameters

dia = .1; %desired perceived diameter of object in cm

D = 2.5; %desired simulated distance in front of mantis

W = 3; %half the maximum distance between the two short mirrors

Xcp = .25; %x coordinate of the centre of projection

Ycp = 24; %y coordinate of the centre of projection

V =24; %Distance to screen from mirrors

%% projection calculation:

wd= 51; %width of the screen in cm

sf = sW/wd; %scaling factor from cm to pixels

S  = 2*W- Xcp +  Xcp *(2*V + 2*W  - Ycp)  / D;

dx = S* sf; %300;

phi = atand((S - 2*W  + Xcp ) /( 2*V + 2*W - Ycp) );

sizeFactor=(S - 2*W  + Xcp )/ (Xcp * cosd(phi) );

%% stimulus flags

enableMotion = 1;

enableSwirl = 1;

enableLines = 0;

startTime = GetSecs();

%% motion functions

if enableMotion
    
    if enableSwirl
        
        [CX, CY] = getSwirl(sW/2, (sH/2));
        
        xt = @(t) 0;
        
    else
        
        xt = @(t) 50 * cos(2*pi*t/0.5);
        
        CX = @(t) sW/2;
        CY = @(t) sH/2;
        
    end
    
else
    
    CX = @(t) sW/2;
    CY = @(t) sH/2;
    xt = @(t) 0;
    
   
end

x1 = @(t) CX(t) + dx + xt(t);
x2 = @(t) CX(t) - dx + xt(t);

y1 = @(t) CY(t);
y2 = @(t) CY(t);

r = dia * sizeFactor * sf; %actual diameter of object in px on screen

% param set 2 (loom)
%
% iod = 0.4; % mantis inter-ocular distance (cm)
%
% % sf = 40; % screen scaling factor (px/cm)
%
% viewD = 5; % viewing distance (cm)
%
% virtDm1 = 0; % virtual distance 1 from mantis (cm)
% virtDm2 = 0; % virtual distance 1 from mantis (cm)
%
% duration = 1; % duration of motion from distance 1 to 2 (seconds)
%
% virtDm = @(t) virtDm1 + (virtDm2-virtDm1)*min(t, duration) / duration;
%
% disparity = @(t) iod * virtDm(t)./ (viewD - virtDm(t)) * sf;

% offset0 = 200;

%xt = @(t) 50 * cos(2*pi*t/0.5);
% x1 = @(t) cx + offset0/2 + disparity(t)/2;
% x2 = @(t) cx - offset0/2 - disparity(t)/2;
% y1 = @(t) sH/2 - 200;
% y2 = @(t) sH/2 - 200;


%% rendering loop

while (1)
    
    t = GetSecs() - startTime;
    
    Screen(window, 'FillRect' , [1 1 1] * 255, [0 0 sW sH] );
    
    Screen(window, 'DrawLine',[1 1 1 1] * 0, sW/2, 0, sW/2, sH, 2);
    
    if enableLines
        
        lineWidth = dia*sizeFactor*sf;
        
        rectL1 = [x1(t) 0 x1(t) sH] + [-1 0 1 0] * lineWidth/2;
        
        rectL2 = [x2(t) 0 x2(t) sH] + [-1 0 1 0] * lineWidth/2;
        
        Screen(window, 'FillRect', [1 1 1 1] * 0 ,rectL1);
        
        Screen(window, 'FillRect', [1 1 1 1] * 0 ,rectL2);
        
    else
        
        rect1 = [x1(t) y1(t) x1(t) y1(t)] + [-1 -1 1 1]*r/2;
        
        rect2 = [x2(t) y2(t) x2(t) y2(t)] + [-1 -1 1 1]*r/2;
        
        Screen(window, 'FillOval',[0 0 0] , rect1);
        
        Screen(window, 'FillOval',[0 0 0] , rect2);
        
    end
    
    Screen(window, 'Flip');
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('Escape')))
        
        break;
        
    end
    
%     break;
    
end

end

function [X, Y] = getSwirl(centerX, centerY)

theta1 = @(t) (t * 2 * pi * 4);

theta2 = @(t) min(t * 2 * pi * 0.1, pi);

motionR = @(t) 200 * (1+cos(theta2(t))) + 00;

v = 0.5;

xScaling = 0.7; % this is to tweak the horizontal extent of the spiral

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t) * xScaling;
Y = @(t) centerY + sin(theta1(t) * v) .* motionR(t);

end



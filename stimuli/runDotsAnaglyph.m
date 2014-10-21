function [exitCode, xs, ys, thetas] = runDotsAnaglyph(expt, xs, ys, thetas)

KbName('UnifyKeyNames');

exitCode = 0;

Gamma = 2.127; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

%% Vivek parameters 

bugY = 0.62;

viewD = 10; % viewing distance (cm)

bugSize = 1; % bug size (cm) as perceived by the mantis at virtDm2 position

disparityEnable = -1; % -1 ,0 or +1

iod = 0.7 ; % mantis inter-ocular distance (cm)

enaJitter = 0;

preTrialDelay = 5; % seconds

% dot params: 

n = 1000; % number of dots  

r = 60; % radius

v = 2  ; % velocity

% control params:  

previewDisparityFunc = 0;

previewMotionFuncs = 0;

enableKeyboard = 1;

backDisparity =  0; % background disparity (px)

interTrialTime = 600;

%% parameters

% background params:

backgroundBrightness = 0.5; % (0.5 in Vivek's prev behavioral expts)

dotBrightness = 0.0;
     
% bug params:

%bugR = 100; % bug radius (px)

motionR0 = 800; % initial swirling radius (px)

motionDuration = 5; % duration of swirling (seconds) (5 secs in behavioral expt)

finalPresentationTime = 2;

rotFreq = 4; % Hz

edgeSmoothness = 0.8; % this determines how "hard/soft" the bug borders are

% flicker params

drawFlickerBox = 0;

flickerCols = [0 0.25; 0 0.5; 0 1]; % -, 0 and + disparity (avoid using 0 since black is the non-flickering color)

% loom params





sf = 37.0370; % screen scaling factor (px/cm) for Dell U2413



virtDm1 = 2.5; % virtual distance 1 from mantis (cm)

virtDm2 = 2.5; % virtual distance 2 from mantis (cm)



virtBS2 = viewD / virtDm2 * bugSize;
  
virtBS1= virtBS2 * virtDm2 / viewD;


% overrides for testing:

%rotFreq = 0.1; motionDuration = 50; % for testing

%% parameter overrides

if nargin>0
    
    unpackStruct(expt);
    
end

%% calculated params

bugVisibleTime = motionDuration + finalPresentationTime; % duration of bug visibility(seconds) (7 secs in behavioral expt)

totalTime = motionDuration + finalPresentationTime + interTrialTime;

%% bug size calculations

ta = @(t) min(t, bugVisibleTime) / bugVisibleTime; % animation time [0, 1]

virtDm = @(t) virtDm1 + (virtDm2-virtDm1) * ta(t);

sizeScaleEnable = 1;

% disparity:

disparityMag = @(t) iod * (viewD - virtDm(t)) ./ virtDm(t) * sf;

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

%% disparity function

%x = -10:1e-2:10; y = tansigAB(x, 10, -10); plot(x, y); return;

%ezplot(tansig01, [-10 10]); return

%d = @(dist) (-1).^heaviside(dist - bugR) * disparity;

% d = @(dist, t) -disparityEnable * tansig((dist - radFunc(t)) * edgeSmoothness) * disparityMag(t); 
% d = @(dist, t) -tansig((dist - radFunc(t)) * edgeSmoothness) * disparityMag(t); 
%d = @(dist, t) tansig((dist - radFunc(t)) * edgeSmoothness) * disparityMag(t); 

%d = @(dist, t) tansigAB((dist - radFunc(t)) * edgeSmoothness,  disparityMag(t) * disparityEnable, backDisparity);

if previewDisparityFunc

    dist = 0:200;
    
    d = dispFunc(dist, 0, radFunc, edgeSmoothness, disparityMag, disparityEnable, backDisparity);
    
    plot(dist, d);
    
    xlabel('Distance from Bug (px)'); ylabel('Disparity (px)');
    
    return

end
%% body

window = getWindow();

[sW, sH] = getResolution();

centerX = sW/2;

centerY = sH * bugY;

if nargin < 4
    
    xs = rand(n, 1) * sW;
    
    ys = rand(n, 1) * sH;
    
    thetas = rand(n, 1) * 360;
    
end

testRedBlue = 0;

if testRedBlue
    
    SetAnaglyphStereoParameters('RightGains', window, [1 0 0]);
    
    SetAnaglyphStereoParameters('LeftGains', window, [0 0 1]);
    
end

%% flicker box

flickSize = 50;

flickerRect = [0 sH-flickSize flickSize sH];

flicker = 0;

%% motion function

[X, Y] = getSwirl(centerX, centerY, motionDuration, motionR0, rotFreq);

if previewMotionFuncs
    
    t = 0:1e-2:5;
    
    plot(t, [X(t); Y(t)]);
    
    xlabel('Time (sec)');
    
    legend('X', 'Y');
    
    return
    
end

%% rendering loop

startTime = GetSecs() + preTrialDelay;

while 1
    
    t = GetSecs() - startTime;
    
    if t>totalTime
        
        break;
        
    end
    
    if t>0
        
        bugX = X(t);
        
        bugY = Y(t);
        
    else
        
        bugX = inf;
        
        bugY = inf;
        
    end

    % update positions
    
    xs = xs + v * cosd(thetas);
    
    ys = ys + v * sind(thetas);
    
    k1 = xs>sW+r; xs(k1) = -r;
    
    k1 = xs<0-r; xs(k1) = sW+r;
    
    k1 = ys>sH+r; ys(k1) = -r;
    
    k1 = ys<0-r; ys(k1) = sH+r;
    
    % calculate bug dot indexes
    
    dist = sqrt((xs - bugX).^2 + (ys - bugY).^2);
    
    % update flicker
    
    flickerEna = t<motionDuration;
    
    if flickerEna
        
        flicker = 1 - flicker;
        
    end
    
    k2 = disparityEnable * disparityMag(t);
    
    flickerCol = flickerCols(sign(k2)+2, flicker+1);    
    
    % draw
    
    randV = (rand(n, 1)>0.5);
    
    for channel = [0 1]
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * backgroundBrightness, []);
        
        if t>bugVisibleTime
            
            % this is a little trick to make the bug disappear after
            % presentation time - it basically increases dist by some
            % large value, effectively making the bug appear outside the
            % screen
            
            dist = dist + 1e5;
            
        end
        
        d = dispFunc(dist, t, radFunc, edgeSmoothness, disparityMag, disparityEnable, backDisparity);
        
        pos = [xs-d*(-1)^channel ys];
        
        if enaJitter
            
            jitter = dispFunc(0, t, radFunc, edgeSmoothness, disparityMag, disparityEnable, backDisparity)/2;
            
            pos(:,1) = pos(:,1) + jitter .* (-1).^randV;
            
        end
        
        Screen(window, 'DrawDots', pos', r, [1 1 1] * dotBrightness, [], 2);
        
        if drawFlickerBox
            
            Screen('FillRect', window, [1 1 1] * flickerEna * flickerCol, flickerRect);
            
        end
        
    end
    
    Screen(window, 'Flip');
    
    if enableKeyboard
        
        % handle key presses
        
        [~, ~, keyCode] = KbCheck;
        
        if keyCode(KbName('p'))
            
            disparityEnable = +1;            
            
        end
        
        if keyCode(KbName('n'))
            
            disparityEnable = -1;
            
        end
        
        if keyCode('0')
            
            disparityEnable = 0;
            
        end
        
        if (keyCode(KbName('Space')))
            
            startTime = GetSecs();
            
        end
        
        if keyCode(KbName('Escape'))
            
            exitCode = 0;
            
            break;
            
        end
        
        if keyCode(KbName('END'))
            
            exitCode = 1;
            
            break;
            
        end
        
    end
    
end

end

function [X, Y] = getSwirl(centerX, centerY, motionDuration, motionR0, rotFreq)

theta1 = @(t) t * 2 * pi * rotFreq;

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

v = .5 ;

X = @(t) centerX + cos(theta1(t) * v) .* motionR(t);
Y = @(t) centerY + sin(theta1(t) * v) .* motionR(t);

end

function d = dispFunc(dist, t, radFunc, edgeSmoothness, disparityMag, disparityEnable, backDisparity)

    tansig01 = @(x) (tansig(x)+1)/2;

    tansigAB = @(x, a, b) tansig01(x) * (b-a) + a';

    d = tansigAB((dist - radFunc(t)) * edgeSmoothness,  disparityMag(t) * disparityEnable, backDisparity);
    
end
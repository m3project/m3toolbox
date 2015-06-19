% this script is an adaptation of runDotsAnglyph

function exitCode = runDynamicAnaglyph(expt)

KbName('UnifyKeyNames');

exitCode = 0;

Gamma = 2.127; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

%% Vivek parameters 

randomSeed = 5;

refreshCycle = 1; % background refresh rate (in frames)

syncStimBackground = 1; % synchronize bug position updates with background refresh cycles

bugY = 0.69;

viewD = 5; % viewing distance (cm)

bugSize = 1; % bug size (cm) as perceived by the mantis at virtDm2 position

disparityEnable = 1; % -1 ,0 or +1

iod = 0.7 ; % mantis inter-ocular distance (cm)

enaJitter = 1;

preTrialDelay = 0; % seconds

% dot params: 

unitArea = 100*100; % px

dotDensity = 175; % number of dots in unit area

n = round((1920*1680) / unitArea * dotDensity); % number of dots  

r = 8 ; % radius

% control params:  

enableKeyboard = 1;

enaDynamicBackground = 0;

backDisparity = nan; % 0 to disable, number to set disparity or `nan` to match negative bug disparity

interTrialTime = 1;

jitter = 10; % px

%% parameters

% background params:

backgroundBrightness = 0.5; % (0.5 in Vivek's prev behavioral expts)

dotBrightness = 0.0;
     
% bug params:

% bugR = 100; % bug radius (px)

motionR0 = 800; % initial swirling radius (px)

motionDuration = 5; % duration of swirling (seconds) (5 secs in behavioral expt)

finalPresentationTime = 2;

rotFreq = 4; % Hz

% edgeSmoothness = 0.8; % this determines how "hard/soft" the bug borders are

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

disparityMag = calDisp(virtDm1, viewD, iod) * sf;

% size:

if sizeScaleEnable
    
    virtBugSize = @(t) virtBS1 .* viewD./ virtDm(t) ;
    
else
    
    if disparitySizeCondition %#ok
        
        virtBugSize = @(t) virtBS1 * ones(size(t)); % .* viewD./ virtDm2 ;
        
    else
        virtBugSize = @(t) virtBS1 .* viewD./ virtDm2 * ones(size(t)) ;
        
    end
    
end

% radius:

radFunc = @(t) virtBugSize(t) * sf;

%% body

window = getWindow();

[sW, sH] = getResolution();

centerX = sW/2;

centerY = sH * bugY;

testRedBlue = 0;

if testRedBlue
    
    SetAnaglyphStereoParameters('RightGains', window, [1 0 0]); %#ok
    
    SetAnaglyphStereoParameters('LeftGains', window, [0 0 1]);
    
end

%% motion function

[X, Y] = getSwirl(centerX, centerY, motionDuration, motionR0, rotFreq);

%% some anon functions

dst = @(x,y) sqrt(x.^2 + y.^2);

%% rendering loop

rng(randomSeed);

startTime = GetSecs() + preTrialDelay;

i = 0;

t2 = 0;

while 1
    
    i = i + 1;
    
    t = GetSecs() - startTime;
    
    if t>totalTime
        
        break;
        
    end
    
    if t>0
        
        if (mod(i, refreshCycle)==0 || ~syncStimBackground)
            
            t2 = t;
            
        end
        
        bugX = X(t2);
            
        bugY = Y(t2);
        
        if enaJitter
            
            bugX = bugX + rand2() * jitter;
            
            bugY = bugY + rand2() * jitter;
            
            
        end
        
    else
        
        bugX = inf;
        
        bugY = inf;
        
    end
    
    bugR = radFunc(t);
    
    % update dot positions
    
    if (i==1) || (enaDynamicBackground && mod(i, refreshCycle)==0)
        
        xs0 = (1.2 * rand(n, 1) - 0.1) * sW;
        
        ys = (1.2 * rand(n, 1) - 0.1) * sH;
        
        % target dots:

        tgtDots = round(((2*bugR)^2) / unitArea * dotDensity);
        
        xst = rand2(tgtDots, 1) * bugR;
        
        yst = rand2(tgtDots, 1) * bugR;
        
        % % remove dots outside target
        
        k = dst(xst, yst) < bugR;
        
        xst = xst(k);
        
        yst = yst(k);
        
    end
    
    for channel = [0 1]
        
        xs = xs0;
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * backgroundBrightness, []);
        
        if t>bugVisibleTime
            
            % this is a little trick to make the bug disappear after
            % presentation time - it basically increases dist by some
            % large value, effectively making the bug appear outside the
            % screen
            
            xst = xst + 5000;
            
            bugX = bugX + 5000;
            
        end
        
        disparitySign = (-1)^channel;

        d = disparityMag/2 * disparitySign * disparityEnable;
        
        % Start of new section:
        
        if isnan(backDisparity)
       
            xs = xs - d;
        
        else
            
            xs = xs + backDisparity/2 * disparitySign;
            
        end
        
        % take-out background dots that are inside the target
        
        k = dst(xs-(bugX+d), ys-bugY) > bugR;
        
        pos = [xs(k) ys(k)];
        
        % add target dots to background
        
        tgt_pos = [xst+bugX+d yst+bugY];

        pos = [pos; tgt_pos]; %#ok
        
        % End of new section
        
        Screen(window, 'DrawDots', pos', r, [1 1 1] * dotBrightness, [], 2);
        
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

% function d = dispFunc(dist, t, radFunc, edgeSmoothness, disparityMag, disparityEnable, enaBackDisparity)
% 
% tansig01 = @(x) (tansig(x)+1)/2;
% 
% tansigAB = @(x, a, b) tansig01(x) * (b-a) + a';
% 
% if enaBackDisparity
%     
%     backDisparity = -disparityMag(t) * disparityEnable;
%     
% else
%     
%     backDisparity = 0;
%     
% end    
% 
% d = tansigAB((dist - radFunc(t)) * edgeSmoothness,  disparityMag(t) * disparityEnable, backDisparity);
% 
% end
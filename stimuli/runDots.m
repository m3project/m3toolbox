% this is a major refactoring of runDotsAnagylph
%
% to remove code sections that were carried over from previous experiments
% but are no longer needed, plus introduces new flags to make it easier
% to render new stimulus variations for future experiments

% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 1/6/2016

function varargout = runDots(args, dotInfo)

% parameters

% dot params: -------------------------------------------------------------

n = 10000; % number of dots

r = 20; % diameter

v = 2  ; % velocity

pairDots = 1; % when set to 0, dots in different channels become unpaired

dotBrightness = 0.0;

% bug params: -------------------------------------------------------------

bugSize = 1; % bug size (cm) as perceived by the mantis at virtDm position

virtDm = 2.5; % virtual distance from mantis (cm)

bugY = 0.65;

edgeSmoothness = 0.8; % this determines how "hard/soft" the bug borders are

motionR0 = 800; % initial swirl radius (px)

rotFreq = 2; % swirl rotation frequency (Hz)

% timing params: ----------------------------------------------------------

preTrialDelay = 5; % delay before bug appears (seconds)

motionDuration = 5; % duration of swirl (seconds)

finalPresentationTime = 2; % bug visible after swirl (seconds)

interTrialTime = 600; % delay after bug disappears (seconds)

% screen params: ----------------------------------------------------------

Gamma = 2.127; % for DELL U2413

sf = 37.0370; % screen scaling factor (px/cm) for Dell U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

% mantis params: ----------------------------------------------------------

iod = 0.7 ; % inter-ocular distance (cm)

viewD = 10; % viewing distance (cm)

% control flags: ----------------------------------------------------------

previewDisparityFunc = 0;

previewMotionFuncs = 0;

enableKeyboard = 1;

useRedBlue = 0;

%% Unsorted parameters

disparityEnable =  1; % -1 ,0 or +1

bgDisp =  0; % background disparity (px)

bgLum = 0.5; % backgrounf luminnance

%% parameter overrides

if nargin>0
    
    unpackStruct(args);
    
end

if nargin && (isfield(args, 'virtDm1') || isfield(args, 'virtDm1'))
    
    error('this stimulus no longer supports these parameters');
        
end

%% timing calculations

bugVisibleTime = motionDuration + finalPresentationTime; % duration of bug visibility(seconds)

totalTime = motionDuration + finalPresentationTime + interTrialTime;

%% bug size calculations

% disparity:

if virtDm>viewD; error('virmDm should not be larger than viewD!'); end

disparityMag = calDisp(virtDm, viewD, iod) * sf;

% size:

virtBugSize = bugSize .* viewD./ virtDm;

% radius:

radFunc = virtBugSize * sf;

%% disparity function

tansig01 = @(x) (tansig(x)+1)/2;

tansigAB = @(x, a, b) tansig01(x) * (b-a) + a';

dispFun = @(dist) tansigAB((dist - radFunc) * edgeSmoothness, ...
    disparityMag * disparityEnable, bgDisp);

if previewDisparityFunc
    
    dist = 0:200; %#ok<UNRCH>
    
    plot(dist, dispFun(dist));
    
    xlabel('Distance from Bug (px)'); ylabel('Disparity (px)');
    
    return
    
end

%% motion function

[sW, sH] = getResolution();

centerX = sW * 0.5;

centerY = sH * bugY;

[X, Y] = getSwirl(centerX, centerY, motionDuration, motionR0, rotFreq);

if previewMotionFuncs
    
    t = 0:1e-2:5; %#ok<UNRCH>
    
    plot(t, [X(t); Y(t)]);
    
    xlabel('Time (sec)');
    
    legend('X', 'Y');
    
    return
    
end

%% create Window

if useRedBlue
    
    RightGains = [1 0 0]; %#ok<UNRCH>
    
    LeftGains = [0 0 1];
    
end

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

%% initial dot positions and velocities

if nargin == 2
    
    unpackStruct(dotInfo);

else
    
    xs = rand(n, 2) * sW;
    
    ys = rand(n, 2) * sH;
    
    thetas = rand(n, 2) * 360;
    
end

%% rendering loop

KbName('UnifyKeyNames');

startTime = GetSecs() + preTrialDelay;

while 1
    
    t = GetSecs() - startTime;
    
    if t>totalTime; break; end
    
    bugVisible =  t>0 && t<bugVisibleTime;
    
    bugX = ifelse(bugVisible, X(t), inf);
    bugY = ifelse(bugVisible, Y(t), inf);
    
    % update positions
    
    xs = xs + v * cosd(thetas);    
    ys = ys + v * sind(thetas);
    
    % reposition dots moving off the screen
    
    xs(xs > sW+r) = -r;
    ys(ys > sH+r) = -r;
    
    xs(xs < -r) = sW + r;    
    ys(ys < -r) = sH + r;
    
    % calculate dot distances from bug
    
    dist = sqrt((xs - bugX).^2 + (ys - bugY).^2);
    
    % draw
    
    for channel = [0 1]
        
        % calculate dot positions:
        
        chanInd = ifelse(pairDots, 1, 1 + channel);
        
        d = dispFun(dist(:, chanInd));
        
        XS = xs(:, chanInd) - d*(-1)^channel;
        
        YS = ys(:, chanInd);
        
        pos = [XS YS];
        
        % draw:
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * bgLum, []);
        
        Screen(window, 'DrawDots', pos', r, [1 1 1] * dotBrightness, [], 2);
        
    end
    
    Screen(window, 'Flip');
    
    if enableKeyboard
        
        % handle key presses
        
        [~, ~, keyCode] = KbCheck;
        
        if (keyCode(KbName('Space'))); startTime = GetSecs(); end
        
        if keyCode(KbName('Escape')); break; end
        
        if keyCode(KbName('END')); break; end
        
    end
    
end

dotInfo = struct('xs', xs, 'ys', ys, 'thetas', thetas);

if nargout; varargout{1} = dotInfo; end

end

function [X, Y] = getSwirl(centerX, centerY, motionDuration, motionR0, rotFreq)

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

X = @(t) centerX + cos(t * 2 * pi * rotFreq) .* motionR(t);
Y = @(t) centerY + sin(t * 2 * pi * rotFreq) .* motionR(t);

end
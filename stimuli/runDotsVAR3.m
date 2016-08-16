% this is a major refactoring of runDotsAnagylph
%
% to remove code sections that were carried over from previous experiments
% but are no longer needed, plus introduces new flags to make it easier
% to render new stimulus variations for future experiments

% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 1/6/2016

function varargout = runDotsVAR3(args)

% inDebug();

% parameters

videoFile = ''; % leave empty to disable recording

recordingFrameRate = 60;

% dot params: -------------------------------------------------------------

n = 10000; % number of dots

r = 20; % diameter

v = 0.1  ; % velocity

vTargetDots = 2  ; % velocity

pairDots = 0; % when set to 0, dots in different channels become unpaired

targetDirection1 = 4; % 3 = right, 4 = down, 5 = left, 6 = up
targetDirection2 = 6; % 3 = right, 4 = down, 5 = left, 6 = up

% bug params: -------------------------------------------------------------

bugRadius = 0.5; % bug radius (cm) as perceived by the mantis at virtDm position

virtDm = 2.5; % virtual distance from mantis (cm)

bugY = 0.65;

crossed = 1;

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

previewMotionFuncs = 0;

enableKeyboard = 1;

useRedBlue = 0;

plotTarget = [];

%% Unsorted parameters

bgLum = 0.5; % backgrounf luminnance

dotInfo = [];

renderChannels = [0 1];

%% parameter overrides

if nargin>0; unpackStruct(args); end

if nargin && (isfield(args, 'virtDm1') || isfield(args, 'virtDm1'))
    
    error('this stimulus no longer supports these parameters');
        
end

%% timing calculations

bugVisibleTime = motionDuration + finalPresentationTime; % duration of bug visibility(seconds)

totalTime = motionDuration + finalPresentationTime + interTrialTime;

%% bug size calculations

% disparity:

if virtDm>viewD; error('virmDm should not be larger than viewD!'); end

D = calDisp(virtDm, viewD, iod) * sf; % disparity in pixels

% radius:

virtBugRadiusPx = bugRadius .* viewD./ virtDm * sf;

%% motion function

[sW, sH] = getResolution();

centerX = sW * 0.5;

centerY = sH * bugY;

%[X, Y] = getAppear(centerX, centerY);
[X, Y] = getSwirl(centerX, centerY, motionDuration);

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

if ~isempty(dotInfo)
    
    unpackStruct(dotInfo);
    
    n = size(xs, 1); %#ok<NODEF>

else
    
    xs = rand(n, 10) * (sW + 2 * r) - r;    
    ys = rand(n, 10) * (sH + 2 * r) - r;
    
    vs = v * ones(n, 10);
    
    thetas = rand(n, 10) * 360;
    
    thetas(:, 3) = 0;
    thetas(:, 4) = 90;
    thetas(:, 5) = 180;
    thetas(:, 6) = 270;
    
    thetas(:, 7) = 0;
    thetas(:, 8) = 90;
    thetas(:, 9) = 180;
    thetas(:, 10) = 270;
    
    vs(:, 1:2) = v;
    
    vs(:, 3:end) = vTargetDots;
    
    dotLum = rand(n, 10) > 0.5;
    
    G = randb(n, 10); % random matrix to select arbitrary dot subsets
    
end

%% rendering loop

KbName('UnifyKeyNames');

t0 = GetSecs();

recording = recordStimulus(videoFile);

endRecording = @() recordStimulus(recording);

obj1 = onCleanup(endRecording);

i = 0;

while 1
    
    i = i + 1;
    
    tReal = GetSecs() - t0 - preTrialDelay;
    
    tFrames = i / recordingFrameRate - preTrialDelay;
    
    t = ifelse(isempty(recording), tReal, tFrames);
    
    if t>totalTime; break; end
    
    bugVisible =  t>0 && t<bugVisibleTime;
    
    bugX = ifelse(bugVisible, X(t), inf);
    bugY = ifelse(bugVisible, Y(t), inf);
    
    % update positions
    
    xs = xs + vs .* cosd(thetas);    
    ys = ys + vs .* sind(thetas);
    
    % reposition dots moving off the screen
    
    xs(xs > sW+r) = -r;
    ys(ys > sH+r) = -r;
    
    xs(xs < -r) = sW + r;    
    ys(ys < -r) = sH + r;
    
    % draw
    
    for channel = renderChannels
        
        % calculate dot positions:
        
        ch = ifelse(pairDots, 1, 1 + channel);
        
        ch2 = 1 + channel;
        
        XS1 = xs(:, ch2);
        YS1 = ys(:, ch2);
        
        lum1 = dotLum(:, ch);
        
        targetDirection = ifelse(ch2 == 1, targetDirection1, targetDirection2);
        
        XS2 = xs(:, targetDirection + 4 * channel);
        YS2 = ys(:, targetDirection + 4 * channel);
        
        lum2 = dotLum(:, targetDirection + 4 * channel);
        
        dispSign = (-1)^channel;
        
        dispSign2 = ifelse(crossed, 1, -1);
        
        shiftX = D/2 * dispSign * dispSign2;
        
        inBug1 = sqrt((XS1 - bugX + shiftX).^2 + (YS1 - bugY).^2) < virtBugRadiusPx;
        
        inBug2 = sqrt((XS2 - bugX + shiftX).^2 + (YS2 - bugY).^2) < virtBugRadiusPx;
        
        XS = [XS1(~inBug1); XS2(inBug2)];
        
        YS = [YS1(~inBug1); YS2(inBug2)];
        
        LUM = [lum1(~inBug1); lum2(inBug2)];
        
        pos = [XS YS];
        
        % draw:
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * bgLum, []);
        
%         dotLum = lumFun1(channel, XS, YS, bugX, bugY, virtBugRadiusPx, G, D);
        
        Screen(window, 'DrawDots', pos', r,  (LUM * [1 1 1])' , [], 2);
        
        bugRect = [bugX bugY bugX bugY] + [-1 -1 1 1] * virtBugRadiusPx;
        
        rectL = bugRect + [1 0 1 0] * D/2;
        rectR = bugRect + [1 0 1 0] * -D/2;
        
        if ismember(0, plotTarget)
            
            Screen(window, 'FrameOval', [1 1 1] * 0, bugRect , 4);
            
        end
        
        if ismember(-1, plotTarget)
            
            Screen(window, 'FrameOval', [1 1 1] * 0, rectL , 2);
            
        end
        
        if ismember(1, plotTarget)  
            
            Screen(window, 'FrameOval', [1 1 1] * 0, rectR , 2); 
            
        end
        
    end

    Screen(window, 'Flip');
    
    recording = recordStimulus(recording);
    
    if enableKeyboard
        
        % handle key presses
        
        [~, ~, keyCode] = KbCheck;
        
        if (keyCode(KbName('Space'))); t0 = GetSecs(); end
        
        if keyCode(KbName('Escape')); break; end
        
        if keyCode(KbName('END')); break; end
        
        if keyCode(KbName('RightArrow')); 
            
            v = abs(v);
            
        end
        
        if keyCode(KbName('LeftArrow')); 
            
            v = -abs(v);
            
        end
        
    end
    
end

dotInfo = struct('xs', xs, 'ys', ys, 'thetas', thetas, ...
    'G', G, 'vs', vs, 'dotLum', dotLum);

if nargout; varargout{1} = dotInfo; end

end

function [X, Y] = getSwirl(centerX, centerY, motionDuration)

motionR0 = 800; % initial swirl radius (px)

rotFreq = 2; % swirl rotation frequency (Hz)

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

X = @(t) centerX + cos(t * 2 * pi * rotFreq) .* motionR(t);
Y = @(t) centerY + sin(t * 2 * pi * rotFreq) .* motionR(t);

end
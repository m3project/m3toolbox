% this is a major refactoring of runDotsAnagylph
%
% to remove code sections that were carried over from previous experiments
% but are no longer needed, plus introduces new flags to make it easier
% to render new stimulus variations for future experiments

% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 1/6/2016

function varargout = runDots(args)

%inDebug();

% parameters

videoFile = ''; % leave empty to disable recording

recordingFrameRate = 60;

% dot params: -------------------------------------------------------------

n = 10000; % number of dots

r = 20; % diameter

v = 2  ; % velocity

pairDots = 1; % when set to 0, dots in different channels become unpaired

% bug params: -------------------------------------------------------------

bugRadius = 0.5; % bug radius (cm) as perceived by the mantis at virtDm position

virtDm = 2.5; % virtual distance from mantis (cm)

bugY = 0.65;

motionR0 = 800; % initial swirl radius (px)

rotFreq = 2; % swirl rotation frequency (Hz)

dispFun1 = @getDotDisp;

lumFun1 = @getDotLum;

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

if ~isempty(dotInfo)
    
    unpackStruct(dotInfo);
    
    n = size(xs, 1); %#ok<NODEF>

else
    
    xs = rand(n, 2) * sW;
    
    ys = rand(n, 2) * sH;
    
    thetas = rand(n, 2) * 360;
    
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
    
    xs = xs + v * cosd(thetas);    
    ys = ys + v * sind(thetas);
    
    % reposition dots moving off the screen
    
    xs(xs > sW+r) = -r;
    ys(ys > sH+r) = -r;
    
    xs(xs < -r) = sW + r;    
    ys(ys < -r) = sH + r;
    
    % draw
    
    for channel = renderChannels
        
        % calculate dot positions:
        
        ch = ifelse(pairDots, 1, 1 + channel);
        
        XS = xs(:, ch);
        YS = ys(:, ch);
        
        XSD = XS + ...
            dispFun1(channel, XS, YS, bugX, bugY, virtBugRadiusPx, G, D);
        
        pos = [XSD YS];
        
        % draw:
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * bgLum, []);
        
        dotLum = lumFun1(channel, XS, YS, bugX, bugY, virtBugRadiusPx, G, D);
        
        Screen(window, 'DrawDots', pos', r,  (dotLum * [1 1 1])' , [], 2);
        
        bugRect = [bugX bugY bugX bugY] + [-1 -1 1 1] * virtBugRadiusPx;
        
        rectL = bugRect + [1 0 1 0] * D/2;
        rectR = bugRect + [1 0 1 0] * -D/2;
        
        rectL2 = bugRect + [1 0 1 0] * D;
        rectR2 = bugRect + [1 0 1 0] * -D;
        
        if ismember(0, plotTarget)
            
            Screen(window, 'FrameOval', [1 1 1] * 0, bugRect , 4);
            
        end
        
        if ismember(-1, plotTarget)
            
            Screen(window, 'FrameOval', [1 1 1] * 0, rectL , 2);
%             Screen(window, 'FrameOval', [1 1 1] * 0, rectL2 , 1);
            
        end
        
        if ismember(1, plotTarget)  
            
            Screen(window, 'FrameOval', [1 1 1] * 0, rectR , 2); 
%             Screen(window, 'FrameOval', [1 1 1] * 0, rectR2 , 1); 
            
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

dotInfo = struct('xs', xs, 'ys', ys, 'thetas', thetas, 'G', G);

if nargout; varargout{1} = dotInfo; end

end

function [X, Y] = getSwirl(centerX, centerY, motionDuration, motionR0, rotFreq)

theta2 = @(t) min(t * pi / motionDuration, pi);

motionR = @(t) motionR0/2 * (1+cos(theta2(t)));

X = @(t) centerX + cos(t * 2 * pi * rotFreq) .* motionR(t);
Y = @(t) centerY + sin(t * 2 * pi * rotFreq) .* motionR(t);

end

function disp = getDotDisp(ch, x, y, bugX, bugY, bugRad, G, D)

% ch    : channel
% x     : vector of dot x coordinates
% y     : vector of dot y coordinates
% bugX  : x coordinate of bug
% bugY  : y coordinate of bug
% bugR  : radius of bug (px)
% G     : Nx5 matrix of random 0/1 values with equal probs, see below
% D     : disparity magnitude (px)

% `G` is used to select subsets of the dots
% The value in G are randomized but unique per stimulus presentation. Thus
% to select a random 50% of dots, use x(G(:,1))

inBug = sqrt((x - bugX).^2 + (y - bugY).^2) < bugRad;

inG1 = G(:, 1);

disp = x*0 + inBug * D/2 .* inG1 * (-1)^ch; % for now

end

function lum = getDotLum(ch, x, y, bugX, bugY, bugRad, G, D) %#ok<INUSL,INUSD>

lum = x*0;

end
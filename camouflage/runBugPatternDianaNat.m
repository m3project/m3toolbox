function runBugPatternDianaNat(args)

% constants

sr = 40; % px/cm

viewD = 2.5; % viewing distance (cm)

%% parameters

backBaseLum = 0.5; % background base luminance

% bug:

m = -1; % -1 (background patch), 0 (constant luminance) or n (number of waves/periods, striped bug)

bugDelay = 1; % in seconds (delay before bug moves across the screen)

bugSpeed = 200; % deg/sec

dir = 1; % direction

W = 64 ; % bug width (px)

H = 30; % bug height (px)

escapeEnabled = 1; %#ok

bugBaseLum = 0.5;

bugLumAmp = 0.5;

useNatBack = 1;

videoFile = '';

%% load overrides

if nargin>0
    
    unpackStruct(args);
    
end

%% generation background

[sW, sH] = getResolution();

if useNatBack
    
    backPattern = genNaturalPattern(struct('W', sH, 'H', sH));
    
else

    backPattern = ones(500,500) * backBaseLum; %#ok

end

%% generate pattern

x = 1:W;

if m == 0
    
    % constant luminance bug
    
    bugPattern = bugBaseLum * ones(size(x));
    
    bugPattern = repmat(bugPattern, [H, 1]); %#ok
    
elseif m == -1
    
    % bug is patch of background
    
    bugPattern = backPattern(1:H, 1:W);

    bugPattern = scaleBugLum(bugPattern); %#ok
    
elseif m == -2
    
    % bug is natural background
    
    bugPattern = genNaturalPattern(struct('W', H, 'H', W));
    
    bugPattern = scaleBugLum(bugPattern, bugBaseLum); %#ok
    
else
    
    % striped bug

    blockSize = W/m/2;
    
    p = genChequer(struct('W', W, 'H', 1, 'blockSize', blockSize, 'random', 0, 'lum0', -1, 'lum1', 1));
    
    p = transp(circshift(p', -blockSize/2));
    
    bugPattern = bugBaseLum + bugLumAmp * p;
    
    bugPattern = repmat(bugPattern, [H, 1]); %#ok

end

% figure(); plot(bugPattern, '-o'); colormap gray; ylim([-1 2]); return

%% render

mWidth = sW * 1.25;

deg_per_px = range(px2deg(2, sr, viewD)) / 2; % averaged over two pixels

bugSpeedPxSec = bugSpeed / deg_per_px;

travelTime = sW / bugSpeedPxSec; % time to traverse screen width

getPosX_old = @(t) sawtooth(t / (2*pi) / travelTime * 20, 0.5) * mWidth/2 * dir + sW/2;

duration = bugDelay + travelTime + 1; %#ok

if dir == 1

    pos0 = -bugSpeedPxSec * bugDelay;

else
    
    pos0 = bugSpeedPxSec * bugDelay + sW;
    
end

getPosX = @(t) pos0 + dir * bugSpeedPxSec * t;

getBugPosition = @(t) [getPosX(t) sH/2]; %#ok

args2 = packWorkspace('bugPattern', 'getBugPosition', ...
    'escapeEnabled', 'duration', 'backPattern', 'videoFile');

runCamoPattern(args2);

end


function pattern = scaleBugLum(pattern, meanLum)

if nargin<2; meanLum = 0.5; end

% first, make the levels of pattern as large as possible within the
% interval [0, 1] with meanLum = 0.5

pattern = scaleBugLum_old(pattern);

% now calculate upper and lower overhead

l = meanLum;

u = 1 - meanLum;

t = min(l, u);

U = meanLum + t;

L = meanLum - t;

pattern = scaleLumLevels(pattern, L, U);

end


function pattern = scaleBugLum_old(pattern)

% change mean to 0.5

pattern = pattern / mean(pattern(:)) * 0.5;

% scale min and max so that all luminance levels are in [0, 1]

k1 = abs(max(pattern(:)) - 0.5);
k2 = abs(min(pattern(:)) - 0.5);

k3 = max(k1, k2);

pattern = 0.5 + (pattern - 0.5)/k3/2;

end
function runBugPatternDiana(args)

% constants

sr = 40; % px/cm

viewD = 7; % viewing distance (cm)

%% parameters

baseLum = 0.5; % background

% bug:

m = 4; % 0 (black) or n (number of waves)

bugSpeed = 200; % deg/sec

dir = 1; % direction

W = 60 ; % bug width (px)

H = 30; % bug height (px)

escapeEnabled = 1; %#ok

duration = 10; %#ok seconds

bugBaseLum = 0.5;

bugLumAmp = 0.5;

if nargin>0
    
    unpackStruct(args);
    
end

%% generation background

backPattern = ones(500,500) * baseLum; %#ok

%% generate pattern

x = 1:W;

if m == 0
    
    bugPattern = bugBaseLum * ones(size(x));
    
else

    bugPattern = bugBaseLum + bugLumAmp * sign(sin(x/60*2*m*pi - pi/2));

end

bugPattern = repmat(bugPattern, [H, 1]); %#ok
    
%% render

[sW, sH] = getResolution();

mWidth = sW * 1.25;

deg_per_px = range(px2deg(2, sr, viewD)) / 2; % averaged over two pixels

bugSpeedPxSec = bugSpeed / deg_per_px;

travelTime = sW / bugSpeedPxSec; % time to traverse screen width

getPosX = @(t) sawtooth(t / (2*pi) / travelTime * 20, 0.5) * mWidth/2 * dir + sW/2;

getBugPosition = @(t) [getPosX(t) sH/2]; %#ok

args2 = packWorkspace('bugPattern', 'getBugPosition', 'escapeEnabled', 'duration', 'backPattern');

runCamoPattern(args2);

end
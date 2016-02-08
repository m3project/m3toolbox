function runSimpleHorizontalChequer(bugSpeed)

%parameters
 
bgContrast = 0;

viewD = 3; % viewing distance in cm

% bugSpeed = 25; % deg/sec

%% body

m = Screen('windows');

Gamma = 2.783; % this is for Lisa's Phillips 107b3

if isempty(m)

    createWindow(Gamma);
    
end

W = 60 ; % bug width (px)

H = 30; % bug height (px)

bugPattern = zeros(H, W); %#ok

lums = 0.5 + [-1 1] * 0.5 * bgContrast;

backPattern = genChequer(struct('blockSize', 10, 'W', 500, 'H', 500, ...
    'lum0', lums(1), 'lum1', lums(2), 'rseed', 1)); %#ok

sr = 40;

dir = 1;

%% render

[sW, sH] = getResolution();

mWidth = sW * 1.25;

deg_per_px = range(px2deg(2, sr, viewD)) / 2; % averaged over two pixels

bugSpeedPxSec = bugSpeed / deg_per_px;

travelTime = sW / bugSpeedPxSec; % time to traverse screen width

duration = travelTime;

getPosX = @(t) sawtooth(t / (2*pi) / travelTime * 20, 0.5) * mWidth/2 * dir + sW/2;

getBugPosition = @(t) [getPosX(t) sH/2]; %#ok

args2 = packWorkspace('bugPattern', 'getBugPosition', 'escapeEnabled', 'duration', 'backPattern', 'duration');

runCamoPattern(args2);

end
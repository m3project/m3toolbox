function runBugPattern(args)

% parameters

Fx = 1/64; % cycle/px

Sigx = 0.001; % cycle/px

bugSpeed = 1500; % px/sec

duration = 5;

dir = power(-1, rand>0.5);

baseLum = 0.5;

contrast = 1;

escapeEnabled = 1;

if nargin>0
    
    unpackStruct(args);
    
end

%% generate pattern

% the code below will make repetitive attempts to generate a bug pattern
% it will stop when the mean luminance of the generated bug is within an
% acceptable range of a target mean luminance

targetBaseLum = 0.5;

baseLumErr = inf;

baseLumErrTolerance = 0.001;

MAX_RETRIES = 10;

i = 0;

while (baseLumErr > baseLumErrTolerance) && (i < MAX_RETRIES)
    
    bugPattern = gen2DPattern(struct('Fx', Fx, 'Sigx', Sigx, 'W', 50, 'H', 50));
    
    [minLum, maxLum] = calLumLevels(baseLum, contrast);
    
    bugPattern = scaleLumLevels(bugPattern, minLum, maxLum);
    
    bugBaseLum = mean(bugPattern(:));
    
    baseLumErr = abs(bugBaseLum - targetBaseLum);
    
    i = i + 1;
    
end

%% render

[sW, sH] = getResolution();

% getBugPosition_w = @(t) getBugPosition(t, sW, sH, dir, bugSpeed);

getBugPosition_w = @(t) getBugPosSwirl(t, sW, sH, dir, bugSpeed);

args2 = struct('bugPattern', bugPattern, 'getBugPosition', getBugPosition_w, 'escapeEnabled', escapeEnabled, 'duration', duration);

runCamoPattern(args2);

end

function pos = getBugPosition(t, sW, sH, bugDirection, bugSpeed)

t = max(0, t-2);

pos(1) = sW / 2 + t * bugSpeed * bugDirection;

pos(2) = sH * 0.5;

end

function pos = getBugPosSwirl(t, sW, sH, bugDirection, bugSpeed)

radius = 200; % px

angVel = bugDirection * bugSpeed / radius; % angular velocity (rad/sec)

angPos = angVel * t;

pos = [sW sH]/2 + [cos(angPos) sin(angPos)] * radius;

end
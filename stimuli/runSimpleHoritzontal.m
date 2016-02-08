% this is a wrapper of runAnimation2

function exitCode = runSimpleHoritzontal(expt)

createWindow(1);

%% parameters

jitter = 5; % pixels

speed = 1000; % px/sec

dir = power(-1, rand>0.5);

timeLimit = 3; % in seconds (0 to disable)

bugY = 0.5; % y-cord (0 to 1)

bugWidth = 20; % in units of M px

bugHeight = 6; % in unis of M px

%% loading overrides

if nargin>0
    
    unpackStruct(expt);
    
end

%% motion function

[W, H] = getResolution();

X = @(t) dir * (t * speed);

Y = @(t) H * (bugY - 0.5);

motionFuncs.XY      = @(t) [X(t) Y(t)] + (rand(1, 2)-0.5) * jitter;

motionFuncs.Angle   = @(t) 180 * (dir == -1);

motionFuncs.F       = @(t) t * 60;

motionFuncs.S       = @(t) 1;

expt = struct;

expt.R = 1;

expt.M = 10;

expt.timeLimit = timeLimit;

expt.motionFuncs = motionFuncs;

expt.bugFrames{1} = ones(bugHeight, bugWidth);

expt.interactiveMode = 0;

%% rendering

[~, ~, ~, exitCode, ~] = runAnimation2(expt);

end


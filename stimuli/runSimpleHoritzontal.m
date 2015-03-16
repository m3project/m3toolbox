% this is a wrapper of runAnimation2

function runSimpleHoritzontal(expt)

createWindow(1);

%% parameters

jitter = 5; % pixels

speed = 1000; % px/sec

dir = 1;

timeLimit = 3; % in seconds (0 to disable)

bugY = 0.5; % y-cord (0 to 1)

%% loading overrides

if nargin>0
    
    unpackStruct(expt);
    
end

%% motion function

[W, H] = getResolution();

X = @(t) dir * (-W/2 + t * speed);

Y = @(t) H * (bugY - 0.5);

motionFuncs.XY      = @(t) [X(t) Y(t)] + (rand(1, 2)-0.5) * jitter;

motionFuncs.Angle   = @(t) 180 * (dir == -1);

motionFuncs.F       = @(t) t * 60;

motionFuncs.S       = @(t) 2;

expt = struct;

expt.R = 1;

expt.M = 10;

expt.timeLimit = timeLimit;

expt.motionFuncs = motionFuncs;

%% rendering

runAnimation2(expt);

end


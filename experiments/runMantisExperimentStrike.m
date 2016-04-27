function runMantisExperimentStrike()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisStrike\';

expt.name = 'Mantis Strike';

expt.recordVideos = 0;

expt.makeBackup = 0;

expt.defName = 'Geoffrey';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 10;

paramSet = createRandTrialBlocks(blocks, [-1 +1]);

end

function runBeforeTrial(~)

runAlignmentStimulusNoBack();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.dir = paramSetRow(1);

runHorizontalBug(expt);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = getResponseJudgement();

end


function runHorizontalBug(expt)

createWindow(1);

%% parameters

jitter = 5; % pixels

speed = 1000; % px/sec

dir = 1;

timeLimit = 5; % in seconds (0 to disable)

bugY = 0.5; % y-cord (0 to 1)

%% loading overrides

if nargin>0
    
    unpackStruct(expt);
    
end

%% motion function

[W, H] = getResolution();

t1 = @(t) max(0, t-1);

X = @(t) dir * (-(W+200)/2 + t1(t) * speed);

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


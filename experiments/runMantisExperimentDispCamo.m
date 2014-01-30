function runMantisExperimentDispCamo()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisDispCamo\';

expt.recordVideos = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

% this current implementation of genParamSet() will assume a fixed
% distance to the screen (L12) of 10 cms. Distance L1 is also
% constrained to the values [2 4 6 8 10].

L12 = 10; % distance to the screen in cm

d = 0.4; % mantis interocular distance in cm

screenPxCm = 40; % screen resolution (px/cm)

blocks = 10;

L1s = [2 4 6 8 10];

L2s = L12 - L1s;

S = d * L2s ./ L1s;

Spx = ceil(S * screenPxCm);

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, L12, d, Spx, dirs);

end

function runBeforeTrial(varargin)

runAlignmentStimulus(1, 0, 150);

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

disparity = paramSetRow(3);

dir = paramSetRow(4);

expt = struct;

expt.disparity = disparity;

expt.interactiveMode = 0;

expt.timeLimit = 3;

expt.closeOnFinish = 0;

expt.M = 4;

expt.dynamicBackground = 1;

expt.txtCount = 200;

expt.R = 0.5;

expt.textured = 0;

expt.camouflage = 1;

expt.stepDX = 1;

expt.bugFrames = getBugFrames('block');

expt.motionFuncs = getMotionFuncDispCamo(dir);

expt.nominalSize = 1;

expt.bugVisible = 1;

expt.enable3D = 1;

[~, ~, ~, exitCode, dump] = runAnimation2(expt);

end

function motionFuncs = getMotionFuncDispCamo(dir)

% preparing motion functions

theta1 = @(t) (t * 2 * pi);

v = 1.005;

X = @(t) dir * (mod(t * 500, 2000));

Y = @(t) sin(theta1(t) * v) * 50 + 150;

motionFuncs.XY      = @(t) [X(t) Y(t)];
motionFuncs.Angle   = @(t) sin(theta1(t) * v) * 25;
motionFuncs.Angle   = @(t) 180;
motionFuncs.F       = @(t) t * 60;
motionFuncs.S       = @(t) 1;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
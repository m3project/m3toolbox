function runMantisVideoCapture()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial2;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisVideoCapture\';

expt.name = 'Mantis Video Capture (Dummy Experiment)';

expt.recordVideos = 1;

expt.defName = 'Ghaith';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 500;

paramSet = createRandTrialBlocks(blocks, [-1 1]);

end

function runBeforeTrial(varargin)

x = 0;

y = 350;

% render alignment stimulus

expt = struct;

expt.interactiveMode = 1;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.disparity = 0;

expt.M = 40;

expt.R = 0.5;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) 0;

expt.stepDX = 0;

expt.bugFrames = getBugFrames('fly');

expt.motionFuncs = getMotionFuncs('swirl', x, y);

expt.nominalSize = 0.5;

expt.bugVisible = 1;

expt.txtCount = 50;

expt.bugVisible = 1;

expt.timeLimit = 6;

%expt.interactiveMode = 0;

%expt.enable3D = 0;

%disp('alignment mode (interactive), press Escape when mantis is aligned ...');

% runAnimation2(expt);

end

function [exitCode, dump] = runTrial2(~)

runAnimation2(struct('interactiveMode', 0, 'timeLimit', 5, 'Gamma', 1, 'R', 1));

exitCode = 0; dump = [];

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

expt.interactiveMode = 0;

expt.timeLimit = 5;

expt.enable3D = 0;

expt.txtCount = 50;

expt.R = 0.5;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) paramSetRow(1) * t * 500 ;

expt.bugVisible = 0;

[~, ~, ~, exitCode, dump] = runAnimation2(expt);

end

function resultRow = runAfterTrial(varargin)

resultRow = 0;

end
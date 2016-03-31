function runMantisExperimentSlidingBars()

usePILOT3 = 1;

expt = struct;

expt.genParamSetFun = @genParamSet_VAR1;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial_VAR1;

expt.runAfterTrialFun = @runAfterTrial_PILOT3;

expt.runBeforeExptFun = @runBeforeExpt;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisSlidingBars\';

expt.name = 'Mantis Sliding Bars (VAR2)';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Lisa';

expt.addTags = {'VAR2'};

if usePILOT3 == 1
    
    expt.genParamSetFun = @genParamSet_PILOT3;
    
    expt.runTrialFun = @runTrial_PILOT3;
    
    expt.addTags = {'PILOT3', 'RUN2'};
    
    expt.name = 'Mantis Sliding Bars (PILOT3)';
    
end

expt.runAfterExptFun = @() closeWindow();

runExperiment(expt);

end

function paramSet = genParamSet_PILOT3()

blocks = 5;

bug = [0 1 2];

backBlockSizes = [5 10 20]; % note: 0 is special code for gray background

paramSet = createRandTrialBlocks(blocks, bug, backBlockSizes);

end

function paramSet = genParamSet()

blocks = 5;

bug = [0 1];

backBlockSizes = [5 10 20]; % note: 0 is special code for gray background

paramSet = createRandTrialBlocks(blocks, bug, backBlockSizes);

end

function paramSet = genParamSet_VAR1()

blocks = 5;

stimType = [0 1 -1];

% stimType is the type of stimulus:
% 0 = still background
% 1 = background moving in phase with bug
% -1 = background moving out of phase with bug

backBlockSizes = [5 10 20];

paramSet = createRandTrialBlocks(blocks, stimType, backBlockSizes);

end

function runBeforeExpt()

Gamma = 2.783; % this is for Lisa's Phillips 107b3

createWindow(Gamma);

end

function runBeforeTrial(~)

runAlignmentStimulus_internal(0, 0, 0);

end

function [exitCode, dump] = runTrial_VAR1(paramSetRow)

disp('rendering the stimulus ...');

args = struct;

args.bugW = 80;

args.bugH = 80;
    
args.blockSize = paramSetRow(2);

args.duration = 3/5 * 2 * pi * 4;

args.escapeEnabled = 0;

args.preTrialDelay = 15;

% paramSetRow(1) is the type of stimulus:
% 0 = still background
% 1 = background moving in phase with bug
% -1 = background moving out of phase with bug

if paramSetRow(1) == 0
    
    args.freqBack = 0;
    
elseif paramSetRow(1) == 1
    
    args.bugPhase = 0;
    
elseif paramSetRow(1) == -1
    
    args.bugPhase = pi/2;
    
else
    
    error('incorrect stimulus type');
    
end

runSlidingBars(args);

exitCode = 0;

dump = [];

end


function [exitCode, dump] = runTrial_PILOT3(paramSetRow)

disp('rendering the stimulus ...');

args = struct;

if paramSetRow(1) == 0
    
    args.bugW = 1;
    args.bugH = 1;
    
else
    
    args.bugW = 80;
    args.bugH = 80;
    
end

args.blockSize = paramSetRow(2);

args.duration = 3/5 * 2 * pi * 4;

args.escapeEnabled = 0;

args.preTrialDelay = 15;

if paramSetRow(1) == 2
    
    args.chequerR = 0;
    
end

runSlidingBars(args);

exitCode = 0;

dump = [];

end


function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

args = struct;

args.bugW = 1 + paramSetRow(1) * 79;
args.bugH = 1 + paramSetRow(1) * 79;

args.blockSize = paramSetRow(2);

args.duration = 3/5 * 2 * pi * 4;

args.escapeEnabled = 0;

args.preTrialDelay = 15;

runSlidingBars(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial_PILOT3(varargin)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades/sways      : ', checkPositive);

optomotor   = getNumber('Number of optomotor responses : ', checkPositive);

tracking    = getNumber('Number of tracking responses  : ', checkPositive);

peering     = getNumber('Peering   (0=no, 1=yes)       ? ', checkBinary);

strike      = getNumber('Number of strikes             : ', checkPositive);

resultRow = [numSaccades optomotor tracking peering strike];

end

function resultRow = runAfterTrial(varargin)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades/sways: ', checkPositive);

optomotor   = getNumber('Optomotor (0=no, 1=yes)? ', checkBinary);

tracking    = getNumber('Tracking  (0=no, 1=yes)? ', checkBinary);

peering     = getNumber('Peering   (0=no, 1=yes)? ', checkBinary);

strike      = getNumber('Strike    (0=no, 1=yes)? ', checkBinary);

resultRow = [numSaccades optomotor tracking peering strike];

end

function runAlignmentStimulus_internal(enable3D, x, y)

if nargin<1
    enable3D = 0;
end

if nargin<3
    x = 0;
    y = 350;
end

% render alignment stimulus

expt = struct;

expt.interactiveMode = 1;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.enable3D = enable3D;

expt.disparity = 0;

expt.M = 32;

expt.R = 0.5;
% 
% expt.blackLum = 0;
% 
% expt.whiteLum = 128;

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

expt.bugVisible = 0;

expt.timeLimit = 0;

expt.interactiveMode = 1;

expt.enable3D = enable3D;

expt.enableChequers = 0;

expt.enableChequers = 0;

disp('alignment mode (interactive), press Escape when mantis is aligned ...');

runAnimation2(expt);

end
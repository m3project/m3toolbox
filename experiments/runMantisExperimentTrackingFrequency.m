function runMantisExperimentTrackingFrequency()

expt = struct;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.genParamSetFun = @genParamSet_PILOT1;

expt.runTrialFun = @runTrial_PILOT1;

expt.runAfterTrialFun = @runAfterTrial_PILOT1;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisTrackFrequency\';

expt.name = 'Mantis Track Frequency';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Lisa';

expt.addTags = {'PILOT1'};

runExperiment(expt);

end

function paramSet = genParamSet_PILOT1()

blocks = 5;

% each row in conds is `bug side (px), freq (cyc/px)`

bugFreqs = [1/40 1/20]; % cyc/px

bugTypes = [0 1]; % 0 for black, 1 for sin

bugSizes = [120 200]; % width (px)

paramSet = createRandTrialBlocks(blocks, bugFreqs, bugTypes, bugSizes);

end

function [exitCode, dump] = runTrial_PILOT1(paramSetRow)

disp('rendering the stimulus ...');

args = struct;

args.fx = paramSetRow(1);

args.bugType = paramSetRow(2);

args.W = paramSetRow(3);

args.escapeEnabled = 0;

runBugPatternLisa(args);

exitCode = 0;

dump = [];

end

function runBeforeExpt()

Gamma = 2.783; % this is for Lisa's Phillips 107b3

createWindow(Gamma);

end

function runBeforeTrial(~)

runAlignmentStimulus_internal(0, 0, 0);

end

function resultRow = runAfterTrial_PILOT1(varargin)

delay = 0; % inter-trial delay (seconds)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades/sways: ', checkPositive);

peering     = getNumber('Peering   (0=no, 1=yes)       ? ', checkBinary);

strike      = getNumber('Number of strikes             : ', checkPositive);

resultRow = [numSaccades peering strike];

sprintf('pausing for %i seconds ...\n', delay);

pause(delay);

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
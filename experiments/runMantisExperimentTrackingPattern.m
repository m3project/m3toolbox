function runMantisExperimentTrackingPattern()

expt = struct;

expt.genParamSetFun = @genParamSet2;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial2;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisTrackPattern\';

expt.name = 'Mantis Track Pattern';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Lisa';

expt.addTags = {'CAMO', 'VAR2'};

runExperiment(expt);

end

function paramSet = genParamSet2()

blocks = 5;

bugBlockSizes = [0 5 10 20]; % note: 0 is special code for black bug

backBlockSizes = [0 5 10 20]; % note: 0 is special code for gray background

paramSet = createRandTrialBlocks(blocks, bugBlockSizes, backBlockSizes);

% adding random seeds for bug and background pattern generation

n = size(paramSet, 1);

rseeds = randi(1e6, [n 2]);

paramSet = [paramSet rseeds];

end

function paramSet = genParamSet()

blocks = 10;

dirs = 1;

spatialFreqsCPPX = 1 ./ power(2, 1:6);

spatialFreqsCPPX = [-1 -2 spatialFreqsCPPX];

% note:
% -1 is a code for a black bug
% -2 is a code for a base luminance (gray) bug

paramSet = createRandTrialBlocks(blocks, dirs, spatialFreqsCPPX);

end

function runBeforeTrial(~)

Gamma = 2.783; % this is for Lisa's Phillips 107b3

createWindow(Gamma);

runAlignmentStimulus_internal(0, 0, 0);

end

function [exitCode, dump] = runTrial2(paramSetRow)

disp('rendering the stimulus ...');

args = struct;

bugBlockSize = paramSetRow(1);

backBlockSize = paramSetRow(2);

if bugBlockSize == 0
    
    args.bugType = 5;
    
else
    
    args.bugType = 4;
    
    args.bugBlockSize = bugBlockSize;
    
end

if backBlockSize == 0
    
    args.backBlockSize = 100;
    
    args.backBlockContrast = 0;
    
else
    
    args.backBlockSize = backBlockSize;
    
end

args.escapeEnabled = 0;

args.duration = 25;

args.initDelay = 15;

args.bugSeed = paramSetRow(3);

args.backSeed = paramSetRow(4);

runBugPattern(args);

% clearWindow([1 1 1]*128);

exitCode = 0;

dump = [];

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

args = struct;

args.dir = paramSetRow(1);

if paramSetRow(2) == -1
    
    args.Fx = 1/32;
    
    args.baseLum = 0;
    
    args.contrast = 0;
    
elseif paramSetRow(2) == -2
    
    args.Fx = 1/32;
    
    args.baseLum = 0.5;
    
    args.contrast = 0;
    
else

    args.Fx = paramSetRow(2);

end

args.escapeEnabled = 0;

if args.Fx == 1
    
    % special code for black bug
    
    args.baseLum = 0;
    
end

args.duration = 10;

runBugPattern(args);

clearWindow([1 1 1]*128);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

delay = 0; % inter-trial delay (seconds)

checkPositive = @(str) str2double(str) >= 0;

numSaccades = getNumber('Number of saccades/sways: ', checkPositive);

response = getTrackResponseJudgement();

resultRow = [numSaccades response];

sprintf('pausing for %i seconds ...\n', delay);

pause(delay);

end

function response = getTrackResponseJudgement()

c = 'x';

letters = ['n' 't' 's' 'p' 'a' 'o'];

while (length(c) ~= 1 || ismember(c, letters) ~= 1)
    
    c = input('None(n), Track(t), Strike (s), Peer (p), Attention (a) or Other (o)? ', 's');
    
end

response = strfind(letters, c);

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
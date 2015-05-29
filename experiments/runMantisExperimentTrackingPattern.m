function runMantisExperimentTrackingPattern()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisTrackPattern\';

expt.name = 'Mantis Track Pattern';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Lisa';

expt.addTags = {'HORZ'};

runExperiment(expt);

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

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

checkPositive = @(str) str2double(str) >= 0;

numSaccades = getNumber('Number of saccades/sways: ', checkPositive);

response = getTrackResponseJudgement();

resultRow = [numSaccades response];

disp('pausing for 15 seconds ...');

pause(15);

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
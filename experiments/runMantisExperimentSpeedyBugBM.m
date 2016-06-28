function runMantisExperimentSpeedyBugBM()

expt = struct;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.genParamSetFun = @genParamSet_BM1;

expt.runTrialFun = @runTrial_BM1;

expt.runAfterTrialFun = @runAfterTrial_BM1;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisSpeedyBugBM';

expt.name = 'Mantis Speedy Bug (BM1)';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Eugenia';

runExperiment(expt);

end

%% BM1

function [exitCode, dump] = runTrial_BM1(paramSetRow)

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), ...
    'bugDelay', bugDelay, 'escapeEnabled', 0, ...
    'backBaseLum', 0.5, 'bugSpeed', paramSetRow(3));

bugType = paramSetRow(2);

backType = paramSetRow(4);

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 4 : stripy bug, 2W
% 5 : stripy bug, 4W

if bugType == 0
    
    args.m = 0;
    
    args.bugBaseLum = 0;
    
elseif bugType == 1
    
    args.m = 0;
    
    args.bugBaseLum = 0.5;
    
elseif bugType == 5
    
    args.m = 4;
    
elseif bugType == 4
    
    args.m = 2;
    
elseif bugType == 2
    
    args.m = -1;
    
else
    
    error('invalid bugType');
    
end

% backType

if backType == 0
    
    args.useNatBack = 0;
    
elseif backType == 1
    
    args.useNatBack = 1;
    
else
    
    error('invalid backType');
    
end

runBugPatternDianaNat(args);

exitCode = 0;

dump = [];

end


function resultRow = runAfterTrial_BM1(varargin)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades/sways      : ', checkPositive);

% optomotor   = getNumber('Number of optomotor responses : ', checkPositive);

tracking    = getNumber('Tracking   (0=no, 1=yes)      : ', checkPositive);

peering     = getNumber('Peering   (0=no, 1=yes)       ? ', checkBinary);

strike      = getNumber('Number of strikes             : ', checkPositive);

resultRow = [numSaccades tracking peering strike];

end

function paramSet = genParamSet_BM1()

blocks = 5;

dirs = [-1 1]; % direction

bugType = [0 1 2 4 5];

bugSpeed = [37 74 145];

backType = 1; % add other background types if needed, for example: [0 1]

% bgType:
% 1 : 1/f background

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : matching background
% 4 : stripy bug, 2W
% 5 : stripy bug, 4W

paramSet = createRandTrialBlocks(blocks, dirs, bugType, bugSpeed, backType);

end

%% Others

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

expt.M = 40;

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

expt.enableChequers = 1;

disp('alignment mode (interactive), press Escape when mantis is aligned ...');

runAnimation2(expt);

end


function y = getAlignmentKey()

% checking for key presses

while 1
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('Escape')))
        
        y = 0; break;        
        
    end
    
    if (keyCode(KbName('k')))
        
        y = 1; break;       
        
    end
    
end


end

function runBeforeExpt()

%Gamma = 2.783; % this is for Lisa's Phillips 107b3

% Gamma = 1.3476; % for the monitor used in the mantis CSF experiment

% Gamma = 1.7; % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 2nd of Nov 2015

Gamma = 2.0;  % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 17nd of Nov 2015

createWindow(Gamma);

clearWindow([1 1 1] * 0.6);

end


function runBeforeTrial(~)

KbName('UnifyKeyNames');

disp('Press (k) to launch alignment stimulus or (Escape) to continue to trial ...');

clearWindow([1 1 1] * 0.6, 0);

% runAlignStim = (GetKbChar == 'k');

runAlignStim = getAlignmentKey();

if runAlignStim

    runAlignmentStimulus_internal(0, 0, 0);

end

clearWindow([1 1 1] * 0.6, 0);

end
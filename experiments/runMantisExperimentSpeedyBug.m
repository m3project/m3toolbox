function runMantisExperimentSpeedyBug()

expt = struct;

expt.genParamSetFun = @genParamSetPILOT4;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrialPILOT4;

expt.runAfterTrialFun = @runAfterTrial;

expt.runBeforeExptFun = @runBeforeExpt;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisSpeedyBug';

expt.name = 'Mantis Speedy Bug';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Diana';

expt.addTags = {'PILOT4'};

runExperiment(expt);

end

function paramSet = genParamSetPILOT4()

blocks = 5;

dirs = [-1 1]; % direction

bugSpeed = [50 200]; % deg/sec

bugType = [0 1 2 3 4];

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : background-matching bug, a patch cut out of 1/f pattern
% 3 : stripy bug, 8W
% 4 : stripy bug, 2W

paramSet = createRandTrialBlocks(blocks, dirs, bugSpeed, bugType);

end

function paramSet = genParamSetPILOT3()

blocks = 5;

dirs = [-1 1]; % direction

bugSpeed = [50 200]; % deg/sec

bugType = [0 1 2 3];

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : background-matching bug, a patch cut out of 1/f pattern
% 3 : stripy bug, 8W

paramSet = createRandTrialBlocks(blocks, dirs, bugSpeed, bugType);

end

function paramSet = genParamSetPILOT2() %#ok

blocks = 5;

dirs = [-1 1]; % direction

bugSpeed = [50 200]; % deg/sec

bugType = [0 2 4]; % spatial frequency

paramSet = createRandTrialBlocks(blocks, dirs, bugSpeed, bugType);

end

function paramSet = genParamSet() %#ok

% this is for PILOT1

blocks = 5;

dirs = [-1 1]; % direction

bugSpeed = [50 200]; % deg/sec

bugType = [0 2 4];

paramSet = createRandTrialBlocks(blocks, dirs, bugSpeed, bugType);

end

function runBeforeExpt()

%Gamma = 2.783; % this is for Lisa's Phillips 107b3

% Gamma = 1.3476; % for the monitor used in the mantis CSF experiment

% Gamma = 1.7; % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 2nd of Nov 2015

Gamma = 2.0;  % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 17nd of Nov 2015

createWindow(Gamma);

end

function runBeforeTrial(~)

KbName('UnifyKeyNames');

disp('Press (k) to launch alignment stimulus or (Escape) to continue to trial ...');

clearWindow([1 1 1] * 0.5, 0);

% runAlignStim = (GetKbChar == 'k');

runAlignStim = getAlignmentKey();

if runAlignStim

    runAlignmentStimulus_internal(0, 0, 0);

end

clearWindow([1 1 1] * 0.5, 0);

end

function [exitCode, dump] = runTrial(paramSetRow) %#ok

% PILOT1

disp('rendering the stimulus ...');

args = struct('dir', paramSetRow(1), 'bugSpeed', paramSetRow(2), ...
    'm', paramSetRow(3), 'escapeEnabled', 0);

pause(15); % wait for 15 seconds

runBugPatternDiana(args);

exitCode = 0;

dump = [];

end


function [exitCode, dump] = runTrialPILOT4(paramSetRow)

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), 'bugSpeed', paramSetRow(2), ...
    'bugDelay', bugDelay, 'escapeEnabled', 0);

bugType = paramSetRow(3);

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : background-matching bug, a patch cut out of 1/f pattern
% 3 : stripy bug, 8W
% 4 : stripy bug, 2W

if bugType == 0
    
    args.m = 0;
    
    args.bugBaseLum = 0;
    
elseif bugType == 1
    
    args.m = 0;
    
    args.bugBaseLum = 0.5;
    
elseif bugType == 2
    
    args.m = -1;
    
elseif bugType == 3
    
    args.m = 8;
    
elseif bugType == 4
    
    args.m = 2;
    
else
    
    error('invalid bugType');
    
end

runBugPatternDianaNat(args);

exitCode = 0;

dump = [];

end

function [exitCode, dump] = runTrialPILOT3(paramSetRow)

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), 'bugSpeed', paramSetRow(2), ...
    'bugDelay', bugDelay, 'escapeEnabled', 0);

bugType = paramSetRow(3);

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : background-matching bug, a patch cut out of 1/f pattern
% 3 : stripy bug, 8W

if bugType == 0
    
    args.m = 0;
    
    args.bugBaseLum = 0;
    
elseif bugType == 1
    
    args.m = 0;
    
    args.bugBaseLum = 0.5;
    
elseif bugType == 2
    
    args.m = -1;
    
elseif bugType == 3
    
    args.m = 8;
    
else
    
    error('invalid bugType');
    
end

runBugPatternDianaNat(args);

exitCode = 0;

dump = [];

end

function [exitCode, dump] = runTrialPILOT2(paramSetRow)

disp('rendering the stimulus ...');

args = struct('dir', paramSetRow(1), 'bugSpeed', paramSetRow(2), ...
    'm', paramSetRow(3), 'escapeEnabled', 0, 'bugBaseLum', 0.2, ...
    'bugLumAmp', 0.2);

pause(15); % wait for 15 seconds

runBugPatternDiana(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades/sways      : ', checkPositive);

optomotor   = getNumber('Number of optomotor responses : ', checkPositive);

tracking    = getNumber('Number of tracking responses  : ', checkPositive);

peering     = getNumber('Peering   (0=no, 1=yes)       ? ', checkBinary);

strike      = getNumber('Number of strikes             : ', checkPositive);

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
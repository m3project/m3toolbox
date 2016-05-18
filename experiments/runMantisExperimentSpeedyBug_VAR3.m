function runMantisExperimentSpeedyBug_VAR3()

expt = struct;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.genParamSetFun = @genParamSet_VAR3;

expt.runTrialFun = @runTrial_VAR3;

expt.runAfterTrialFun = @runAfterTrial_VAR3;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisSpeedyBugVAR3';

expt.name = 'Mantis Speedy Bug (VAR3)';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Joe';

expt.addTags = {'VAR3'};

runExperiment(expt);

end

%% VAR3

function paramSet = genParamSet_VAR3()

blocks = 6;

dirs = [-1 1]; % direction

bugSpeed = [74 145 290];

paramSet = createRandTrialBlocks(blocks, dirs, bugSpeed);

end

function resultRow = runAfterTrial_VAR3(varargin)

resultRow = runAfterTrial_PILOT5(varargin);

end

function runTrial_VAR3(paramSetRow)

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), ...
    'bugDelay', bugDelay, 'escapeEnabled', 0, ...
    'backBaseLum', 0.5, 'bugSpeed', paramSetRow(2));

args.m = 0;

args.bugBaseLum = 0;

args.useNatBack = 0;

args.sr = 40;

runBugPatternDianaNat(args);

end

%% VAR1

function [exitCode, dump] = runTrial_VAR1(paramSetRow) %#ok<DEFNU>

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


function resultRow = runAfterTrial_VAR1(varargin) %#ok<DEFNU>

resultRow = runAfterTrial_PILOT5(varargin);

end

function paramSet = genParamSet_VAR1() %#ok<DEFNU>

blocks = 2;

dirs = [-1 1]; % direction

bugType = [0 1 4 5];

bugSpeed = [74 145 290];

backType = [0 1];

% bgType:
% 0 : gray background with luminance of 0.5
% 1 : 1/f background

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 4 : stripy bug, 2W
% 5 : stripy bug, 4W

paramSet = createRandTrialBlocks(blocks, dirs, bugType, bugSpeed, backType);

end

%% Others

function [exitCode, dump] = runTrial_PILOT7(paramSetRow) %#ok<DEFNU>

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), 'useNatBack', 0, ...
    'bugDelay', bugDelay, 'escapeEnabled', 0, ...
    'backBaseLum', 0.6, 'bugSpeed', paramSetRow(3));

bugType = paramSetRow(2);

% bugType:
% 1 : gray  bug, uniform luminance 0.5
% 3 : stripy bug, 8W
% 4 : stripy bug, 2W

if bugType == 0
    
    args.m = 0;
    
    args.bugBaseLum = 0;
    
elseif bugType == 1
    
    args.m = 0;
    
    args.bugBaseLum = 0.5;
    
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

function paramSet = genParamSet_PILOT7() %#ok<DEFNU>

blocks = 5;

dirs = [-1 1]; % direction

bugType = [0 1 3 4];

bugSpeed = [74 145];

% bgType:
% 0 : gray background with luminance of 0.4

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : background-matching bug, a patch cut out of 1/f pattern
% 3 : stripy bug, 8W
% 4 : stripy bug, 2W

paramSet = createRandTrialBlocks(blocks, dirs, bugType, bugSpeed);

end

function paramSet = genParamSetPILOT6() %#ok<DEFNU>

paramSet = genParamSetPILOT5();

end


function paramSet = genParamSetPILOT5()

blocks = 5;

dirs = [-1 1]; % direction

bugType = [0 1 3 4];

bgType = [0 1];

% bgType:
% 0 : gray background with luminance of 0.5
% 1 : patterned background

% bugType:
% 0 : black bug, uniform luminance 0
% 1 : gray  bug, uniform luminance 0.5
% 2 : background-matching bug, a patch cut out of 1/f pattern
% 3 : stripy bug, 8W
% 4 : stripy bug, 2W

paramSet = createRandTrialBlocks(blocks, dirs, bgType, bugType);

end

function paramSet = genParamSetPILOT4() %#ok<DEFNU>

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

function paramSet = genParamSetPILOT3() %#ok<DEFNU>

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


function [exitCode, dump] = runTrialPILOT6(paramSetRow) %#ok<DEFNU>

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), 'useNatBack', paramSetRow(2), ...
    'bugDelay', bugDelay, 'escapeEnabled', 0, 'bugSpeed', 74);

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


function [exitCode, dump] = runTrialPILOT5(paramSetRow) %#ok<DEFNU>

% NB: bugSpeed put here is assuming viewD=7. I changed this back to the
% correct viewD=2.5 on 18/1/2016 so while bugSpeed=50 here really
% corresponds to bugSpeed=140, in runTrialPILOT6 onwards bugSpeed
% represents actual bug speed

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), 'useNatBack', paramSetRow(2), ...
    'bugDelay', bugDelay, 'escapeEnabled', 0, 'bugSpeed', 50);

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


function [exitCode, dump] = runTrialPILOT4(paramSetRow) %#ok<DEFNU>

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

function [exitCode, dump] = runTrialPILOT3(paramSetRow) %#ok<DEFNU>

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

function [exitCode, dump] = runTrialPILOT2(paramSetRow) %#ok<DEFNU>

disp('rendering the stimulus ...');

args = struct('dir', paramSetRow(1), 'bugSpeed', paramSetRow(2), ...
    'm', paramSetRow(3), 'escapeEnabled', 0, 'bugBaseLum', 0.2, ...
    'bugLumAmp', 0.2);

pause(15); % wait for 15 seconds

runBugPatternDiana(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial_PILOT7(varargin) %#ok<DEFNU>

resultRow = runAfterTrial_PILOT5(varargin);

end


function resultRow = runAfterTrial_PILOT6(varargin) %#ok<DEFNU>

resultRow = runAfterTrial_PILOT5(varargin);

end

function resultRow = runAfterTrial_PILOT5(varargin)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades/sways      : ', checkPositive);

% optomotor   = getNumber('Number of optomotor responses : ', checkPositive);

tracking    = getNumber('Tracking   (0=no, 1=yes)      : ', checkPositive);

peering     = getNumber('Peering   (0=no, 1=yes)       ? ', checkBinary);

strike      = getNumber('Number of strikes             : ', checkPositive);

resultRow = [numSaccades tracking peering strike];

end

function resultRow = runAfterTrial(varargin) %#ok<DEFNU>

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
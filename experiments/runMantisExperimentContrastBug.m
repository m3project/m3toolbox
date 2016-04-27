function runMantisExperimentContrastBug()

expt = struct;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.genParamSetFun = @genParamSet_VAR2;

expt.runTrialFun = @runTrial_VAR1;

expt.runAfterTrialFun = @runAfterTrial_VAR1;

expt.workDir = 'X:\readlab\Ghaith\m3\data\mantisContrastBug'; % corrected by Diana on 25/04/16 

expt.name = 'Mantis Contrast Bug';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Alice';

expt.addTags = {'VAR2'}; % add a tag here to indicate changes in condition

runExperiment(expt);

end

%% VAR2

% VAR2 was corrected by Ghaith on 14/4/2016 (2am)

function paramSet = genParamSet_VAR2()

blocks = 3;

dirs = [-1 1]; % direction

bugLum = [0 0.05:0.05:0.5]; % bug luminance conditions,  Diana changed this on the 13/04/16

paramSet = createRandTrialBlocks(blocks, dirs, bugLum);

end

%% VAR1

function paramSet = genParamSet_VAR1() %#ok<DEFNU>

blocks = 3;

dirs = [-1 1]; % direction

bugLum = [0 0.3:0.02:0.5]; % bug luminance conditions (note to Diana: change this if needed

paramSet = createRandTrialBlocks(blocks, dirs, bugLum);

end

function [exitCode, dump] = runTrial_VAR1(paramSetRow)

disp('rendering the stimulus ...');

bugDelay = 15; % seconds (before bug moves across the screen)

args = struct('dir', paramSetRow(1), 'useNatBack', 0, ...
    'bugDelay', bugDelay, 'escapeEnabled', 0, ...
    'backBaseLum', 0.5, 'bugSpeed', 74, ...
    'm', 0, 'bugBaseLum', paramSetRow(2));

% note on bug px dimensions:
%
% Alice's monitor (Compaq P1210) has a resolution of 47.2 px/cm
% viewable diameter according to specs is 50.8 cm
% diameter in pixels is sqrt(1920^2 + 1440^2)
%
% http://www.cnet.com/products/compaq-p1210-crt-monitor-22-series/specs/
%
% so to match physical bug size in Diana's experiments (1.6 x 0.75 cm),
% Alice's bug must be 96x53 pixels

args.W = 76;
args.H = 35;

runBugPatternDianaNat(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial_VAR1(varargin)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

numSaccades = getNumber('Number of saccades              : ', checkPositive);

numStrikes  = getNumber('Number of strikes               : ', checkPositive);

peering     = getNumber('Peering (1=yes, 0=no)           ? ', checkBinary);

approach    = getNumber('Approach screen (1=yes, 0=no)   ? ', checkBinary);

extension   = getNumber('Foreleg extension (1=yes, 0=no) ? ', checkBinary);

resultRow = [numSaccades numStrikes peering approach extension];

end

%% General

function clearWindow_wrapper()

clearWindow([1 1 1] * 0.5);

end

function runBeforeExpt()

%Gamma = 2.783; % this is for Lisa's Phillips 107b3

% Gamma = 1.3476; % for the monitor used in the mantis CSF experiment

% Gamma = 1.7; % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 2nd of Nov 2015

% Gamma = 2.0;  % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 17nd of Nov 2015

Gamma = 1.65; % this is for Compaq P1210 (Alice's setup) - measured with Diana and Aluce on 9th March 2016

createWindow(Gamma);

clearWindow_wrapper();

end

function runBeforeTrial(~)

KbName('UnifyKeyNames');

disp('Press (k) to launch alignment stimulus or (Escape) to continue to trial ...');

clearWindow_wrapper();

% runAlignStim = (GetKbChar == 'k');

runAlignStim = getAlignmentKey();

if runAlignStim

    runAlignmentStimulus_internal(0, 0, 0);

end

clearWindow_wrapper();

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
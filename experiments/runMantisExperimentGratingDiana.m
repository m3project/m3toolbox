function runMantisExperimentGratingDiana()

expt = struct;

expt.runChecksFun = @runChecks;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.genParamSetFun = @genParamSet_VAR3;

expt.runTrialFun = @runTrial_VAR3;

expt.runAfterTrialFun = @runAfterTrial_VAR3;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisGratingDiana';

expt.name = 'Mantis Grating Diana';

expt.defName = 'Diana';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {'VAR3'};

runExperiment(expt);

end

%% VAR3

function paramSet = genParamSet_VAR3()

% each row of tab0 is sf (cpd), speed (deg/sec), sf (cppx)

tab0 = [
    0.05	    74      2/64
    0.05		145     2/64
    0.05		290     2/64
    0.1         74      4/64
    0.1         145     4/64
    0.1         290     4/64
    0.2     	74      8/64
    0.2         145     8/64
    0.2         290     8/64
    ];

dirs = [-1 1];

bugSpeedPxSec = getSpeedPxSec(tab0(:, 2));

bugSf = tab0(:, 3);

conds = [bugSf bugSpeedPxSec];

nconds = size(conds, 1);

blocks = 5;

pSet = createRandTrialBlocks(blocks, 1:nconds, dirs);

% each row of paramSet is:
% sf : cppx
% speed : px/sec

paramSet = [conds(pSet(:, 1), :) pSet(:, 2)];

end

function [exitCode, dump] = runTrial_VAR3(paramSetRow)

disp('rendering the stimulus');

sf = paramSetRow(1);

speed = paramSetRow(2);

dir = paramSetRow(3);

square = @(x) sign(cos(x)); % square function

args = struct('dir', dir, 'escapeEnabled', 0, 'gratingFunc', square);

runGrating_ver2_wrapper(sf, speed, args);

exitCode = 0; dump = [];

end

function runGrating_ver2_wrapper(sf, speed, args)

% sf is in cppx
% speed is in px/sec

args.tf = sf * speed;
args.sf = sf;

runGrating_ver2(args);

end

function bugSpeedPxSec = getSpeedPxSec(bugSpeedDegSec)

sr = 40; % px/cm

viewD = 2.5; % viewing distance (cm)

deg_per_px = range(px2deg(2, sr, viewD)) / 2; % averaged over two pixels

bugSpeedPxSec = bugSpeedDegSec / deg_per_px;

end

%% supplementary funcs

function resultRow = runAfterTrial_VAR3(varargin)

resultRow = getDirectionJudgement();

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

%% Others

function paramSet = genParamSet() %#ok<DEFNU>

% Important: make sure Gamma value in runTrial is correct

startFreq = 0.1; % cpd

endFreq = 0.9; % cpd

numFreqs = 10;

freqs = logspace2(startFreq, endFreq, numFreqs);

freqs = [0 freqs];

blocks = 10;

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, freqs, dirs);

end

function errorCode = runChecks()

errorCode = 0;

% check resolution

[sW, sH] = getResolution();

if ~isequal([sW sH], [1920 1200])
    
    warning('this experiment was designed for a screen size of 1600 x 1200 px');
    
    errorCode = 1;
    
end

end

function runBeforeExpt()

% apply Gamma correction

Gamma = 2.0;  % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 17nd of Nov 2015

createWindow(Gamma);

end

function [exitCode, dump] = runTrial(paramSetRow) %#ok<DEFNU>

viewD = 7; % viewing distance (cm)

sf = 37; % monitor resolution (px/cm)

contrast = 1;

disp('rendering the stimulus');

spatialFreq = paramSetRow(1);

if spatialFreq == 0
    
    % special code for gray screeb
    
    contrast = 0;
    
end

args = struct('duration', 5, 'contrast', contrast, ...
    'signalFreq', paramSetRow(1), 'freqRange', [1 1] * 0, ...
    'dir', paramSetRow(2), 'makePlot', 0, 'rms', 0, ...
    'escapeEnabled', 0, 'apertureDeg', 1, 'useAperture', 0, ...
    'viewD', viewD, 'screenReso', sf, 'temporalFreq', 8);

runGratingWarped(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin) %#ok<DEFNU>

resultRow = getObserverResponse();

end

function runAlignmentStimulusNoBack() %#ok<DEFNU>

% coordinates of bug swirling center:

x = 0;

y = 0;

% render alignment stimulus

expt = struct;

expt.interactiveMode = 1;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.enable3D = 0;

expt.disparity = 0;

expt.M = 40;

expt.R = 1;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) 0;

expt.stepDX = 0;

expt.bugFrames = getBugFrames('fly');

expt.motionFuncs = getSwirl(x, y);

expt.nominalSize = 0.25; % change bug size here

expt.bugVisible = 1;

expt.txtCount = 50;

expt.bugVisible = 1;

expt.timeLimit = 0;

expt.interactiveMode = 1;

disp('alignment mode (interactive), press Escape when mantis is aligned ...');

runAnimation2(expt);

end

function motionFuncs = getSwirl(varargin)

centerX = 0;

centerY = 350; % change bug y position

if nargin>1
    
    % if any additional arguments are supplied for 'swirl', they'll
    % be assumed as override values for centerX and centerY:
    
    centerX = varargin{1};
    centerY = varargin{2};
    
end

theta1 = @(t) (t * 2 * pi);

theta2 = @(t) (min(4, t) * 2 * pi);

motionR = @(t) 200 * (cos(theta2(t) * 0.1)+1);

v = 1.5; % change bug speed

X = @(t) centerX + cos(theta1(t) * v) * motionR(t);

Y = @(t) centerY + sin(theta1(t) * v) * motionR(t);

t1 = @(t) t;

motionFuncs.XY      = @(t) [X(t1(t)) Y(t1(t))];
motionFuncs.Angle   = @(t) 270 - (t1(t) * v * 360);
motionFuncs.F       = @(t) t1(t) * 60;
motionFuncs.S       = @(t) 1;

end

function key = getObserverResponse()

% checking for key presses

disp('Press (Left, Right) to indicate mantid viewing direction');
disp('Press (Up) to indicate mantis did not move');
disp('Press (p) to indicate mantis was peering');

pause(0.1);

while (1)
    
    drawnow
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('LeftArrow')))
        
        key = -1; break;
        
    end
    
    if (keyCode(KbName('RightArrow')))
        
        key = 1; break;
        
    end
    
    if (keyCode(KbName('UpArrow')))
        
        key = 0; break;
        
    end
    
    if (keyCode(KbName('p')))
        
        key = 2; break;
        
    end    
    
end

end
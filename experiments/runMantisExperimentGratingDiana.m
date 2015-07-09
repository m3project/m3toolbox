function runMantisExperimentGratingDiana()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runChecksFun = @runChecks;

expt.workDir = 'D:\mantisGratingDiana';

expt.name = 'Mantis Grating Diana';

expt.defName = 'Diana';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {};

runExperiment(expt);

end

function paramSet = genParamSet()

% Important: make sure Gamma value in runTrial is correct

startFreq = 0.1; % cpd

endFreq = 0.9; % cpd

numFreqs = 10;

freqs = logspace2(startFreq, endFreq, numFreqs);

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

Gamma = 2.1942; % Dell monitor in Thomas's setup

createWindow(Gamma);

end

function runBeforeTrial(varargin)

runAlignmentStimulusNoBack();

end

function [exitCode, dump] = runTrial(paramSetRow)

viewD = 7; % viewing distance (cm)

sf = 37; % monitor resolution (px/cm)

disp('rendering the stimulus');

args = struct('duration', 5, 'contrast', 1, ...
    'signalFreq', paramSetRow(1), 'freqRange', [1 1] * 0, ...
    'dir', paramSetRow(2), 'makePlot', 0, 'rms', 0, ...
    'escapeEnabled', 0, 'apertureDeg', 1, 'useAperture', 0, ...
    'viewD', viewD, 'screenReso', sf, 'temporalFreq', 8);

runGratingWarped(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end


function runAlignmentStimulusNoBack()

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
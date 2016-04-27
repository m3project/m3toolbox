function runMantisExperimentMaskingWarpedDeltaNoise()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runChecksFun = @runChecks;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisGratingWarpedDeltaNoise\';

expt.name = 'Mantis Masking Warped Delta Noise';

expt.defName = 'Will';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {'VAR2'};

runExperiment(expt);

end

function paramSet = genParamSet()

% Important: make sure Gamma value in runTrial is correct

blocks = 5;

contrasts = [0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5];

signalFreqs = getIgnacioFreqs();

% noiseFreqs = 0;

noiseFreqs = [getIgnacioFreqs() 0]; % for the next round of the
% experiment

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, contrasts, signalFreqs, ...
    noiseFreqs, dirs);

end

function errorCode = runChecks()

errorCode = 0;

% check resolution

[sW, sH] = getResolution();

if ~isequal([sW sH], [1600 1200])
    
    warning('this experiment was designed for a screen size of 1600 x 1200 px');
    
    errorCode = 1;
    
end

end

function runBeforeExpt()

% apply Gamma correction

Gamma = 1.3476;

createWindow(Gamma);

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

rms = 0.14; % same rms as masking experiment

apertureDeg = 28.28 * 3;

viewD = 7; % viewing distance (cm)

screenReso = 40; % monitor resolution (px/cm)

noiseFreq = paramSetRow(3);

if noiseFreq == 0
    
    % special code for no noise condition
    
    rms = 0;
    
end

disp('rendering the stimulus');

args = struct('duration', 5, 'contrast', paramSetRow(1), ...
    'signalFreq', paramSetRow(2), 'freqRange', [1 1] * paramSetRow(3), ...
    'dir', paramSetRow(4), 'makePlot', 0, 'rms', rms, ...
    'escapeEnabled', 0, 'apertureDeg', apertureDeg, 'useAperture', 1, ...
    'viewD', viewD, 'screenReso', screenReso, 'temporalFreq', 8);

runGratingWarped(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end

function freqs = getIgnacioFreqs()

% calculations:

% we need to render two gratings with spatial periods equal to those of
% Ignacio's 0.04 and 0.2 cpds *at the center of the screen*

% I've worked out the periods of Ignacio's frequencies (by running his
% script and inspecting the generated gratings) and found the following

% 0.04 cpd -> 266.6 px
% 0.20 cpd ->  55.2 px

% now I calculate the angle (alpha) subtended by a single px at the centre
% of the screen

alpha = range(px2deg(2,40,7))/2; % Ignacio is happy with this

% using alpha I calculate the deg spatial periods of Ignacio's 0.04 and 0.2
% cpds as follows

degs = [266.6 55.2] * alpha;

freqs = 1./degs;

% right, so now when I use freqs(1) and freqs(2) to generate the warped
% gratings I will get px periods that are almost equal to Ignacio's 0.04
% and 0.2 cpds *at the screen center*

end
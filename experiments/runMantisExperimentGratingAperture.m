function runMantisExperimentGratingAperture()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisGratingAperture\';

expt.name = 'Mantis Grating Aperture';

expt.defName = 'Steven';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {'0.05 CONTRAST'};

checkResolution();

runExperiment(expt);

end

function checkResolution()

[sW, sH] = getResolution();

if ~isequal([sW sH], [1600 1200])
    
    error('this experiment was designed for a screen size of 1600 x 1200 px');
    
end

end

function paramSet = genParamSet()

% Important: make sure Gamma value in runTrial is correct

blocks = 15;

apertureSizeDegs = (1:5) * 28.28;

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, apertureSizeDegs, dirs);

end

function Gamma = getGamma()

Gamma = 1.3476;

end

function runBeforeTrial(varargin)

createWindow(getGamma());

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

args = struct('duration', 5, 'apertureDeg', paramSetRow(1), ...
    'dir', paramSetRow(2), 'Gamma', getGamma(), 'flipAperture', 0, ...
    'spatialFreq', 1/53, 'contrast', 0.05);

runGratingAperture(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
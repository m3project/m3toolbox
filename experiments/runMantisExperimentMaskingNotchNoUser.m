function runMantisExperimentMaskingNotchNoUser()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisMaskingNotch\';

expt.name = 'Mantis Masking Notch';

expt.defName = 'Will';

expt.recordVideos = 0;

expt.makeBackup = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 5;

spatialFreqs = [0.04 0.2];

octaveSetting = 1:7;

contrast = [0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5];

paramSet = createRandTrialBlocks(blocks, spatialFreqs, octaveSetting, contrast);

% generating random directions vector

n = size(paramSet, 1);

v = ones(n/2, 1);

dirs = [v; -v];

rdirs = dirs(randperm(n));

% adding directions vector to paramSet

paramSet = [paramSet rdirs];

end

function runBeforeTrial(varargin)

runAlignmentStimulus(); %here is where esc is pressed to leave alignment

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

expt.spatialFreq = paramSetRow(1);

expt.octaveSetting = paramSetRow(2);

expt.contrast = paramSetRow(3);

expt.direction = paramSetRow(4);

expt.duration = 5;

[dump] = runGratingNoiseNotch(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

%resultRow = getDirectionJudgement();
resultRow = 0;

end
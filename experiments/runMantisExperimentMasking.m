function runMantisExperimentMasking()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisMasking\';

expt.name = 'Mantis Masking';

expt.defName = 'Will';

expt.recordVideos = 0;

expt.makeBackup = 0;

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 5;

noiseMode = [1 2 3];

spatialFreqs = [0.04 0.2]; % cyc/deg

contrast = [0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5];

direction = [-1 1];

paramSet = createRandTrialBlocks(blocks, noiseMode, spatialFreqs, contrast, direction);

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

%noise_values = [0.028 0.056 0; 0.141 0.282 20e-3; 0.028 0.056 100e-3;];

noise_values = [0.028 0.056 0; 0.141 0.282 0.14; 0.028 0.056 0.14;];%%%ISP 26-06-2014


noiseParams = noise_values(paramSetRow(1), :);

expt.rho_min = noiseParams(1);
expt.rho_max = noiseParams(2);
expt.Crmsdesired = noiseParams(3);

expt.bugColor = paramSetRow(1);

expt.spatialFreq = paramSetRow(2);

expt.contrast = paramSetRow(3);

expt.direction = paramSetRow(4);

expt.duration = 5;

expt

[dump] = runGratingNoise(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
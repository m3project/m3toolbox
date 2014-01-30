function runMantisExperimentGrating()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisGrating\';

expt.recordVideos = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

samplingMode    = 2;

if samplingMode == 3
    
    error('not implemented');
    
elseif samplingMode == 2
    
    gratingTypes = [0 1];
    
    contrast = [0 0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5 1];
    
    spatialFreqs = [4] / 1600;
    
    temporalFreqs = [0.25, 0.5, 0.75, 1, 8, 16, 20, 24, 28, 30];
    
    dirs = [+1 -1];
    
    paramSet = createRandTrial(gratingTypes, contrast, spatialFreqs, temporalFreqs, dirs);
    
elseif samplingMode == 1
    
    gratingTypes = [0 1];
    
    contrast = [0 0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5 1];
    
    spatialFreqs = [1 4 16 80] / 1600;
    
    temporalFreqs = [1 8 16];
    
    dirs = [+1 -1];
    
    paramSet = createRandTrial(gratingTypes, contrast, spatialFreqs, temporalFreqs, dirs);
    
end

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt2 = struct;
expt2.enaAbort = 0;
expt2.timeLimit = 5;
expt2.gratingType = paramSetRow(1);
expt2.contrast = paramSetRow(2);
expt2.spatialFreq = paramSetRow(3);
expt2.temporalFreq = paramSetRow(4);
expt2.dir = paramSetRow(5);

[dump] = runGrating(expt2);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
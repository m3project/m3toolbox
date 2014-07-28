function runMantisExperimentCrosstalk()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisCrosstalk\';

expt.name = 'Mantis Crosstalk';

expt.defName = 'Vivek';

expt.recordVideos = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 3;

bugColor = 0:0.1:0.4;

enableChannels = [0 -1 1];

paramSet = createRandTrialBlocks(blocks, bugColor, enableChannels);

end

function runBeforeTrial(varargin)

%runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

expt.bugColor = paramSetRow(1);

expt.enableChannels = paramSetRow(2);

[dump] = runLoom(expt);

%[dump] = runTarget(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

pause(30);

resultRow = 0;

end
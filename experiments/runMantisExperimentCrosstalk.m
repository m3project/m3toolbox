function runMantisExperimentCrosstalk()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisCrosstalkGreen\';

expt.name = 'Mantis Crosstalk Green';

expt.defName = 'Vivek';

expt.addTags = {'GREENPOL'};

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

% note: the results in 
% x:\readlab\Ghaith\m3\data\mantisCrosstalk\
% are based on the stimulus:

%[dump] = runLoom(expt);

% the results in:
% x:\readlab\Ghaith\m3\data\mantisCrosstalkGreen\
% are based on the stimulus:

[dump] = runLoomGreen(expt);

%[dump] = runTarget(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

pause(60);

resultRow = 0;

end
function runMantisExperimentCrosstalkTrack()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisCrosstalkTrack\';

expt.name = 'Mantis Crosstalk Track';

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


% prompt='What is the distance from the mantis to the screen in mm?';
% viewDist=input(prompt);
[pxMM, Xbound, Ybound, targetSize, stepSize,dispMain] = pmtrCalc(200);

expt.Xbound=Xbound;
expt.Ybound=Ybound;
expt.targetSize =targetSize;
expt.stepSize=stepSize;
expt.disparity = 0;
expt.timeLimit=10;

% [dump] = runLoom(expt);


[dump] = runTarget(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

pause(30);

resultRow = 0;

end
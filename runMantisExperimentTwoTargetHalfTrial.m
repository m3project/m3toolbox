function runMantisExperimentTwoTargetHalfTrial()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisTwoTargetHalfTrial\';

expt.name = 'Mantis TwoTarget Half Trial';

expt.recordVideos = 1;

expt.defName = 'Vivek';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 10;

% paramTable =[
%     % Size, Disparity, Condition
%     1     0     0;
%     0     1     0;
%     0     1     1;
%     1     1     0;
%     0    -1     0;
%     0    -1     1;
%     1    -1     0;
%     ];

%paramSet = repmat(paramTable, blocks, 1);

%k = randperm(size(paramSet, 1));

%paramSet = paramSet(k, :);
paramSet = createRandTrialBlocks(blocks, [0 1]);

% paramSet = createRandTrialBlocks(blocks, [0 1 2 4]);

end

function runBeforeTrial(varargin)

createWindow3D();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.renderTwo = paramSetRow(1);

% expt.disparityEnable = paramSetRow(1);
% expt.diffTarget = paramSetRow(1);

[dump] = runTwoTarget(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

pause(60);

r = [0];

% while isempty(r)
%     
%     r = input('Enter number of strikes: ');
%     
% end

resultRow = r;

end
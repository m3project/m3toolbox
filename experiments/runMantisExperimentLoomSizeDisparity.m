function runMantisExperimentLoomSizeDisparity()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisLoomSizeDisparity\';

expt.name = 'Mantis Loom Size Disparity';

expt.recordVideos = 0;

expt.defName = 'Judith';

%runExperiment(expt);
runExperimentNoVideo(expt);

end

function paramSet = genParamSet()

blocks = 30;
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

paramSet = createRandTrialBlocks(blocks, [-1 0 +1]);

end

function runBeforeTrial(varargin)

createWindow3D();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.disparityEnable = paramSetRow(1);

[dump] = runLoom(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

pause(10);

r = [0];

% while isempty(r)
%     
%     r = input('Enter number of strikes: ');
%     
% end

resultRow = r;

end
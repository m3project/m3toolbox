function runMantisExperimentGroupSwirl()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisGroupSwirl\';

expt.name = 'Mantis Group Swirl';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Vivek';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 10;

viewD = input('Enter distance between mantis and screen (cm): ');

paramSet = createRandTrialBlocks(blocks, [-1 0 +1], viewD);

end

function runBeforeTrial(paramSetRow)

expt = struct;

expt.duration = 120;

expt.moveOnStart = 0;

expt.viewD = paramSetRow(2);

global is;
global centerX;
global centerY;

   
% [is, centerX, centerY] = runGroupSwirl(expt);

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.duration = 7;

expt.moveOnStart = 1;

expt.disparityEnable = paramSetRow(1);

expt.viewD = paramSetRow(2);

global is;
global centerX;
global centerY;

if isempty(is)
    
    [is, centerX, centerY] = runGroupSwirl(expt);
    
else
    
    [is, centerX, centerY] = runGroupSwirl(expt, is, centerX, centerY);
    
end

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = [0];

pause (60)

end
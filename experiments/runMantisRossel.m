function runMantisRossel()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisRossel';

expt.name = 'Rossel''s Experiment';

expt.recordVideos = 1;

expt.defName = 'Judith';

runExperimentB(expt);

end

function paramSet = genParamSet()

blocks = 10;

paramSet = createRandTrialBlocks(blocks, [0 6 8]);

end

function runBeforeTrial(varargin)

end

function [resultRow, exitCode, dump] = runTrial(paramSetRow)


disp('rendering the stimulus ...');

expt = struct;

expt.thetad = paramSetRow(1);

%{
expt.bugSize = 2; % human experiment
expt.virtDM2 = 20; % human experiment
expt.viewD = 73; % human experiment
expt.iod = 7; % human
%}

[t, finalD] = runLoomRossel(expt);

resultRow = [t, finalD];

delay_secs = 30;

fprintf('Pausing for %d seconds ...', delay_secs);

pause(delay_secs);

dump = [];

exitCode = 0;

end

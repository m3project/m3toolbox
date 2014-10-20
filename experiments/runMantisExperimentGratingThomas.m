function runMantisExperimentGratingThomas()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'd:\mantisGratingThomas\';

expt.name = 'Mantis Grating Thomas';

expt.recordVideos = 0;

expt.makeBackup = 0;

expt.defName = 'Diana';

runExperiment(expt);

closeWindow();

end

function paramSet = genParamSet()

columnWidths = [0.5 1 2 4 8];

speeds_cm_sec = [1 2 4 8 16]; % cm/sec

dir = [-1 +1];

contrast = [0.25 0.5 0.75 1];

paramSet = createRandTrial(columnWidths, speeds_cm_sec, dir, contrast);

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

monitorResolution = 40; % px/cm

columnWidth = paramSetRow(1);

speed_cm_sec = paramSetRow(2);

spatialPeriod = columnWidth * monitorResolution * 2; % px

spatialFreq = 1/spatialPeriod; % cycle/px

speed_px_sec = speed_cm_sec * monitorResolution;

temporalFreq = speed_px_sec * spatialFreq;

expt.gratingType = 1;

expt.temporalFreq = temporalFreq; % cycle

expt.spatialFreq = spatialFreq; % cycle per cm

expt.dir = paramSetRow(3);

expt.contrast = paramSetRow(4);

expt.timeLimit = 5; % seconds

expt.enaAbort = 0; % disable exit by pressing Escape

[dump] = runGrating(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

pause(1);

end
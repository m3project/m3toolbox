function runMantisExperimentGratingThomas()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'd:\mantisGratingThomas\';

expt.name = 'Mantis Grating Thomas';

expt.recordVideos = 0;

expt.makeBackup = 1;

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

runAlignmentStimulusNoBack();

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

expt.Gamma = 2.1942; % Dell monitor in Thomas's setup

[dump] = runGrating(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

%pause(1);

end

function runAlignmentStimulusNoBack()

% coordinates of bug swirling center:

x = 0;

y = 350;

% render alignment stimulus

expt = struct;

expt.interactiveMode = 1;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.enable3D = 0;

expt.disparity = 0;

expt.M = 40;

expt.R = 1;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) 0;

expt.stepDX = 0;

expt.bugFrames = getBugFrames('fly');

expt.motionFuncs = getMotionFuncs('swirl', x, y);

expt.nominalSize = 0.5;

expt.bugVisible = 1;

expt.txtCount = 50;

expt.bugVisible = 1;

expt.timeLimit = 0;

expt.interactiveMode = 1;

disp('alignment mode (interactive), press Escape when mantis is aligned ...');

runAnimation2(expt);

end
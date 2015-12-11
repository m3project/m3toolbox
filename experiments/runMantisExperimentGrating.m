function runMantisExperimentGrating()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

%expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisGrating\';

expt.workDir = 'c:\mantisGratingThomasGrid2\';

expt.name = 'Mantis Grating (Diana - Grid 2)';

expt.defName = 'Diana';

expt.addTags = {'GRID3'};

expt.recordVideos = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

% Important: make sure Gamma value in runTrial is correct

samplingMode    = 5;

if samplingMode == 5
    
    % Diana's experiment
    
    contrast = 0.25;
    
    gratingTypes = 1; % only square
    
%     spatialFreqs = [1 32] / 1600; % cycle/px
    
%     startFreq = 
    
%     spatialFreqs = logspace2(startFreq, endFreq, n);
    
%     temporalFreqs = [0.25 30];
    
    spatialFreqs = 32 / 1600;
    
    temporalFreqs = 30;
    
    dirs = [+1 -1];
    
    paramSet = createRandTrial(gratingTypes, contrast, spatialFreqs, temporalFreqs, dirs);    

elseif samplingMode == 4
    
    % Ghaith, Jenny and Vivek
    % 27/5/2014
    
    gratingTypes = 0; % only sine
    
    contrast = [0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5 1];
    
    spatialFreqs = [1 2 4 8 16 1600/67 32 64 1600/12] / 1600;
    
    temporalFreqs = 8;
    
    dirs = [+1 -1];
    
    paramSet = createRandTrial(gratingTypes, contrast, spatialFreqs, temporalFreqs, dirs);

elseif samplingMode == 3
    
    gratingTypes = [0 1];
    
    contrast = [0 0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5 1];
    
    spatialFreqs = [1 4 16 32] / 1600;
    
    temporalFreqs = [0.25, 8, 30];
    
    dirs = [+1 -1];
    
    paramSet = createRandTrial(gratingTypes, contrast, spatialFreqs, temporalFreqs, dirs);
    
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

runAlignmentStimulusNoBack();

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
expt2.Gamma = 2.1942; % Dell monitor in Thomas's setup

[dump] = runGrating(expt2);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
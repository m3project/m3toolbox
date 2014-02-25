function runMantisExperimentDisparity()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisDisparity\';

expt.name = 'Mantis Disparity';

expt.recordVideos = 0;

runExperiment(expt);

end

function paramSet = genParamSet()

screenDensity = 40; % pixels/cm

L = input('Distance to screen (in cm): ');

%L = 5; % distance to the screen in cm

d = 0.4; % mantis interocular distance in cm

n = 4; % number of disparity points in experiment

L1 = 2:(L-2)/(n-1):L; % simulated distance of bug away from mantis

S = (L-L1)./L1*d; % disparity in cm

Spx = S * screenDensity; % disparity in pixels

dirs = [-1 +1];

paramSet = createRandTrialBlocks(10, dirs, Spx);

end

function runBeforeTrial(varargin)

%runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('Rendering the alignment stimulus (press End to proceed)... ');

expt = struct;

expt.dir = paramSetRow(1);

expt.disparity = paramSetRow(2);

runDots(expt);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

dir = getDirectionJudgement();

response = getResponseJudgement();

resultRow = [dir response];

end
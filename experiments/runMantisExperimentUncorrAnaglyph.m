% 29/1/2016
%
% programmed this but realized we don't need it atm

function runMantisExperimentUncorrAnaglyph()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisUncorrAnaglyph\';

expt.name = 'Mantis Camouflaged Uncorr Anaglyph';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Vivek';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 10;

viewD = input('Enter distance between mantis and screen (cm): ');

paramSet = createRandTrialBlocks(blocks,  [-1 0 1], viewD);

rSeeds = randi(1e5, size(paramSet, 1), 1);

paramSet = [paramSet rSeeds];

end

function runBeforeTrial(paramSetRow)

disp('pre trial');

expt = struct();

expt.enableKeyboard = 0;

expt.bugY = -100; % hide bug

expt.interTrialTime = 0;

expt.preTrialDelay = 58;

expt.motionDuration = 1;

expt.finalPresentationTime = 0;

expt.useCorrelatedDotPatterns = 0;

expt.disparityEnable = paramSetRow(1);

expt.viewD = paramSetRow(2);

expt.randomSeed = paramSetRow(3);

runCorrAnaglyph(expt);

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.enableKeyboard = 0;

expt.disparityEnable = paramSetRow(1);

expt.viewD = paramSetRow(2);

expt.interTrialTime = 2;

expt.preTrialDelay = 0;

expt.useCorrelatedDotPatterns = 0;

expt.randomSeed = paramSetRow(3);

runCorrAnaglyph(expt);
    
exitCode = 0;

dump = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = 0;

end
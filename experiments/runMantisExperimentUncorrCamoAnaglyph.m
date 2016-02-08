function runMantisExperimentUncorrCamoAnaglyph()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisUncorrCamoAnaglyph\';

expt.name = 'Mantis Uncorr Camouflaged Anaglyph';

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

function runBeforeTrial(varargin)

expt = struct;

expt.enableKeyboard = 0;

expt.preTrialDelay = 0;
expt.interTrialTime = 0;
expt.motionDuration = 0;
expt.finalPresentationTime = 60;
expt.bugY = -0.5;
expt.pairDots = 0;

% the variables xs, ys and thetas are set to global to preserve the dot
% positions and velocities between trials

global xs;
global ys;
global thetas;

if isempty(xs)
    
    [~, xs, ys, thetas] = runDotsAnaglyph(expt);
    
else
    
    [~, xs, ys, thetas] = runDotsAnaglyph(expt, xs, ys, thetas);
    
end

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.enableKeyboard = 0;

expt.disparityEnable = paramSetRow(1);

expt.viewD = paramSetRow(2);

expt.interTrialTime = 1;

expt.preTrialDelay = 0;

expt.pairDots = 0;

% the variables xs, ys and thetas are set to global to preserve the dot
% positions and velocities between trials

global xs;
global ys;
global thetas;

if isempty(xs)
    
    [dump, xs, ys, thetas] = runDotsAnaglyph(expt);
    
else
    
    [dump, xs, ys, thetas] = runDotsAnaglyph(expt, xs, ys, thetas);
    
end

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = [0];

end
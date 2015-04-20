function runMantisExperimentCrosstalkAnaglyph()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisCrosstalkAnaglyph\';

expt.name = 'Mantis Crosstalk Color';

expt.defName = 'Vivek';

expt.recordVideos = 1;

expt.makeBackup = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 3;

bugBrightness = 0:0.25:1;

scaledChannel = [1 2 3];

paramSet = createRandTrialBlocks(blocks, bugBrightness, scaledChannel);

% paramSet = createTrial(bugBrightness, scaledChannel);

end

function runBeforeTrial(varargin)

%runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

brightness = paramSetRow(1);

selColor = [0 0.5 0.5];

switch(paramSetRow(2))
    
    case(1)
        
        selColor = selColor * brightness;
        
    case(2)
        
        selColor(2) = selColor(2) * brightness; % scale Green
        
    case(3)
        
        selColor(3) = selColor(3) * brightness; % scale Blue
        
end

expt.bugColor = selColor;

% expt.bugColor = colors(paramSetRow(2), :)  * paramSetRow(1);

% expt.backColor = [0 0.8 1];

% expt.backColor = colors(1, :) * 0.5;

[dump] = runLoomAnaglyph(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

pause(30);

resultRow = 0;

end

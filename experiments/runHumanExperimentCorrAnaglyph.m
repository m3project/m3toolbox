function runHumanExperimentCorrAnaglyph()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\humanCorrAnaglyph\';

expt.name = 'Human Camouflaged Corr Anaglyph';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Vivek';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 5;

paramSet = createRandTrialBlocks(blocks,  [-1 0 1], [-1 1]);

rSeeds = randi(1e5, size(paramSet, 1), 1);

paramSet = [paramSet rSeeds];

end

function runBeforeTrial(paramSetRow)

disp('pre trial');

expt = struct();

expt.enableKeyboard = 0;

expt.bugY = -100; % hide bug

expt.interTrialTime = 0;

expt.preTrialDelay = 1;

expt.motionDuration = 1;

expt.finalPresentationTime = 0;

expt.disparityEnable = paramSetRow(1);

expt.corrSetting = paramSetRow(2);

expt.randomSeed = paramSetRow(3);

runCorrAnaglyphHuman(expt);

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.enableKeyboard = 0;

expt.disparityEnable = paramSetRow(1);

expt.corrSetting = paramSetRow(2);

expt.interTrialTime = 2;

expt.preTrialDelay = 0;

expt.randomSeed = paramSetRow(3);

runCorrAnaglyphHuman(expt);
    
exitCode = 0;

dump = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgementLocal();

end

function key = getDirectionJudgementLocal()

% checking for key presses

disp('Press (Up, Down, Space) to indicate whether pattern is (in front, behind or on screen)');

pause(0.1);

while (1)
    
    drawnow
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('UpArrow')))
        
        key = 1; break;
        
    end
    
    if (keyCode(KbName('DownArrow')))
        
        key = -1; break;
        
    end
    
    if (keyCode(KbName('Space')))
        
        key = 0; break;
        
    end
    
end

end
function runHumanExperimentCorrAnaglyph()

expt = struct;

expt.runBeforeExptFun = @runBeforeExptFun;

expt.genParamSetFun = @genParamSet_PILOT5;

expt.runTrialFun = @runTrial;

expt.runBeforeTrialFun = @(varargin) [];

expt.runAfterTrialFun = @runAfterTrial;

expt.runAfterExptFun = @(varargin) [];

expt.workDir = 'V:\readlab\Ghaith\m3\data\humanCorrAnaglyph\';

expt.name = 'Human Camouflaged Corr Anaglyph';

expt.recordVideos = 0;

expt.makeBackup = 0;

expt.addTags = {'PILOT 5'};

expt.defName = 'Jonothon';

runExperiment(expt);

end

function runBeforeExptFun()

HideCursor

Gamma = 1.0;

multisample = 4; % for smooth dots

createWindow3D(Gamma, multisample);

end

function resultRow = runAfterTrial(varargin)

clearWindow([1 1 1] * 0.5, 1);

resultRow = getDirectionJudgementLocal();

end


function paramSet = genParamSet_PILOT5()

d = @str2double;

isSensible = @(x) (d(x)>2) && (d(x)<10);

iod = getNumber('Enter inter-ocular distance (cm): ', isSensible);

blocks = 5;

virtDm1 = [6 4 1.5 0.25 0 -0.25 -1.5 -4 -6]; % distance in fromt of screen cm

corrSetting = [-1 1];

dotSize = [0 1]; % 0 = small, 1 = large

paramSet = createRandTrialBlocks(blocks, virtDm1, corrSetting, dotSize);

ntrials = size(paramSet, 1);

rSeeds = randi(1e5, ntrials, 1);

iodCol = ones(ntrials, 1) * iod;

paramSet = [paramSet rSeeds iodCol];

end

function paramSet = genParamSet() %#ok<DEFNU>

d = @str2double;

isSensible = @(x) (d(x)>2) && (d(x)<10);

iod = getNumber('Enter inter-ocular distance (cm): ', isSensible);

blocks = 5;

virtDm1 = -3:3; % distance in fromt of screen cm

corrSetting = [-1 1];

dotSize = [0 1]; % 0 = small, 1 = large

paramSet = createRandTrialBlocks(blocks, virtDm1, corrSetting, dotSize);

ntrials = size(paramSet, 1);

rSeeds = randi(1e5, ntrials, 1);

iodCol = ones(ntrials, 1) * iod;

paramSet = [paramSet rSeeds iodCol];

end

function [exitCode, dump] = runTrial(paramSetRow)

viewD = 70; % viewing distance in cm

disp('rendering the stimulus ...');

expt = struct('enableKeyboard', 0, 'disparityEnable', 1, ...
    'viewD', viewD, 'virtDm1', viewD - paramSetRow(1), ...
    'corrSetting', paramSetRow(2), 'randomSeed', paramSetRow(4), ...
    'iod', paramSetRow(5));

dotSize = paramSetRow(3);

if dotSize == 0 % small dots    
    
    expt.dotDiam = 20;
    
    expt.dotDensity = 55;
    
elseif dotSize == 1 % large dots
    
    expt.dotDiam = 60;
    
    expt.dotDensity = 3;
    
else
    
    error('incorrect dotSize setting');
    
end

runCorrAnaglyphHuman(expt);
    
exitCode = 0;

dump = 0;

end

function key = getDirectionJudgementLocal()

% checking for key presses

disp('Press (Up, Down) to indicate whether pattern is (in front or behind) the screen');

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
    
end

end
% IMPORTANT NOTE:
% Concerning the interpretation of the `crossed` parameter:
%
% the crossed field in the experiment parameters assumes that ** blue
% filter is on left eye **
% 
% This means (for an upside-down mantis):
% 
% when blue filter is on left eye, the parameter crossed actually indicates
% whether stimulus is crossed or not, aka: param crossed = 1 means stimulus
% crossed param crossed = 0 means stimulus uncrossed
% 
% however, if blue filter is on **RIGHT** eye, the parameter crossed is
% interpreted in the opposite way, aka: param crossed = 1 means stimulus
% **uncrossed** param crossed = 0 means stimulus **crossed**
%
% Ghaith & Vivek (13/6/2016)

function runMantisExperimentLumFlip()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisLumFlip\';

expt.name = 'Mantis Lum Flip';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Vivek';

isLarge = getDotSize();

expt.addTags = {ifelse(isLarge, 'LARGE', 'SMALL')};

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

glassLeft = getNumber('Specify which filter color is on the LEFT eye (1 = green, 0 = blue): ', checkBinary);

expt.addTags{end+1} = ifelse(glassLeft == 0, 'BLUE_LEFT', 'GREEN_LEFT');

runExperiment(expt);

end

function isLarge = getDotSize()

isLarge = 1; % 0 or 1

end

function paramSet = genParamSet()

isLarge = getDotSize();

blocks = 10;

viewD = input('Enter distance between mantis and screen (cm): ');

crossed = [0 1];

paramSet = createRandTrialBlocks(blocks, crossed, viewD, isLarge);

end

function runBeforeTrial(paramSetRow)

args = struct('mode', 'lum-flip', ...
    'enableKeyboard', 0, 'preTrialDelay', 0, ...
    'interTrialTime', 60, 'motionDuration', 0, ...
    'finalPresentationTime', 0);

% dotInfo is made global to pereserve dot position and velocity information
% across trials

args.crossed = paramSetRow(1);

args.viewD = paramSetRow(2);

isLarge = paramSetRow(3);

args.n = ifelse(isLarge, 1e3, 1e4); % number of dots  

args.r = ifelse(isLarge, 60, 20); % radius

global dotInfo;

% if ~isempty(dotInfo); args.dotInfo = dotInfo; end
    
dotInfo = runDotsAnaglyphExtra(args);
    
end

function runTrial(paramSetRow)

disp('rendering the stimulus ...');

args = struct('mode', 'lum-flip', 'enableKeyboard', 0, ...
    'interTrialTime', 1, 'preTrialDelay', 0);

args.crossed = paramSetRow(1);

args.viewD = paramSetRow(2);

isLarge = paramSetRow(3);

args.n = ifelse(isLarge, 1e3, 1e4); % number of dots  

args.r = ifelse(isLarge, 60, 20); % radius

global dotInfo;

if ~isempty(dotInfo); args.dotInfo = dotInfo; end
    
dotInfo = runDotsAnaglyphExtra(args);

end

function resultRow = runAfterTrial(varargin)

resultRow = 0;

end
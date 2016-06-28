function runMantisExperimentBruceStaticKinetic()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisBruceStaticKinetic\';

expt.name = 'Mantis (Bruce) Static Kinetic';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Vivek';

isLarge = getDotSize();

expt.addTags = {ifelse(isLarge, 'LARGE', 'SMALL')};

runExperiment(expt);

end

function isLarge = getDotSize()

isLarge = 0; % 0 or 1

end

function paramSet = genParamSet()

isLarge = getDotSize();

blocks = 5;

viewD = input('Enter distance between mantis and screen (cm): ');

crossed = [0 1];

staticCorr = [0 1];

paramSet = createRandTrialBlocks(blocks, staticCorr, crossed, viewD, isLarge);

end

function runBeforeTrial(paramSetRow)

args = struct('mode', 'bruce', ...
    'enableKeyboard', 0, 'preTrialDelay', 0, ...
    'interTrialTime', 0, 'motionDuration', 0, ...
    'finalPresentationTime', 60);

% dotInfo is made global to pereserve dot position and velocity information
% across trials

args.staticCorr = paramSetRow(1);

args.crossed = paramSetRow(2);

isLarge = paramSetRow(4);

args.n = ifelse(isLarge, 1e3, 1e4); % number of dots  

args.r = ifelse(isLarge, 60, 20); % radius

global dotInfo;

% if ~isempty(dotInfo); args.dotInfo = dotInfo; end
    
dotInfo = runDotsAnaglyphExtra(args);
    
end

function runTrial(paramSetRow)

disp('rendering the stimulus ...');

args = struct('mode', 'bruce', 'enableKeyboard', 0, ...
    'interTrialTime', 1, 'preTrialDelay', 0);

args.staticCorr = paramSetRow(1);

args.crossed = paramSetRow(2);

% dotInfo is made global to pereserve dot position and velocity information
% across trials

isLarge = paramSetRow(4);

args.n = ifelse(isLarge, 1e3, 1e4); % number of dots  

args.r = ifelse(isLarge, 60, 20); % radius

global dotInfo;

if ~isempty(dotInfo); args.dotInfo = dotInfo; end
    
dotInfo = runDotsAnaglyphExtra(args);

end

function resultRow = runAfterTrial(varargin)

resultRow = 0;

end
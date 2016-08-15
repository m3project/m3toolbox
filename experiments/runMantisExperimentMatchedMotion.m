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

function runMantisExperimentMatchedMotion()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.runBeforeTrialFun = @(varargin) 0;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisMatchedMotion\';

expt.name = 'Mantis Matched Motion';

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

blocks = 2;

viewD = input('Enter distance between mantis and screen (cm): ');

crossed = [0 1];

conds = [1 2 3 3 4 4 5 5];

paramSet = createRandTrialBlocks(blocks, conds, crossed, viewD, isLarge);

% paramSet = createTrial(conds, 1, viewD, isLarge);

end

function runTrial(paramSetRow)

disp('rendering the stimulus ...');

cond = paramSetRow(1);

crossed = paramSetRow(2);

viewD = paramSetRow(3);

isLarge = paramSetRow(4);

n = ifelse(isLarge, 1e3, 1e4); % number of dots  

r = ifelse(isLarge, 60, 20); % radius

runDotsVAR3_wrapper(cond, crossed, viewD, n, r);

end

function resultRow = runAfterTrial(varargin)

resultRow = 0;

end

%%

function runDotsVAR3_wrapper(cond, crossed, viewD, n, r)

delayBefore = 55;

delayAfter = 5;

% delayBefore = 1; delayAfter = 1; % FOR TESTING

finalPresentationTime = 2;

if cond == 1
    
    targetDirection1 = 4;
    targetDirection2 = 6;
    
    stimType = 0;
    
elseif cond == 2
    
    targetDirection1 = 6;
    targetDirection2 = 4;
    
    stimType = 0;
    
elseif cond == 3
    
    targetDirection1 = 6;
    targetDirection2 = 6;
    
    stimType = 0;
    
elseif cond == 4
    
    targetDirection1 = 4;
    targetDirection2 = 4;
    
    stimType = 0;
    
elseif cond == 5
    
    targetDirection1 = nan;
    targetDirection2 = nan;
    
    stimType = 1;
    
else
    
    error('incorrect stimType');
    
end

args = struct('bugY', 0.7, 'renderChannels', [0 1], 'v', 0, ...
    'vTargetDots', 2, 'pairDots', 1, ...
    'preTrialDelay', delayBefore, 'motionDuration', 0, ...
    'finalPresentationTime', finalPresentationTime, ...
    'targetDirection1', targetDirection1, ...
    'targetDirection2', targetDirection2, 'viewD', viewD, ...
    'enableKeyboard', 0, ...
    'interTrialTime', delayAfter, ...
    'n', n, 'r', r);

if stimType
    
    % luminance flip
    
    lumFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDotLum(ch, x, y, bugX, bugY, bugRad, G, D, crossed);
    
    args.lumFun1 = lumFun1;
    
    args.dispFun1 = @getDotDisp;
    
    args.pairDots = 0;
    
    runDots(args);
    
else
    
    % coherent motion
    
    args.crossed = crossed;
    
    runDotsVAR3(args);
    
end

end

function lum = getDotLum(ch, x, y, bugX, bugY, bugRad, G, D, crossed)

dispSign = (-1)^ch;

dispSign2 = ifelse(crossed, 1, -1);

shiftX =  D/2 * dispSign * dispSign2;

inBug = sqrt((x - bugX + shiftX).^2 + (y - bugY).^2) < bugRad;

lum = (-1).^inBug .* ((-1).^G(:, 1));

lum = lum > -1;

end

function disp = getDotDisp(~, x, varargin)

disp = zeros(size(x));

end

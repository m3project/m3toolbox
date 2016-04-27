function runMantisExperimentTrackingOptomotor()

expt = struct;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.genParamSetFun = @genParamSet_VAR2;

expt.runTrialFun = @runTrial_VAR2;

expt.runAfterTrialFun = @runAfterTrial_VAR2;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisTrackOptomotor\';

expt.name = 'Mantis Tracking Optomotor';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Lisa';

expt.addTags = {'VAR2', 'UNWARPED'};

if addChequersToTrackingTrials
    
    expt.addTags{end+1} = 'CHEQUERS';
    
end

runExperiment(expt);

end

%% VAR2

% basically same as VAR but using unwarped tracking and optomotor stimuli

function addChequer = addChequersToTrackingTrials()

addChequer = 0; % change to 1 to add chequers

% note that when (and only when) this flag is set high, 
% runMantisExperimentTrackingOptomotor() will add an additional 
% `CHEQUERS` tag to the experiment - this way chequered and non-chequered
% variants can be told apart later

end

function paramSet = genParamSet_VAR2()

blocks = 1;

sf_tf = [
    0.05	2
    0.1     4
    0.2     8
    0.05	8
    0.1     16
    0.2     32
    0.1     8
    0.1     32
    0.05	32
    ];

np = size(sf_tf, 1);

conds1 = [zeros(np, 1) sf_tf]; % optomotor

conds2 = [ones(np, 1) sf_tf]; % sine bugs

conds3 = [2 0.1 4; 2 0.1 16]; % black bugs

conds_half = [conds1; conds2; conds3];

nconds_half = size(conds_half, 1);

k = ones(nconds_half, 1);

conds = [conds_half -k; conds_half k]; % add direction column

nconds = size(conds, 1);

% each row is
% col 1 : trial type (0 = optomotor, 1 = sine bug, 2 = black bug)
% col 2 : sf
% col 3 : tf
% col 4 : dir

indSet = createRandTrialBlocks(blocks, 1:nconds);

paramSet = conds(indSet, :);

end

function [exitCode, dump] = runTrial_VAR2(paramSetRow)

% each row is
% col 1 : trial type (0 = optomotor, 1 = sine bug, 2 = black bug)
% col 2 : sf
% col 3 : tf
% col 4 : dir

trialType = paramSetRow(1);

sf = paramSetRow(2);

tf = paramSetRow(3);

dir = paramSetRow(4);

applyWarping = 0;

if trialType == 0
    
    % optomotor
    
    runOptomotorTrial(sf, tf, dir, applyWarping);
    
elseif trialType == 1
    
    % sine bug
    
    runTrackingTrial(sf, tf, dir, 1, applyWarping);
    
elseif trialType == 2
    
    % black bug
    
    runTrackingTrial(sf, tf, dir, 0, applyWarping);
    
else
    
    error('incorrect trialType');
    
end

exitCode = 0; dump = [];

end


function resultRow = runAfterTrial_VAR2(varargin)

delay = 0; % inter-trial delay (seconds)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

checkTernary = @(str) ismember(str2double(str), [-1 0 1]);

saccades  = getNumber('Number of saccades/sways        : ', checkPositive);

optomotor = getNumber('Optomotor direction (-1, 0, +1) : ', checkTernary);

miniopto  = getNumber('Mini Optomotor (0=no, 1=yes)    : ', checkBinary);

peering   = getNumber('Peering   (0=no, 1=yes)         ? ', checkBinary);

strike    = getNumber('Number of strikes               : ', checkPositive);

resultRow = [saccades optomotor miniopto peering strike];

sprintf('pausing for %i seconds ...\n', delay);

pause(delay);

end

%% VAR1

function paramSet = genParamSet_VAR1() %#ok<DEFNU>

blocks = 1;

sf_tf = [
    0.05	2
    0.1     4
    0.2     8
    0.05	8
    0.1     16
    0.2     32
    0.1     8
    0.1     32
    0.05	32
    ];

np = size(sf_tf, 1);

conds1 = [zeros(np, 1) sf_tf]; % optomotor

conds2 = [ones(np, 1) sf_tf]; % sine bugs

conds3 = [2 0.1 4; 2 0.1 16]; % black bugs

conds_half = [conds1; conds2; conds3];

nconds_half = size(conds_half, 1);

k = ones(nconds_half, 1);

conds = [conds_half -k; conds_half k]; % add direction column

nconds = size(conds, 1);

% each row is
% col 1 : trial type (0 = optomotor, 1 = sine bug, 2 = black bug)
% col 2 : sf
% col 3 : tf
% col 4 : dir

indSet = createRandTrialBlocks(blocks, 1:nconds);

paramSet = conds(indSet, :);

end

function viewD = getViewD()

viewD = 7; % cm

end

function runOptomotorTrial(sf, tf, dir, applyWarping)

if applyWarping
    
    runGratingWarped(struct('signalFreq', sf, 'temporalFreq', tf, ...
        'dir', dir, 'contrast', 1, 'viewD', getViewD(), ...
        'escapeEnabled', 0));

else
    
    sf_cppx = getSFpx(sf);

    runGrating_ver2(struct('sf', sf_cppx, 'tf', tf, 'dir', dir, ...
        'contrast', 1, 'escapeEnabled', 0));
    
end

end

function sf_cppx = getSFpx(sf_cpd)

screenReso = 40;

period_degs = 1/sf_cpd;

period_px = 2 * tand(period_degs/2) * getViewD() * screenReso;

sf_cppx = 1/period_px;

end

function runTrackingTrial(sf, tf, dir, bugType, applyWarping)

bugSpeed = tf/sf;

addChequer = addChequersToTrackingTrials();

runWarped(struct('fs', sf, 'bugSpeed', bugSpeed, 'escapeEnabled', 0, ...
    'viewD', getViewD(), 'bugType', bugType, 'dir', dir, ...
    'addChequer', addChequer, 'applyWarping', applyWarping));

end

function [exitCode, dump] = runTrial_VAR1(paramSetRow) %#ok<DEFNU>

% each row is
% col 1 : trial type (0 = optomotor, 1 = sine bug, 2 = black bug)
% col 2 : sf
% col 3 : tf
% col 4 : dir

trialType = paramSetRow(1);

sf = paramSetRow(2);

tf = paramSetRow(3);

dir = paramSetRow(4);

applyWarping = 0;

if trialType == 0
    
    % optomotor
    
    runOptomotorTrial(sf, tf, dir, applyWarping);
    
elseif trialType == 1
    
    % sine bug
    
    runTrackingTrial(sf, tf, dir, 1, applyWarping);
    
elseif trialType == 2
    
    % black bug
    
    runTrackingTrial(sf, tf, dir, 0, applyWarping);
    
else
    
    error('incorrect trialType');
    
end

exitCode = 0; dump = [];

end

%% Others

function runBeforeExpt()

Gamma = 2.783; % this is for Lisa's Phillips 107b3

createWindow(Gamma);

end

function runBeforeTrial(~)

runAlignmentStimulus_internal(0, 0, 0);

end

function resultRow = runAfterTrial_VAR1(varargin) %#ok<DEFNU>

delay = 0; % inter-trial delay (seconds)

checkPositive = @(str) str2double(str) >= 0;

checkBinary = @(str) (str2double(str) >= 0) && (str2double(str) <= 1);

checkTernary = @(str) ismember(str2double(str), [-1 0 1]);

saccades  = getNumber('Number of saccades/sways        : ', checkPositive);

optomotor = getNumber('Optomotor direction (-1, 0, +1) : ', checkTernary);

peering   = getNumber('Peering   (0=no, 1=yes)         ? ', checkBinary);

strike    = getNumber('Number of strikes               : ', checkPositive);

resultRow = [saccades optomotor peering strike];

sprintf('pausing for %i seconds ...\n', delay);

pause(delay);

end

function runAlignmentStimulus_internal(enable3D, x, y)

if nargin<1
    enable3D = 0;
end

if nargin<3
    x = 0;
    y = 350;
end

% render alignment stimulus

expt = struct;

expt.interactiveMode = 1;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.enable3D = enable3D;

expt.disparity = 0;

expt.M = 32;

expt.R = 0.5;
% 
% expt.blackLum = 0;
% 
% expt.whiteLum = 128;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) 0;

expt.stepDX = 0;

expt.bugFrames = getBugFrames('fly');

expt.motionFuncs = getMotionFuncs('swirl', x, y);

expt.nominalSize = 0.5;

expt.bugVisible = 1;

expt.txtCount = 50;

expt.bugVisible = 0;

expt.timeLimit = 0;

expt.interactiveMode = 1;

expt.enable3D = enable3D;

expt.enableChequers = 0;

expt.enableChequers = 0;

disp('alignment mode (interactive), press Escape when mantis is aligned ...');

runAnimation2(expt);

end
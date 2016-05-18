function runMantisExperimentGratingApertureWarped_ver2()

expt = struct;

expt.genParamSetFun = @genParamSet_VARE;

expt.runTrialFun = @runTrial_VARE;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'X:\readlab\Ghaith\m3\data\mantisGratingAperture\'; % ADJUSTED BY STEVEN 25-04-16 due to change of V drive.

expt.name = 'Mantis Grating Aperture';

expt.defName = 'Steven';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {'VARE'};

expt.runBeforeExptFun = @runBeforeExpt;

checkResolution();

runExperiment(expt);

end

%% VARE

function [exitCode, dump] = runTrial_VARE(paramSetRow)

% this function is the same as runTrial_VARD that signalFreq was changed to
% 0.02 cpd (lower end of mantis CSF)

disp('rendering the stimulus');

signalFreq = 0.02; % cpd

gratingSizeDegs = paramSetRow(1);

region = paramSetRow(2);

contrast = paramSetRow(3);

dir = paramSetRow(4);

if region == 0
    
    % central
    
    apertureDeg = gratingSizeDegs;
    
    flipAperture = 0;
    
else
    
    % peripheral
    
    apertureDeg = 141.4 - gratingSizeDegs;
    
    flipAperture = 1;
    
end

args = struct('duration', 5, 'apertureDeg', apertureDeg, ...
    'dir', dir, ...
    'flipAperture', flipAperture, ...
    'signalFreq', signalFreq, 'contrast', contrast, ...
    'useAperture', 1, 'escapeEnabled', 0);

runGratingWarped(args);

exitCode = 0;

dump = [];

end

function paramSet = genParamSet_VARE()

% Important: make sure Gamma value in runTrial is correct

blocks = 3;

gratingSizeDegs = (1:3)/3 * 141.4;

region = [0 1]; % 0 is central, 1 is peripheral

contrast = [0.05 0.2 1];

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, gratingSizeDegs, region, contrast, dirs);

% remove condition: grating extent 141.4 deg at periphery

k = (paramSet(:, 1) == 141.4) & (paramSet(:, 2) == 1);

paramSet = paramSet(~k, :);

end

%% VARD

function [exitCode, dump] = runTrial_VARD(paramSetRow) %#ok<DEFNU>

% this function is basically the same as runTrial_VARB() except that it
% renders warped gratings

disp('rendering the stimulus');

signalFreq = 0.1; % cpd

gratingSizeDegs = paramSetRow(1);

region = paramSetRow(2);

contrast = paramSetRow(3);

dir = paramSetRow(4);

if region == 0
    
    % central
    
    apertureDeg = gratingSizeDegs;
    
    flipAperture = 0;
    
else
    
    % peripheral
    
    apertureDeg = 141.4 - gratingSizeDegs;
    
    flipAperture = 1;
    
end

args = struct('duration', 5, 'apertureDeg', apertureDeg, ...
    'dir', dir, ...
    'flipAperture', flipAperture, ...
    'signalFreq', signalFreq, 'contrast', contrast, ...
    'useAperture', 1);

runGratingWarped(args);

exitCode = 0;

dump = [];

end

function paramSet = genParamSet_VARD() %#ok<DEFNU>

paramSet = genParamSet_VARC();

end

%% VARC

function [exitCode, dump] = runTrial_VARC(paramSetRow) %#ok<DEFNU>

% 6/1/2016

[exitCode, dump] = runTrial_VARB(paramSetRow);

end

function paramSet = genParamSet_VARC()

% 6/1/2016 - replaced contrast level 0.01 with 0.2

% Important: make sure Gamma value in runTrial is correct

blocks = 3;

gratingSizeDegs = (1:5) * 28.28;

region = [0 1]; % 0 is central, 1 is peripheral

contrast = [0.05 0.2 1];

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, gratingSizeDegs, region, contrast, dirs);

end

%% VARB

function [exitCode, dump] = runTrial_VARB(paramSetRow)

disp('rendering the stimulus');

gratingSizeDegs = paramSetRow(1);

region = paramSetRow(2);

contrast = paramSetRow(3);

dir = paramSetRow(4);

if region == 0
    
    % central
    
    apertureDeg = gratingSizeDegs;
    
    flipAperture = 0;
    
else
    
    % peripheral
    
    apertureDeg = 141.4 - gratingSizeDegs;
    
    flipAperture = 1;
    
end

args = struct('duration', 5, 'apertureDeg', apertureDeg, ...
    'dir', dir, ...
    'flipAperture', flipAperture, ...
    'spatialFreq', 1/53, 'contrast', contrast);

runGratingAperture(args);

exitCode = 0;

dump = [];

end

function paramSet = genParamSet_VARB() %#ok<DEFNU>

% Important: make sure Gamma value in runTrial is correct

blocks = 3;

gratingSizeDegs = (1:5) * 28.28;

region = [0 1]; % 0 is central, 1 is peripheral

contrast = [0.01 0.05 1];

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, gratingSizeDegs, region, contrast, dirs);

end

%% General

function checkResolution()

pc = getenv('computername');

[sW, sH] = getResolution();

if ~isequal([sW sH], [1600 1200]) && ~isequal(pc, 'READLAB14')
    
    error('this experiment was designed for a screen size of 1600 x 1200 px');
    
end

end

function paramSet = genParamSet() %#ok<DEFNU>

% Important: make sure Gamma value in runTrial is correct

blocks = 15;

apertureSizeDegs = (1:5) * 28.28;

dirs = [-1 1];

paramSet = createRandTrialBlocks(blocks, apertureSizeDegs, dirs);

end

function runBeforeExpt()

%Gamma = 2.783; % this is for Lisa's Phillips 107b3

% Gamma = 1.3476; % for the monitor used in the mantis CSF experiment

% Gamma = 1.7; % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 2nd of Nov 2015

Gamma = 2.0;  % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 17nd of Nov 2015

createWindow(Gamma);

end

function runBeforeTrial(varargin)

runAlignmentStimulus(0,0,0);

end

function [exitCode, dump] = runTrial(paramSetRow) %#ok<DEFNU>

disp('rendering the stimulus');

args = struct('duration', 5, 'apertureDeg', paramSetRow(1), ...
    'dir', paramSetRow(2), 'Gamma', getGamma(), 'flipAperture', 0, ...
    'spatialFreq', 1/53, 'contrast', 0.05);

runGratingAperture(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
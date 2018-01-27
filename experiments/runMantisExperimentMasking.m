function runMantisExperimentMasking()

expt = struct;

expt.genParamSetFun = @genParamSet_VAR2;

expt.runBeforeTrialFun = @runBeforeTrial_VAR2;

expt.runTrialFun = @runTrial_VAR2;

expt.runAfterTrialFun = @runAfterTrial_VAR2;

expt.runBeforeExptFun = @runBeforeExptFun_VAR2;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisMasking\';

expt.name = 'Mantis Masking';

expt.defName = 'Coline';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {'VAR2', 'HIERODULA', 'SUB'};

runExperiment(expt);

end

%% VAR2

% This is part of the same control experiment as VAR1, but using a live
% mantis. It is identical to the original experiment, with the exception
% that observer responses are not recorded (our aim for the control is
% just to record videos, naive observers will later be asked to judge
% motion direction). The experimenter is aware that the insect in VAR1
% is dead while the one in VAR2 is alive, and so we don't ask them to
% code responses.

function runBeforeExptFun_VAR2()

error('This experiment requires a Gamma value.');

Gamma = 1.1; % TODO: set correct value

createWindow(Gamma);

end

function paramSet = genParamSet_VAR2()

paramSet = genParamSet(); % same as original experiment and VAR1

end

function runBeforeTrial_VAR2(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial_VAR2(paramSetRow)

[exitCode, dump] = runTrial(paramSetRow);

end

function waitEnter()

% Wait until Enter is pressed.

while (1)

    drawnow

    [~, ~, keyCode ] = KbCheck;

    if (keyCode(KbName('Return')))

        break;

    end

end

end

function resultRow = runAfterTrial_VAR2(varargin)

% Return a dummy result. Trial videos are classified later (after the
% experiment) so don't collect experimenter responses.

disp('Press Enter to continue');

waitEnter();

resultRow = nan; % return a dummy result

end

%% VAR1 (control using dead mantis)

function paramSet = genParamSet_VAR1()

paramSet = genParamSet(); % same as original experiment

end

function runBeforeTrial_VAR1(varargin)

% Do not run alignment stimulus before trial, since this is a control
% experiment with a dead animal.

end

function [exitCode, dump] = runTrial_VAR1(paramSetRow)

[exitCode, dump] = runTrial(paramSetRow);

end

function resultRow = runAfterTrial_VAR1(varargin)

% Return dummy results, since this is a control experiment with a dead
% animal.

resultRow = nan;

end

%% Original experiment

function paramSet = genParamSet()

blocks = 5;

noiseMode = [1 2 3];

spatialFreqs = [0.04 0.2]; % cyc/deg

contrast = [0.0625/4 0.0625/2 0.0625 0.125 0.25 0.5];

direction = [-1 1];

paramSet = createRandTrialBlocks(blocks, noiseMode, spatialFreqs, contrast, direction);

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

%noise_values = [0.028 0.056 0; 0.141 0.282 20e-3; 0.028 0.056 100e-3;];

noise_values = [0.028 0.056 0; 0.141 0.282 0.14; 0.028 0.056 0.14;];%%%ISP 26-06-2014


noiseParams = noise_values(paramSetRow(1), :);

expt.rho_min = noiseParams(1);
expt.rho_max = noiseParams(2);
expt.Crmsdesired = noiseParams(3);

expt.bugColor = paramSetRow(1);

expt.spatialFreq = paramSetRow(2);

expt.contrast = paramSetRow(3);

expt.direction = paramSetRow(4);

expt.duration = 5;

[dump] = runGratingNoise(expt);

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end

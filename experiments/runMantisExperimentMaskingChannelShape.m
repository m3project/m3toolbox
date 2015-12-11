function runMantisExperimentMaskingChannelShape()

expt = struct;

expt.genParamSetFun = @genParamSetRUN2_CPD_0p0183_WIDE;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.runBeforeExptFun = @runBeforeExpt;

expt.runChecksFun = @runChecks;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisMaskingChannelShape\';

expt.name = 'Mantis Masking Channel Shape';

expt.defName = 'Will';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.addTags = {'RUN2', 'CPD_0p0183_WIDE'};

runExperiment(expt);

end

%{

evening of 30/7/2015

Steve ran 3 mantids with 0.0183 cpd (each mantis did the WIDE and other
variations): NS71F, NS76F and NS83F

Next I'll ask him to do frequency 0.0885 cpd using the same mantids. NS83F
did this already as part of:

- NS83F 30-07-2015 10.34 (RUN2) (STEVEN)
- NS83F 30-07-2015 11.13 (RUN2) (STEVEN)

(which I need to process to take out the 0.0092 cpd points at which the
mantis had a low response rate)

so this leaves NS71F and NS76F

%}


function paramSet = genParamSet_CPD_0p0885()

blocks = 5;

dirs = [-1 1];

freqsRUN1 = getIgnacioFreqs();

% sfreq1 = 0.0092;
sfreq2 = 0.0885;

% nfreqs1 = sfreq1 * power(sqrt(2), -4:4);
nfreqs2 = freqsRUN1(2) * power(sqrt(2), [-10 -8 -6 -4 -2 0 1 2 3]);

% nfreqs1 = [0 nfreqs1]; % add no-noise condition
nfreqs2 = [0 nfreqs2]; % add no-noise condition

% pSet1 = createTrial(sfreq1, nfreqs1, dirs);
pSet = createTrial(sfreq2, nfreqs2, dirs);

% pSet = [pSet1; pSet2];

nconds = size(pSet, 1);

k = createRandTrialBlocks(blocks, 1:nconds);

paramSet = pSet(k, :);

end


%{

morning of 30/7/2015

Steve ran one mantis (NS83F) which had a low response rate (no noise) = 0.1
at the lower frequency

I spoke with Ignacio and decided to change the lower frequency (0.0092 cpd)
to 0.0183

Before starting with this I asked Steve to run a repeat of the same mantis
(NS83F) with a temporary variation having only the frequency 0.0183. I will
mix this by hand with the 0.088 cpd data he obtained for the same mantis

%}

function paramSet = genParamSetRUN2_CPD_0p0183_WIDE()

blocks = 5;

dirs = [-1 1];

sfreq1 = 0.0185;

nfreqs1 = sfreq1 * power(sqrt(2), (-4:4)*2);

nfreqs1 = [0 nfreqs1]; % add no-noise condition

pSet = createTrial(sfreq1, nfreqs1, dirs);

nconds = size(pSet, 1);

k = createRandTrialBlocks(blocks, 1:nconds);

paramSet = pSet(k, :);

end


function paramSet = genParamSetRUN2_CPD_0p0183()

blocks = 5;

dirs = [-1 1];

sfreq1 = 0.0185;

nfreqs1 = sfreq1 * power(sqrt(2), -4:4);

nfreqs1 = [0 nfreqs1]; % add no-noise condition

pSet = createTrial(sfreq1, nfreqs1, dirs);

nconds = size(pSet, 1);

k = createRandTrialBlocks(blocks, 1:nconds);

paramSet = pSet(k, :);

end

%{

29/7/2015

Today Steven ran two pilot experiments to test the response rates (without
noise) at several frequencies. The results were as follows

Pilot 1 (tag PILOT2):

* 0.0183 cpd (80 trials across 4 mantids), rate = 0.9
* 0.0259 cpd (80 trials across 4 mantids), rate = 0.925

Pilot 2 (tag PILOT3):

* 0.0046 cpd (30 trials across 3 mantids), rate = 0.1
* 0.0065 cpd (30 trials across 3 mantids), rate = 0.267
* 0.0092 cpd (30 trials across 3 mantids), rate = 0.567
* 0.0130 cpd (30 trials across 3 mantids), rate = 0.633

After discussing with Ignacio we decided to go with 0.0092 cpd as our lower
frequency for the next run of the experiment. For the accompanying noise
frequencies we will go with:

0.0366 * power(sqrt(2), [-4] + [-3:4])

Basically that is +/- 2 octaves from the signal frequency

I will now write a genParamSetRUN2 function to implement the above.

As for the higher frequency in this run we will go with what Ignacio and I
agreed on on the 20th: 0.0885 (using same noise frequencies as 0.177 cpd)

%}

function paramSet = genParamSetRUN2()

blocks = 5;

dirs = [-1 1];

freqsRUN1 = getIgnacioFreqs();

sfreq1 = 0.0092;
sfreq2 = 0.0885;

nfreqs1 = sfreq1 * power(sqrt(2), -4:4);
nfreqs2 = freqsRUN1(2) * power(sqrt(2), [-10 -8 -6 -4 -2 0 1 2 3]);

nfreqs1 = [0 nfreqs1]; % add no-noise condition
nfreqs2 = [0 nfreqs2]; % add no-noise condition

pSet1 = createTrial(sfreq1, nfreqs1, dirs);
pSet2 = createTrial(sfreq2, nfreqs2, dirs);

pSet = [pSet1; pSet2];

nconds = size(pSet, 1);

k = createRandTrialBlocks(blocks, 1:nconds);

paramSet = pSet(k, :);

end

%{

Plan for masking experiment

20/7/2015 3pm - after discussion with Ignacio

(A)

For the pilot, try contrast = 0.125 with the following freqs:

0.01833

0.0259

(B)

Then after we find out response rates, we can pick one (let it be x) and then do the full experiment with

x

0.0885 (nb: use same noise frequencies as 0.177 cpd)

nb: use the same ~4 mantids that did the freqs 0.037 and 0.177

(C)

pick up where we left on the experiment: runMantisExperimentMaskingWarpedDeltaNoise

%}


%{

15/7/2015

After a discussion with Ignacio, Vivek and Steven we agreed to try the
following conditions:

0.04 cpd signal frequency (Ignacio's convention), noise will be at:

0.01
0.02
0.028284
0.04
0.056569
0.08
0.11314
0.16

(note: there was an additional point between 0.01 and 0.02 but I took it
out to keep number of noise frequencies 8)

These are : 0.04 * power(sqrt(2), [-4 -2:4])'

while for 0.2 cpd signal frequency, noise will be at:

0.0125
0.025
0.05
0.1
0.2
0.28284
0.4
0.56569

These are : 0.2 * power(sqrt(2), [-8 -6 -4 -2 0 1 2 3])'

All the above will be rendered at a contrast of 0.125 which we selected
based on prelim results from `runMantisExperimentMaskingWarpedDeltaNoise`

Additionally there will be a no-noise condition for each signal frequency
to use as a baseline

20 reps/cond

%}

function paramSet = genParamSet1() %#ok

blocks = 5;

dirs = [-1 1];

signalFreqs = getIgnacioFreqs();

sfreq1 = signalFreqs(1); % signal frequency 1 (0.04 in Ignacio's)
sfreq2 = signalFreqs(2); % signal frequency 2 (0.20 in Ignacio's)

nfreqs1 = sfreq1 * power(sqrt(2), [-4 -2:4]);
nfreqs2 = sfreq2 * power(sqrt(2), [-8 -6 -4 -2 0 1 2 3]);

nfreqs1 = [0 nfreqs1]; % add no-noise condition
nfreqs2 = [0 nfreqs2]; % add no-noise condition

pSet1 = createTrial(sfreq1, nfreqs1, dirs);
pSet2 = createTrial(sfreq2, nfreqs2, dirs);

pSet = [pSet1; pSet2];

nconds = size(pSet, 1);

k = createRandTrialBlocks(blocks, 1:nconds);

paramSet = pSet(k, :);

end

function paramSet = genParamSetPilot()

blocks = 5;

dirs = [-1 1];

% sfreqs = [0.01833 0.0259];

sfreqs = 0.01833 * power(1/sqrt(2), [1:4]);

nfreqs = 0;

paramSet = createRandTrialBlocks(blocks, sfreqs, nfreqs, dirs);

end

function paramSet = genParamSet() %#ok

blocks = 5;

dirs = [-1 1];

signalFreqs = getIgnacioFreqs();

sfreq1 = signalFreqs(1); % signal frequency 1 (0.04 in Ignacio's)
sfreq2 = signalFreqs(2); % signal frequency 2 (0.20 in Ignacio's)

nfreqs1 = sfreq1 * power(sqrt(2), [-6 -4 -2:4]);
nfreqs2 = sfreq2 * power(sqrt(2), [-10 -8 -6 -4 -2 0 1 2 3]);

nfreqs1 = [0 nfreqs1]; % add no-noise condition
nfreqs2 = [0 nfreqs2]; % add no-noise condition

pSet1 = createTrial(sfreq1, nfreqs1, dirs);
pSet2 = createTrial(sfreq2, nfreqs2, dirs);

pSet = [pSet1; pSet2];

nconds = size(pSet, 1);

k = createRandTrialBlocks(blocks, 1:nconds);

paramSet = pSet(k, :);

end

function errorCode = runChecks()

errorCode = 0;

% check resolution

[sW, sH] = getResolution();

if ~isequal([sW sH], [1600 1200])
    
    warning('this experiment was designed for a screen size of 1600 x 1200 px');
    
    errorCode = 1;
    
end

end

function runBeforeExpt()

% apply Gamma correction

Gamma = 1.3476;

createWindow(Gamma);

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

contrast = 0.125;

rms = 0.14; % same rms as masking experiment

apertureDeg = 28.28 * 3;

viewD = 7; % viewing distance (cm)

screenReso = 40; % monitor resolution (px/cm)

signalFreq = paramSetRow(1);

noiseFreq = paramSetRow(2);

if noiseFreq == 0
    
    % special code for no noise condition
    
    rms = 0;
    
end

disp('rendering the stimulus');

args = struct('duration', 5, 'contrast', contrast, ...
    'signalFreq', signalFreq, 'freqRange', [1 1] * noiseFreq, ...
    'dir', paramSetRow(3), 'makePlot', 0, 'rms', rms, ...
    'escapeEnabled', 0, 'apertureDeg', apertureDeg, 'useAperture', 1, ...
    'viewD', viewD, 'screenReso', screenReso, 'temporalFreq', 8);

runGratingWarped(args);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end

function freqs = getIgnacioFreqs()

% calculations:

% we need to render two gratings with spatial periods equal to those of
% Ignacio's 0.04 and 0.2 cpds *at the center of the screen*

% I've worked out the periods of Ignacio's frequencies (by running his
% script and inspecting the generated gratings) and found the following

% 0.04 cpd -> 266.6 px
% 0.20 cpd ->  55.2 px

% now I calculate the angle (alpha) subtended by a single px at the centre
% of the screen

alpha = range(px2deg(2,40,7))/2; % Ignacio is happy with this

% using alpha I calculate the deg spatial periods of Ignacio's 0.04 and 0.2
% cpds as follows

degs = [266.6 55.2] * alpha;

freqs = 1./degs;

% right, so now when I use freqs(1) and freqs(2) to generate the warped
% gratings I will get px periods that are almost equal to Ignacio's 0.04
% and 0.2 cpds *at the screen center*

end
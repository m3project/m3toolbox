function runMantisExperimentMaskingStaircase

expt = struct;

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Jimmy';

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisMaskingStaircase\';

expt.name = 'Mantis Masking Staircase';

conditions = getConditions();

getChannel = @(cond) conditions(cond, 1);

getNoiseSetting = @(cond) conditions(cond, 2);

getStaticNoise = @(cond) conditions(cond, 3);

expt.fun = @(cond, x) runTrial(x, getChannel(cond), ...
    getNoiseSetting(cond), getStaticNoise(cond));

expt.xrange = [-3 0];

expt.steps = 20;

expt.makePlot = 0;

expt.sigma = 5e-2;

expt.pfp = 0.01; % probability of false positive

expt.pfn = 0.01; % probability of false negative

expt.nconds = size(conditions, 1);

%expt.addTags = {'FREQS_8HZ'};

expt.addTags = {'DEBUG_2'};

runStaircaseExperiment(expt);

end

function conditions = getConditions()

% Grid 1:

% channel 1 and 2 had frequencies of 0.04 and 0.2 cpd in this grid

% channel = [1 2];
% 
% noiseSetting = [0 1 2];
% 
% staticNoise = [0 1];

% Grid 2 (16th March 2015):

% channel frequencies for this grid are (0.04 * (1:5)) cpd

% channel = 1:5;
% 
% noiseSetting = 0;
% 
% staticNoise = 0;

% % Grid 3 - DEBUG1 (18th March 2015):
% 
% channel = [1 5];
% 
% noiseSetting = 0;
% 
% staticNoise = 0;

% Grid 4 - DEBUG2 (19th March 2015):

channel = [1 3 5];

noiseSetting = 0;

staticNoise = 0;

% create trial:

conditions = createTrial(channel, noiseSetting, staticNoise);

% remove conditions with noiseSetting=0 and staticNoise=1

% i.e. keep conditions with either noiseSetting~=0 or staticNoise=0

k = conditions(:, 2) | ~conditions(:, 3);

conditions = conditions(k, :);

end


function c = runTrial(x, channel, noiseSetting, staticSetting)

runAnimation2();

contrast = power(10, x);

contrast = min(contrast, 0.5); % crop at 0.5 max

direction = 3 - 2 * randi(2, 1);

runGratingNoiseWrapper(channel, noiseSetting, contrast, direction, staticSetting)

r = getKey();

codedDirection = 0;

if r == 0
    
    codedDirection = -1; % left
    
elseif r == 1
    
    codedDirection = 1; % right
    
end

if codedDirection == 0
    
    c = 0;
    
elseif codedDirection == direction
    
    c = 1;
    
else % codedDirection ~= direction
    
    c = 2;
    
end

end

function runGratingNoiseWrapper(channel, noiseSetting, contrast, direction, staticSetting)

if nargin < 5
    
    clc
    
    channel = 1; % 1 (0.04 cpd) or 2 (0.2 cpd)
    
    noiseSetting = 1; % 0 = none, 1 = same channel, 2 = different channel
    
    contrast = 0.5;
    
    direction = 3 - 2 * randi(2, 1);
    
    staticSetting = 0;
    
end

% grid 1:

% spatialFreqs = [0.04 0.2];
% 
% noiseLevels{1} = [0.141 0.282 0;   0.028 0.056 0.14;   0.141 0.282 0.14;]; %%%ISP 26-06-2014
% 
% noiseLevels{2} = [0.141 0.282 0;   0.141 0.282 0.14;   0.028 0.056 0.14;]; %%%ISP 26-06-2014
% 
% noiseParams = noiseLevels{channel}(noiseSetting+1, :);

% grid 2:

spatialFreqs = 0.04 * (1:5);

noiseParams = [0.141 0.282 0]; % params for zero noise

% other params

expt.spatialFreq = spatialFreqs(channel);

expt.rho_min = noiseParams(1);

expt.rho_max = noiseParams(2);

expt.Crmsdesired = noiseParams(3);

expt.contrast = contrast;

expt.direction = direction;

expt.duration = 2;

expt.Gamma = 1.3476;

expt.staticSetting = staticSetting;

runGratingNoise(expt);

end
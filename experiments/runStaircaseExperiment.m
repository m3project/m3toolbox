% Staircase Function (runStaircase)
% ---------------------------------
%
% Runs a Bayesian staircase given a psychometric function fun and a
% threshold range xrange. Supports multiple conditions
%
% Parameters:
% -----------
%
% fun : a handle to the psychometric in the form fun@(cond, x) where cond
% is the condition and x is the parameter value
%
% steps : number of staircase steps per condition
%
% sigma : used co trade-off estimation precision vs. speed
%
% pfp, pfn: probabilities of false positives and false negatives
% respectively
%
% Returns:
% --------
%
% bestX : best estimates of x for the different conditions
%
% history: a 3D matrix holding staircase step details for each condition
%
% data of condition i are stored in history(:, :, i) in the following
% format:
%
% col 1 : x value passed to fun()
% col 2 : result returned by fun
% col 3 : bestEstimateTheta after step i
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 6/3/2015

function [history] = runStaircaseExperiment(expt, condition)

cleanupObj1 = onCleanup(@signout);

signin();

% default parameters:

fun = @(cond, x) blackBoxPsychometric(cond, x);

nconds = 5;

xrange = [1 100];

steps = 30; % staircase steps

sigma = 20;

pfp = 0.01; % probability of false positive

pfn = 0.01; % probability of false negative

makePlot = 0;

workDir = 'D:\test experiment\';

name = 'Test Experiment';

runBeforeStepFun = @() 1; % dummy

runAfterStepFun = @() 1; % dummy

recordVideos = 1;

makeBackup = 1;

addTags = {};

defName = '';

% load overrides:

if nargin > 0
    
    unpackStruct(expt);
    
end

if strcmp(getenv('computername'), 'READLAB14')
    
    recordVideos = 0;
    
    makeBackup = 0;
    
    warning('running on Ghaith''s desktop machine, backup and video recording disabled');
    
end

% choose experiment directory

exptDir = chooseExperimentDir(name, workDir, defName, addTags);

if isempty(exptDir)
    
    return
    
end

fullDir = fullfile(workDir, exptDir);

if exist(fullDir, 'dir')
    
    error('Directory %s already exists', fullDir);
    
end

mkdir(fullDir);

hardwareInfoFile = fullfile(fullDir, 'hardware_info.mat');

paramsFile = fullfile(fullDir, 'params.mat');

resultsFile = fullfile(fullDir, 'results.mat');

trialVideoFile      = fullfile(fullDir, 'trial%u.mp4');

% pre-experiment preparation (dump hardware info & code backup)

hardwareInfo = getHardwareInfo(); %#ok

save(hardwareInfoFile, 'hardwareInfo');

if makeBackup
    
    backupToolbox(fullDir);
    
end

% initialize camera

if recordVideos
    
    cam1 = initCam(); % initialize camera
    
    deallocCam1 = @() deallocCam(cam1);
    
    cleanupObj2 = onCleanup(deallocCam1);
    
end



% loop vars:

priorsLength = 1e3;

xmin = xrange(1);

xmax = xrange(2);

xstep = (xmax - xmin) / (priorsLength - 1);

xvals = (xmin:xstep:xmax)';

priors = ones(priorsLength, nconds);

sequence = createRandTrialBlocks(steps, 1:nconds);

% uncomment below to change to non-interleaved staircases

% sequence = reshape(ones(steps, 1) * (1:nconds), [steps*nconds 1]);

progress = zeros(nconds, 1);

n = size(sequence, 1);

history = nan(steps, 3, nconds);

% loop:

ticID = tic;

for j=1:n
    
    home;
    
    fprintf('Experiment Folder:\n\n%s\n\n', fullDir);
    
    fprintf('Trial %3i of %3i (%3.1f%%) ... \n\n', j, n, j/n*100);
    
    if (j>2)
        
        elaspedTime = toc(ticID);
        
        totalTime = elaspedTime / (j-1) * n;
        
        remainingTime = totalTime - elaspedTime;
        
        avgTime = elaspedTime/j;
        
        fprintf('Time Spent       : %s\n', datestr(elaspedTime/3600/24, 'HH:MM:SS'));
        
        fprintf('Time Total       : %s\n', datestr(totalTime/3600/24, 'HH:MM:SS'));
        
        fprintf('Remaining        : %s\n', datestr(remainingTime/3600/24, 'HH:MM:SS'));
        
        fprintf('Time (per trial) : %s\n', datestr(avgTime/3600/24, 'HH:MM:SS'));
        
        fprintf('\n');
        
    end
    
    cond = sequence(j); % condition of current iteration
    
    progress(cond) = progress(cond) + 1;
    
    i = progress(cond);
    
    k = getMeanIndex(priors(:, cond));
    
    x = xvals(k);
    
    % run pre-step function:
    
    runBeforeStepFun();
    
    % run step function:
    
    if recordVideos
        
        % start recording
        
        startRecording(cam1);
        
    end
    
    result = fun(cond, x);
    
    try
        
        if recordVideos
            
            % save and compress video
            
            stopRecording(cam1);
            
            %outputFile = sprintf(trialVideoFile, i);
            
            outputFile = strrep(trialVideoFile, '%u', num2str(j));
            
            saveMP4(cam1, outputFile);
            
        end
        
    catch except1 %#ok
        
        warning('Could not save video');
        
    end
    
    % run post-step function:
    
    runAfterStepFun();
    
    % updating priors:
    
    F = psychometric(x, xvals, sigma);
    
    if result == 0 % not moving
        
        likelihood = (1-F) * (1-pfp) + F * pfn;
        
    elseif result == 1 % moving in correct direction
        
        likelihood = (1-F) * pfp/2 + F * (1 - pfn);
        
    elseif result == 2 % moving in incorrect direction
        
        likelihood = (1-F) * pfp/2;
        
    else
        
        error('incorrect value');
        
    end
    
    posteriori = normV(priors(:, cond) .* likelihood);
    
    priors(:, cond) = posteriori;
    
    [~, k] = max(posteriori);
    
    bestEstimateTheta = xvals(k);
    
    history(i, :, cond) = [x result bestEstimateTheta];
    
    resultSet = transp(squeeze(history(steps, 3, :))); %#ok
    
    save(resultsFile, 'resultSet', 'history');
    
    % must also save a dummy paramSet for backward compatibility with
    % loadDirData
    
    paramSet = condition; %#ok
    
    save(paramsFile, 'paramSet');
    
    if mod(i, 1) == 0 && makePlot
        
        % plots
        
        figure(cond);
        
        set(cond, 'Name', sprintf('Condition %d', cond));
        
        subplot(3, 2, 1:2);
        
        plot(xvals, F); xlabel('x');
        
        strTitle = sprintf('psychometric (x=%1.2e)', x);
        
        title(strTitle);
        
        subplot(3, 2, 3:4);
        
        plot(xvals, likelihood);
        
        xlabel('\theta'); title('likelihood');
        
        subplot(3, 2, 5);
        
        plot(xvals, posteriori);
        
        xlabel('x'); title('updated priors');
        
        ylim([0 1]);
        
        subplot(3, 2, 6);
        
        plot(1:steps, history(:, 3, cond));
        
        strTitle = sprintf('most-likely x = %1.2f', bestEstimateTheta);
        
        xlabel('trials'); title(strTitle);
        
        axis([1 steps xmin xmax]);
        
        drawnow
        
    end
    
end

disp('Experiment completed');

end

function y = psychometric(x, theta, sigma)

y = 0.5 * (1+erf((x-theta)/sqrt(2)/sigma));

end

function c = blackBoxPsychometric(cond, x)

thetas = 20:10:100;

theta = thetas(cond);

sigma = 10;

perr1 = 0.1;

perr2 = 0.1;

c = 0.5 * (1 + erf((x-theta)/sqrt(2)/sigma)) > 0.5;

if rand<perr1
    
    c = 1-c;
    
elseif rand<perr2
    
    c = 2;
    
end

end

function x = getMeanIndex(priors)

% edited by Jenny on 23rd April 2015:

% (Jenny found out that my previous implementation was choosing the
% *median* as opposed to the mean, she didn't think this would make much of
% a difference).

% FInds median
% c = cumsum(priors);

% m = c(end);

% x = find(c > m/2, 1, 'first');

% Finds mean?
xx = (1:length(priors))';
%mean
% m = sum(xx.*priors)./sum(priors);
m = trapz(xx,xx.*priors)./trapz(xx,priors);
% difference between xx and mean is
df = abs(xx-m);
% find the one that is closest to the mean:
[~,x] = min(df);


end


function y = normV(x)

y = x / max(x);

end

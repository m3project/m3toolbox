function runExperiment_motionSpiral_temp(expt)

%checkGhaithComputer();

obj1 = onCleanup(@cleanup);

signin();

% initialize experiment settings:

workDir             = 'D:\test experiment\';

genParamSetFun      = @genParamSet;

runBeforeTrialFun   = @runBeforeTrial;

runTrialFun         = @runTrial;

runAfterTrialFun    = @runAfterTrial;

runBeforeExptFun    = @runBeforeExpt;

runAfterExptFun     = @runAfterExpt;

runChecksFun        = @runChecks;

recordVideos        = 0;

makeBackup          = 1;

resultSet           = [];

name                = 'Test Experiment';

addTags             = {};

defName             = '';

if nargin>0

    unpackStruct(expt); % unpack overloaded settings from expt

end

pc = getenv('computername');

if isequal(pc, 'READLAB14') || isequal(pc, 'READLAB12')

    recordVideos = 0;

    makeBackup = 0;

    runChecksFun = @runChecks;

    warning('running on Ghaith/Vivek''s desktop machine: backup, video recording and hardware check all disabled');

end

if runChecksFun() == 1

    error('current machine/configuration is incompatible with this experiment');

end

% if the 'continue experiment' option is selected in the
% chooseExperimentDir dialog then the function will return the

paramSet = genParamSetFun();

ntrials = size(paramSet, 1);

[exptDir, contExpt] = chooseExperimentDir(name, workDir, defName, ...
    addTags, ntrials);

if isempty(exptDir)

    return

end

if contExpt

    fullDir = exptDir;

else

    % check if directory exists

    fullDir = fullfile(workDir, exptDir);

    if exist(fullDir, 'dir')

        error('Directory %s already exists', fullDir);

    end

    mkdir(fullDir);

end

% adjust recording camera

home;

if recordVideos

    disp('Adjust recording camera');

    previewRecordingCam();

    drawnow

end

% pre-experiment preparation:

trialVideoFile      = fullfile(fullDir, 'trial%u.mp4');

paramFile           = fullfile(fullDir, 'params.mat');

resultsFile         = fullfile(fullDir, 'results.mat');

hardwareInfoFile    = fullfile(fullDir, 'hardware_info.mat');

if contExpt

    if ~exist(paramFile, 'file')

        error('The selected folder does not contain experiment data');

    end

    load(paramFile);

    if exist(resultsFile, 'file')

        load(resultsFile);

    end

else

    hardwareInfo = getHardwareInfo(); %#ok

    save(paramFile, 'paramSet');

    save(hardwareInfoFile, 'hardwareInfo');

    if makeBackup

        backupToolbox(fullDir);

    end

end

if recordVideos

    cam1 = initCam(); % initialize camera

    deallocCam1 = @() deallocCam(cam1);

    cleanupObj2 = onCleanup(deallocCam1);
    
    startRec = @() startRecording(cam1);
    
    stopRec = @() stopRecording(cam1);

else
    
    startRec = @() [];
    
    stopRec = @() [];
    
end

runBeforeExptFun();

% start trials

trialCount = size(paramSet, 1);

firstTrial = size(resultSet, 1) + 1;

remTrials = trialCount - firstTrial + 1; % number of remaining trials

exitCode = 0;

ticID = tic;

% determine if runTrialFun will manage video recording on its own:

isManagedRecording = nargin(runTrialFun) == 3;

% trial loop

for i=firstTrial:trialCount

    home;

    j = i - firstTrial + 1;

    fprintf('Experiment Folder:\n\n%s\n\n', fullDir);

    fprintf('Trial %3i of %3i (%3.1f%%) ... \n\n', i, trialCount, i/trialCount*100);

    if (j>2)

        elaspedTime = toc(ticID);

        totalTime = elaspedTime / (j-1) * remTrials;

        remainingTime = totalTime - elaspedTime;

        avgTime = elaspedTime/j;

        fprintf('Time Spent       : %s\n', datestr(elaspedTime/3600/24, 'HH:MM:SS'));

        fprintf('Time Total       : %s\n', datestr(totalTime/3600/24, 'HH:MM:SS'));

        fprintf('Remaining        : %s\n', datestr(remainingTime/3600/24, 'HH:MM:SS'));

        fprintf('Time (per trial) : %s\n', datestr(avgTime/3600/24, 'HH:MM:SS'));

        fprintf('\n');

    end

    paramSetRow = paramSet(i, :);

    runBeforeTrialFun(paramSetRow);

    if ~isManagedRecording

        startRec();

    end

    % run trial code:

    if isManagedRecording

        runFun = @() runTrialFun(paramSetRow, startRec, stopRec);

    else

        runFun = @() runTrialFun(paramSetRow);

    end

    if nargout(runTrialFun) == 2

        exitCode = runFun();

    else

        runFun(); exitCode = 0;

    end

    if (exitCode ~= 0)

        disp('aborted'); break;

    end

    try

        if recordVideos

            if ~isManagedRecording

                % save and compress video

                stopRec();

            end

            outputFile = strrep(trialVideoFile, '%u', num2str(i));

            saveMP4(cam1, outputFile);

        end

    catch except1 %#ok

        warning('Could not save video');

    end

    % run after-trial code:

    resultRow = runAfterTrialFun(paramSetRow);

    resultSet(i, :) = resultRow; %#ok

    % save results

    save(resultsFile, 'resultSet');

end

if trialCount == 0

    error('This experiment contains no trials');

end

runAfterExptFun();

if exitCode == 0

    disp('Experiment completed');

else

    disp('Experiment aborted');

end

end

function paramSet = genParamSet()

% template function

warning('Please overload genParamSet()');

a = [1 2 3];

b = [-1 1];

paramSet = createRandTrial(a, b);

end

function runBeforeTrial(varargin)

% template function

warning('Please overload runBeforeTrial()');

end

function [exitCode, dump] = runTrial(paramSetRow) %#ok

% template function

warning('Please overload runTrial()');

exitCode = 0; dump = [];

end

function resultRow = runAfterTrial(varargin)

% template function

warning('Please overload runAfterTrial()');

disp('Press any key to continue'); pause;

resultRow = 1;

end

function cleanup()

signout();

closeWindow();

commandwindow();

ShowCursor();

end

function runBeforeExpt()

% template function

end

function runAfterExpt()

% template function

end

function errorCode = runChecks()

% template function

errorCode = 0;

end
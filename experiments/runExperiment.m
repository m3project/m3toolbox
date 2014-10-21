function runExperiment(expt)

try
    
    % initialize experiment settings:
    
    workDir             = 'D:\test experiment\';
    
    genParamSetFun      = @genParamSet;
    
    runBeforeTrialFun   = @runBeforeTrial;
    
    runTrialFun         = @runTrial;
    
    runAfterTrialFun    = @runAfterTrial;
    
    recordVideos        = 0;
    
    makeBackup          = 1;
    
    resultSet           = [];
    
    dumps               = cell(1, 1);
    
    name                = 'Test Experiment';
    
    addTags             = {};
    
    defName             = '';
    
    if nargin>0
        
        unpackStruct(expt); % unpack overloaded settings from expt
        
    end
    
    exptDir = chooseExperimentDir(name, workDir, defName, addTags);
    
    if isempty(exptDir)
        
        return
        
    end
    
    fullDir = fullfile(workDir, exptDir);
    
    if exist(fullDir, 'dir')
        
        error('Directory %s already exists', fullDir);
        
    end
    
    mkdir(fullDir);        
    
    paramSet = genParamSetFun();
    
    hardwareInfo = getHardwareInfo();
    
    % pre-experiment preparation:
    
    trialVideoFile      = fullfile(fullDir, 'trial%u.mp4');
    
    paramFile           = fullfile(fullDir, 'params.mat');
    
    resultsFile         = fullfile(fullDir, 'results.mat');  
    
    dumpsFile           = fullfile(fullDir, 'dumps.mat');
    
    hardwareInfoFile    = fullfile(fullDir, 'hardware_info.mat');
    
    trialCount          = size(paramSet, 1);    
    
    save(paramFile, 'paramSet');
    
    save(hardwareInfoFile, 'hardwareInfo');
    
    if makeBackup
        
        backupToolbox(fullDir);
        
    end
    
    if recordVideos
    
        cam1 = initCam(); % initialize camera
        
    end
    
    % start trials
    
    ticID = tic;
    
    for i=1:trialCount
        
        clc;
        
        fprintf('Experiment Folder:\n\n%s\n\n', fullDir);
        
        fprintf('Trial %3i of %3i (%3.1f%%) ... \n\n', i, trialCount, i/trialCount*100);
        
        if (i>2)
            
            elaspedTime = toc(ticID);
            
            totalTime = elaspedTime / (i-1) * trialCount;
            
            remainingTime = totalTime - elaspedTime;
            
            avgTime = elaspedTime/i;
            
            fprintf('Time Spent       : %s\n', datestr(elaspedTime/3600/24, 'HH:MM:SS'));
            
            fprintf('Time Total       : %s\n', datestr(totalTime/3600/24, 'HH:MM:SS'));
            
            fprintf('Remaining        : %s\n', datestr(remainingTime/3600/24, 'HH:MM:SS'));
            
            fprintf('Time (per trial) : %s\n', datestr(avgTime/3600/24, 'HH:MM:SS'));
            
            fprintf('\n');
            
        end
        
        paramSetRow = paramSet(i, :);
        
        % run before-trial code:
        
        runBeforeTrialFun(paramSetRow);
        
        if recordVideos
            
            % start recording
            
            startRecording(cam1);
            
        end
        
        % run trial code:
        
        [exitCode, dump] = runTrialFun(paramSetRow);
        
        dumps{i} = dump;
        
        if (exitCode ~= 0)
            
            disp('aborted'); break;
            
        end
        
        try
            
            if recordVideos
                
                % save and compress video
                
                stopRecording(cam1);
                
                %outputFile = sprintf(trialVideoFile, i);
                
                outputFile = strrep(trialVideoFile, '%u', num2str(i));
                
                saveMP4(cam1, outputFile);
                
            end
            
        catch except1
            
            warning('Could not save video');
            
        end
        
        % run after-trial code:
        
        resultRow = runAfterTrialFun(paramSetRow);
        
        resultSet(i, :) = resultRow;
        
        % save results
        
        save(resultsFile, 'resultSet');     
        
        save(dumpsFile, 'dumps');
        
    end
    
    if trialCount == 0
       
        error('This experiment contains no trials');
        
    end
    
    if exitCode == 0
        
        disp('Experiment completed');
        
    else
        
        disp('Experiment aborted');
        
    end
    
    if recordVideos
    
        deallocCam(cam1);
        
    end
    
catch exception
    
    try

        if recordVideos
            
            deallocCam(cam1);
        
        end
        
    catch
        
        %error('error deallocating camera');
        
    end
    
    rethrow(exception);    
    
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

function [exitCode, dump] = runTrial(paramSetRow)

% template function

warning('Please overload runTrial()');

exitCode = 0; dump = [];

end

function resultRow = runAfterTrial(varargin)

% template function

warning('Please overload runAfterTrial()');

disp('Press any key to continue'); pause;

resultRow = [1];

end



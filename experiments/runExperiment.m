function runExperiment(expt)

try
    
    % initialize experiment settings:
    
    workDir             = 'C:\';
    
    genParamSetFun      = @genParamSet;
    
    runBeforeTrialFun   = @runBeforeTrial;
    
    runTrialFun         = @runTrial;
    
    runAfterTrialFun    = @runAfterTrial;
    
    recordVideos        = 1;
    
    resultSet           = zeros(1, 1);
    
    dumps               = cell(1, 1);
    
    if nargin>0
        
        unpackStruct(expt); % unpack overloaded settings from expt
        
    end
    
    paramSet = genParamSetFun();
    
    % pre-experiment preparation:
    
    trialVideoFile      = [workDir 'trial%u.mp4'];
    
    paramFile           = [workDir 'params.mat'];
    
    resultsFile         = [workDir 'results.mat'];  
    
    dumpsFile           = [workDir 'dumps.mat'];
    
    trialCount          = size(paramSet, 1);    
    
    save(paramFile, 'paramSet');
    
    if recordVideos
    
        cam1 = initCam(); % initialize camera
        
    end
    
    % start trials
    
    ticID = tic;
    
    for i=1:trialCount
        
        clc;
        
        fprintf('Trial %3i of %3i (%3.1f%%) ... \n', i, trialCount, i/trialCount*100);
        
        if (i>2)
            
            elaspedTime = toc(ticID);
            
            totalTime = elaspedTime / (i-1) * trialCount;
            
            remainingTime = totalTime - elaspedTime;
            
            avgTime = elaspedTime/i;
            
            fprintf('Time Spent       : %s\n', datestr(elaspedTime/3600/24, 'HH:MM:SS'));
            
            fprintf('Time Total       : %s\n', datestr(totalTime/3600/24, 'HH:MM:SS'));
            
            fprintf('Remaining        : %s\n', datestr(remainingTime/3600/24, 'HH:MM:SS'));
            
            fprintf('Time (per trial) : %s\n', datestr(avgTime/3600/24, 'HH:MM:SS'));
            
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
        
        if recordVideos
            
            % save and compress video
            
            stopRecording(cam1);
            
            %outputFile = sprintf(trialVideoFile, i);
            
            outputFile = strrep(trialVideoFile, '%u', num2str(i));
            
            saveMP4(cam1, outputFile);
            
        end
        
        % run after-trial code:
        
        resultRow = runAfterTrialFun(paramSetRow);
        
        resultSet(i, :) = resultRow;
        
        % save results
        
        save(resultsFile, 'resultSet');     
        
        save(dumpsFile, 'dumps');
        
    end
    
    if recordVideos
    
        deallocCam(cam1);
        
    end
    
catch exception
    
    try

        if recordVideos == 1
            
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

error('Please overload genParamSet()');

end

function runBeforeTrial(varargin)

% template function

error('Please overload runBeforeTrial()');

end

function [exitCode, dump] = runTrial(paramSetRow)

% template function

error('Please overload runTrial()');

end

function resultRow = runAfterTrial(varargin)

% template function

error('Please overload runAfterTrial()');

end



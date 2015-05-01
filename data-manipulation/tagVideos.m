% This script will play the trial videos in the folder where it is ran.
% For each video it will ask the user to input numeric values for a number
% of parameters (specified in colNames). The values are stored in a file
% results2.mat which is placed in the same directory.
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk)
%
% 5/12/2013

function tagVideos(outputFile, colNames)

if nargin < 1
    
    outputFile = 'results2.mat';
    
end

if nargin<2    
    
    colNames = {'Tracks', 'Strikes', 'Tension'};
    
end

% colNames = {'Attack', 'Antennae Motion'};
% colNames = {'Response (up=no-follow, down=follow-straight, and left/right): '};

dir = pwd;

paramsFile = fullfile(dir, 'params.mat');

resultsFile = fullfile(dir, 'results.mat');

resultsFile2 = fullfile(dir, outputFile);

if ~exist(paramsFile, 'file') || ~exist(resultsFile, 'file')
    
    error(['Could not locate params and results files ' ...
        '(are you sure you are in an experiment results folder?)']);
    
end

load(paramsFile);

load(resultsFile);

n = size(paramSet, 1);

m = length(colNames);

% make sure all video files are present before starting

for i=1:n
    
    vfile = sprintf('trial%i.mp4', i);
    
    vpath = fullfile(dir, vfile);
    
    if ~exist(vpath, 'file')
        
        msg = ['could not locate file ' vfile];
        
        %error(msg);
        
        warning('this experiment is incomplete.')
        
    end
    
end

for i=1:n
    
    vfile = sprintf('trial%i.mp4', i);
    
    vpath = fullfile(dir, vfile);
    
    if ~exist(vpath, 'file')
        
        warning('Could not locate file %s, skipping ...', vfile);
        
        continue;
        
    end
    
    clc;
    
    fprintf('Playing file %s (%d out of %d) ...\n\n', vfile, i, n);
    
    playMP4(vpath);
    
    fprintf('Enter parameters (or hit enter to replay video) ...\n\n');
    
    j = 1;
    
    newResultSet.colNames = colNames;
    
    while j<=m
        
        v = prompt1(colNames{j});      
        
        if isempty(v)
            
            playMP4(vpath);
            
            continue;
            
        end
        
        newResultSet.values(i, j) = v;
        
        j = j+1;
        
    end
    
    save(resultsFile2, 'newResultSet');
    
end

end

function v = prompt2(colName)

KbName('UnifyKeyNames');

prompt = sprintf('%s : ', colName);

disp(prompt);

v = -1;

while v == -1

    [~, KeyCode] = KbPressWait;
    
    if KeyCode(KbName('UpArrow'))
        
        v = 0;
        
    elseif KeyCode(KbName('LeftArrow'))
        
        v = 1;
        
    elseif KeyCode(KbName('RightArrow'))
        
        v = 2;
        
    elseif KeyCode(KbName('DownArrow'))
        
        v = 3;
        
    elseif KeyCode(KbName('Return'))
        
        v = [];        
        
    end
    
end



end

function v = prompt1(colName)

prompt = sprintf('%s : ', colName);

s = input(prompt, 's');

v = str2double(s);

if isempty(s)
    
    
    
    v = [];
    
    return;
    
end

if isnan(v) || ~isreal(v)
    
    disp('Incorrect input, please re-enter.')
    
    v = [];
    
    return;
    
end

end
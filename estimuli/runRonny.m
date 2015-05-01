function runRonny(funcs)

clc;

%% settings

rootExptsPath = 'V:\readlab\Ronny\runRonny Experiments';

dStr = lower(datestr(now,'yyyy-mm-dd-HHMM.SS'));

logFileName = 'params_log.txt';

enableFileLogging = 0;

%% creating experiment folder and log file

exptPath = fullfile(rootExptsPath, dStr);

mkdir(exptPath);

if enableFileLogging
    
    logFilePath = fullfile(exptPath, logFileName);
    
    fid = fopen(logFilePath, 'w');
    
    if fid == -1
        
        error('Could not open log file for writing');
        
    end
    
    logVersion(fid);
    
    logEvent_w = @(varargin) logEvent(fid, varargin{:});
    
else
    
    logEvent_w = @(varargin) 1;
    
end

%% backup

a = input('Backup the toolbox source code (type NO to skip, press Enter to proceed)? ', 's');

if isequal(lower(a), 'no')
    
    warning('skipped backup ...');
    
else
    
    backupToolbox(exptPath);
    
    hardwareInfo = getHardwareInfo;
    
    hardwareInfoFile = fullfile(exptPath, 'hardware_info.mat');
    
    save(hardwareInfoFile, 'hardwareInfo');
    
end

if nargin < 1

    funcs = {@runDiscLoom, @runGratingwithMenu, @runTargetwithMenuAnaglyph, @runSwirlAnaglyph, @runDotsAnaglyph_ephys, @runLargeField, @runCorrDots, @runBarScan, @runFieldBars};

end

closeWindow(); % make sure any existing windows are closed

%% stimuli loop

i = 1;

while 1
    
    HideCursor
    
    clc
    
    disp(funcs{i});
    
    exitCode = funcs{i}(logEvent_w); % call stimulus function
    
    closeWindow(); % close window afterwards
    
    if exitCode == 1
        
        break
        
    elseif exitCode >= 100
        
        % this is a special exit code to switch stimuli
        
        j = exitCode - 100;
        
        if j <= length(funcs)
            
            i = j;
            
        end
        
    else
        
        i = mod(i, length(funcs)) + 1;
        
    end
    
    pause(0.2);
    
end

ShowCursor

if enableFileLogging

    fclose(fid);
    
end

end

function logEvent(fid, varargin)

tStr = datestr(now,'HHMM.SS.FFF');

eStr = sprintf(varargin{:});

fprintf(fid, '[%s] [%1.2f] : %s\r\n', tStr, GetSecs, eStr);

end

function logVersion(fid)

header = {
    '# Log File Version : 1.0'
    '#'
    '# Format: [%TIMESTAMP1%] [%TIMESTAMP2%] : %EVENT%'
    '#'
    '# %TIMESTAMP1% is obtained using datestr(now,''HHMM.SS.FFF'')'
    '# %TIMESTAMP2% is obtained using GetSecs()'
    '#'
    };

for i=1:length(header)
    
    fprintf(fid, '%s\r\n', header{i});
    
end

end
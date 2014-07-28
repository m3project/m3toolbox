% Zips the toolbox root directory and saves the zipped archive in dstDir
%
% Ghaith Tarawneh - 29/05/2014
%
function backupToolbox(dstDir)

% check if dstDir exists

if ~exist(dstDir, 'dir')
    
    error('specified destination directory does not exist')
    
end

% export code

toolboxDir = getM3Path();

dStr = lower(datestr(now,'mmm-dd-yyyy-HHMM'));

filename = sprintf('toolbox-%s.zip', dStr);

fullDst = fullfile(dstDir, filename);

disp('backing up toolbox source code ...');

zip(fullDst, toolboxDir);

end

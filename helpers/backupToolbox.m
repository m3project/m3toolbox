% Zips the toolbox root directory and saves the zipped archive in dstDir
%
% (21/10/2014) : added ignore rules (with an entry for .git)
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk)- 29/05/2014
%
function backupToolbox(dstDir)

% check if dstDir exists

if ~exist(dstDir, 'dir')
    
    error('specified destination directory does not exist')
    
end

% export code

ignoreList = {'.', '..', '.git'};

myList = dir(M3);

for i=1:length(ignoreList)
    
    k = strcmp({myList.name}, ignoreList{i});
    
    myList(k) = [];    
    
end

n = {myList.name}'; % list of all files and folders in root toolbox dir

[rootpath, rootname] = fileparts(M3);

n = fullfile(rootname, n);

dStr = lower(datestr(now,'mmm-dd-yyyy-HHMM'));

filename = sprintf('toolbox-%s.zip', dStr);

fullDst = fullfile(dstDir, filename);

disp('backing up toolbox source code ...');

zip(fullDst, n, rootpath)

end


% adds M3 toolbox sub-directories to Matlab's path
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/10/2014

function setupM3()

ignoreList = {'.', '..', '.git', 'deprecated', 'camo_new'};

myList = dir;

myList(~[myList.isdir]) = []; % remove files

for i=1:length(ignoreList)
    
    k = strcmp({myList.name}, ignoreList{i});
    
    myList(k) = [];    
    
end

rootDir = pwd;

for i=1:length(myList)
    
    fullsubdir = fullfile(rootDir, myList(i).name);
    
    paths = genpath(fullsubdir);
    
    addpath(paths);
    
end

disp('M3 toolbox has been setup successfully.');

end


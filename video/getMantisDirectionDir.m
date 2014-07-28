function [paramSet, directions, pmisses] = getMantisDirectionDir(dir)

if nargin < 1
    
    dir = 'd:\mantisVideoCapture\F10 28-04-2014 15.54 (10) (GHAITH)\';
    
end

paramSet = [];

pFile = fullfile(dir, 'params.mat');

load(pFile);

trials = size(paramSet, 1);

directions = nan(trials, 1);

pmisses = nan(trials, 1);

for i=1:trials
   
    vFile = sprintf('trial%d.mp4', i);
    
    vFullFile = fullfile(dir, vFile);
    
    [d, pmiss] = getMantisDirection(vFullFile);
    
    if ~isnan(d)
        fprintf('*');
    else
        fprintf(' ');
    end
    
    directions(i, :) = d;
    
    pmisses(i, :) = pmiss;
    
end

end
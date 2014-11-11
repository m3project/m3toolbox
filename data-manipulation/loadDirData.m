% This function loads params.mat and results.mat from all
% sub-directories of a specified directory (dir).
%
% It returns the concatenated paramSet and resultSet.
%
function [paramSet, resultSet] = loadDirData(dir, include, exclude, allowIncomplete, mustIncludeAll)

if nargin < 4
    
    allowIncomplete = 0;
    
end

if nargin < 5
    
    mustIncludeAll = 0;
    
end

paramFile = 'params.mat';

resultsFile = 'results.mat';

list = getDirList(dir, include, exclude, mustIncludeAll);

n = size(list, 1); % number of sub-directories

paramSet = [];

resultSet = [];

uniqueParamSet = []; % used to verify that the content of all loaded paramSets are identical

hashes = {};

for i=1:n
    
    dirI = strtrim(list{i});
    
    % loading data from dir
    
    fullPathI = fullfile(dir, dirI);
    
    pFile = fullfile(fullPathI, paramFile);
    
    rFile = fullfile(fullPathI, resultsFile);

    if ~exist(pFile, 'file')
        
        fprintf('Loading %-60s (param file not found, ignored) ...\n', dirI);
        
        continue;        
        
    end
    
    if ~exist(rFile, 'file')
        
        fprintf('Loading %-60s (results file not found, ignored) ...\n', dirI);
        
        continue;        
        
    end    
    
    fileData1 = load(pFile);
    fileData2 = load(rFile);
    
    n1 = size(fileData1.paramSet, 1);
    n2 = size(fileData2.resultSet, 1);
    
    if n1 ~= n2 && ~isfield(fileData2.resultSet, 'app') && ~allowIncomplete
        
        % the second term in the expression above is to allow loading data
        % from one of Vivek's experiments which has stores data in
        % resultSet differently
       
        fprintf('Loading %-60s (either incomplete or in progress, ignored) ...\n', dirI);
        
        continue;
        
    end
    
    k1 = size(fileData1.paramSet, 1);
    k2 = size(fileData2.resultSet, 1);
    
    if k1 ~= k2
        
        fileData1.paramSet = fileData1.paramSet(1:k2, :);
        
    end
        
        
    
    paramSet = [paramSet; fileData1.paramSet];
    
    resultSet = [resultSet; fileData2.resultSet];
    
    
    
    hash = DataHash(sort(fileData1.paramSet));
    
    if ~ismember(hash, hashes)
        
        hashes = [hashes hash];
        
    end
    
    k = find(ismember(hashes, hash));
    
    fprintf('Loading %-60s (%4d points, Parameter Set %c) ...\n', dirI, size(fileData1.paramSet, 1), 'A' + k-1);
    
    if isempty(uniqueParamSet)
        
        uniqueParamSet = fileData1.paramSet;
        
    end
    
    if ~isequal(sort(uniqueParamSet), sort(fileData1.paramSet))
        
        % error('The folder "%s" contains a different set of sampling points.', dirI);
        
    end    
    
end

if size(paramSet, 1) == 0
    
    warning('no data points were loaded by loadDirData()');
    
end

end

% This function loads params.mat and results.mat from all
% sub-directories of a specified directory (dir).
%
% It returns the concatenated paramSet and resultSet.
%
function [paramSet, resultSet] = loadDirData(dir, include, exclude)

if nargin < 2
    include = {};
end

if nargin < 3
    exclude = {};
end

paramFile = 'params.mat';

resultsFile = 'results.mat';

dirFilter = [dir './F*'];

dirs = ls(dir);

dirs = dirs(3:end, :); % ls returns . and .. as the first two entries

n = size(dirs, 1); % number of sub-directories

paramSet = [];

resultSet = [];

uniqueParamSet = []; % used to verify that the content of all loaded paramSets are identical

hashes = {};

for i=1:n
    
    dirI = strtrim(dirs(i, :));
    
    % note: exclude filters take priority over include filters
    
    % applying include filter
    
    if ~isempty(include)
        
        keep = 0;
        
        for j=1:length(include)
            
            ind = strfind(dirI, include{j});
            
            if ~isempty(ind)
                
                keep = 1; break;
                
            end
            
        end
        
        if ~keep
            
            continue
            
        end
        
    end
    
    % applying exclude filter
    
    if ~isempty(exclude)
        
        for j=1:length(exclude)
            
            keep = 1;
            
            ind = strfind(dirI, exclude{j});
            
            if ~isempty(ind)
                
                keep = 0; break;
                
            end
            
        end
        
        if ~keep
            
            continue
            
        end
        
    end
    
    % loading data from dir
    
    fullPathI = [dir '\' dirI];
    
    pFile = [fullPathI '\' paramFile];
    
    rFile = [fullPathI '\' resultsFile];

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
    
    if n1 ~= n2
       
        fprintf('Loading %-60s (either incomplete or in progress, ignored) ...\n', dirI);
        
        continue;
        
    end
    
    paramSet = [paramSet; fileData1.paramSet];
    
    resultSet = [resultSet; fileData2.resultSet];
    
    hash = DataHash(sort(fileData1.paramSet));
    
    if ~ismember(hash, hashes)
        
        hashes = [hashes hash];
        
    end
    
    %     k = strfind(hashes, hash);
    
    %     k = find(k{:});
    
    k=find(ismember(hashes, hash));
    
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

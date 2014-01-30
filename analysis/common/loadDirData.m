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

dirs = ls(dirFilter);

n = size(dirs, 1); % number of sub-directories

paramSet = [];
resultSet = [];

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
    
    fileData1 = load(pFile);
    fileData2 = load(rFile);
    
    paramSet = [paramSet; fileData1.paramSet];
    
    resultSet = [resultSet; fileData2.resultSet];
    
    %sum(abs(fileData2.resultSet))
    
    fprintf('Loading data from %-40s (%4d points) ...\n', dirI, size(fileData1.paramSet, 1));
    
end

end
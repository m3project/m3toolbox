% This function returns a list of directories inside dir that is filtered
% using include and exclude keywords
%
function list = getDirList(dir, include, exclude)

if nargin < 2
    include = {};
end

if nargin < 3
    exclude = {};
end

dirs = ls(dir);

dirs = dirs(3:end, :); % ls returns . and .. as the first two entries

n = size(dirs, 1); % number of sub-directories

if n==0
    
    list = {};
    
    return;
    
end

m = 1;

for i=1:n
    
    dirI = strtrim(dirs(i, :));
    
    fullpath = fullfile(dir, dirI);
    
    if ~exist(fullpath, 'dir')
        
        % ignore files
        
        continue;
        
    end
    
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
    
    list{m, :} = dirI;
    
    m = m + 1;

end
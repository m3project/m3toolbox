% This function returns a list of directories in `parent` that have the
% prefix `prefix`
function subdirs = ls2(parent, prefix)

    dirs = dir(parent);
    
    n = size(dirs, 1);
    
    k = 1;
    
    subdirs = {};
    
    for i=1:n
        
        d = dirs(i);
        
        if ~d.isdir || ~ismember(1, strfind(d.name, prefix))
            
            continue; % ignore
            
        end
        
        subdirs{k} = fullfile(parent, d.name);
        
        k = k+1;
        
    end

end
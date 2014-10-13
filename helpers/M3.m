% Returns root path of the M3 toolbox
%
% Ghaith Tarawneh - 29/05/2014
%
function path = M3()

path = mfilename('fullpath');

[path, name] = fileparts(path); % get parent of this script

path = fileparts(path); % go up one dir

% some sanity checks

if ~strcmp(name, 'M3')
    
    error('sanity check: script name not returned correctly');
    
end

end
% Returns root path of the M3 toolbox
%
% Ghaith Tarawneh - 29/05/2014
%
function path = getM3Path()

fullpath = mfilename('fullpath');

[path, name, ~] = fileparts(fullpath);

% some sanity checks

if ~strcmp(name, 'getM3Path')
    
    error('sanity check: script name not returned correctly');
    
end

end
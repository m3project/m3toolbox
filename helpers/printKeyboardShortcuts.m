function printKeyboardShortcuts(shortcuts)

if nargin < 1
    
    shortcuts = {
        'Space',            'Start bug motion', ...
        'End or Escape',    'exit stimulus', ...
        'n',                'Switch to negative disparity'
        };

end

n = length(shortcuts);

fstr = '%-20s \t %-50s\n';

fprintf('\n');

fprintf(fstr, 'Key', 'Function');

fprintf(fstr, '---', '--------');

for i=1:2:n
    
    fprintf(fstr, shortcuts{i}, shortcuts{i+1});
    
end

fprintf('\n');

end
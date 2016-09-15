% returns information about computer hardware
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 29/05/2014
%
function hardwareInfo = getHardwareInfo()

    if isunix
        
        hardwareInfo = struct();
        
    else
        
        computer = getWMIC('wmic computersystem list full');

        cpu = getWMIC('wmic cpu list full');

        screens = getScreens();

        product = getWMIC('wmic csproduct list full');

        [~, gpu] = system('wmic path Win32_VideoController get');

        gpu = strtrim(gpu);

        getConstParams = getConstants();

        hardwareInfo = packWorkspace();
        
    end
    
end

function screens = getScreens()

s = Screen('Screens');

for i=1:length(s)
    
    screens{i} = Screen('Resolution', s(i));
    
    screens{i}.id = s(i);
    
end

end

function result = getWMIC(cmd)

[~, info] = system(cmd);

nl = char([13 10]);

info = strtrim(info);

list = regexp(info, nl, 'split');

result = parse(list);

end

function struct1 = parse(list)

n = size(list, 2);

struct1 = struct;

for i=1:n
    
    entry = list{i};
    
    fields = regexp(entry, '=', 'split');
    
    if ~isempty(fields{2})
    
        struct1.(fields{1}) = fields{2};
    
    end
    
end

end
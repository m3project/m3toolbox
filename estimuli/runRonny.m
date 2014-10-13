function runRonny(funcs)

rootExptsPath = 'V:\readlab\Ronny\runRonny Experiments';

clc; 

a = input('Backup the toolbox source code (type NO to skip, press Enter to proceed)? ', 's');

if isequal(lower(a), 'no')
    
    warning('skipped backup ...');
    
else
    
    dStr = lower(datestr(now,'yyyy-mm-dd-HHMM.SS'));
    
    exptPath = fullfile(rootExptsPath, dStr);
    
    mkdir(exptPath);
    
    backupToolbox(exptPath);
    
    hardwareInfo = getHardwareInfo;
    
    hardwareInfoFile = fullfile(exptPath, 'hardware_info.mat');
    
    save(hardwareInfoFile, 'hardwareInfo');
    
end

if nargin < 1

    funcs = {@runDiscLoom, @runGratingwithMenu, @runTargetwithMenuAnaglyph, @runSwirlAnaglyph, @runDotsAnaglyph_ephys};

end

closeWindow();

while 1
    
    for i=1:length(funcs)
        
        clc
        
        exitCode = funcs{i}();
        
        closeWindow();
        
        if exitCode == 0
                   
            return;
            
        end
        
        pause(0.2);
        
    end
    
end

end
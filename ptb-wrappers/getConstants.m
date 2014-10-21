function consts = getConstants()

consts.SCREEN_ID   = 2;        % screen identifier (PTB setting)
consts.STEREO_MODE = 0;        % when set, stereo mode is enabled
consts.CRT_GAMMA   = 1.3476;   % gamma level of CRT
consts.MEAN_LUM    = 0.5;      % mean luminance of screen
consts.SILENT_PTB  = 1;        % when set, limits PTB msgs to critical errors
consts.NO_TESTS    = 0;        % when set, configure PTB to not perform startup tests
consts.scrScaling = 1/40;      % screen resolution scaling factor (cm/px)

% The code snippet below will lookup the appropriate SCREEN_ID per PC

screenIDs = {{'READLAB14', 1}, {'VIVEKPC', 2'}, {'SLYTHERIN', 0}, {'IONHWB62', 0}, {'READLAB21', 2}, {'READLAB16', 1}, {'READLAB22', 2}};

pc = getenv('computername');

for i=1:length(screenIDs)
    
    tuple = screenIDs{i};
    
    if strcmp(tuple{1}, pc)
        
        consts.SCREEN_ID = tuple{2};
        
        break;
        
    end
    
end

end
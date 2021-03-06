function consts = getConstants()

consts.SCREEN_ID   = 1;        % screen identifier (PTB setting)
consts.STEREO_MODE = 0;        % when set, stereo mode is enabled
consts.CRT_GAMMA   = 1.3476;   % gamma level of CRT
consts.MEAN_LUM    = 0.5;      % mean luminance of screen
consts.SILENT_PTB  = 1;        % when set, limits PTB msgs to critical errors
consts.NO_TESTS    = 0;        % when set, configure PTB to not perform startup tests
consts.scrScaling = 1/40;      % screen resolution scaling factor (cm/px)

% The code snippet below will lookup the appropriate SCREEN_ID per PC

screenIDs = {{'READLAB12', 0},{'READLAB14', 2}, {'VIVEKPC', 2'}, ...
    {'SLYTHERIN', 0}, {'IONHWB62', 2}, {'READLAB21', 0}, ...
    {'READLAB16', 2}, {'READLAB22', 2}, {'ION80', 0}, ...
    {'READLAB13', 1}, {'READLAB17', 1}, {'READLAB1', 2}, ...
    {'READLAB5', 2}, {'READLAB18', 2}, {'EEE16-055', 2}};

pc = getenv('computername');

for i=1:length(screenIDs)
    
    tuple = screenIDs{i};
    
    if strcmp(tuple{1}, pc)
        
        consts.SCREEN_ID = tuple{2};
        
        break;
        
    end
    
end

% check if SCREEN_ID maps to an existing screen

% if not then set it to the secondary display

ids = Screen('Screens');

if ~ismember(consts.SCREEN_ID, ids)
    
    consts.SCREEN_ID = max(ids);
    
end

end
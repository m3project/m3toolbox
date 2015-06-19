function [dump] = runGratingWarped(expt)
%% initialization

KbName('UnifyKeyNames'); 

%% rendering stimulus

% parameters:

spatialFreq     = 0.1;     % in cycles per deg
temporalFreq    = 0.2;       % in cycles per second
dir             = 1;       % direction
enaAbort        = 1;        % 1 to enable user to abort by pressing Escape
timeLimit       = 0;        % stimulus duration (seconds), 0 to disable
contrast        = 1;        % [0, 1]
Gamma           = [];       % must be overloaded by unpackStruct

screenReso = 40; % px/cm

viewD = 7;

if nargin>0
    
    unpackStruct(expt);         % load overridden parameter values
    
end

% create window

Gamma = 1.1;

if isempty(Gamma)

    createWindow();
    
else
    
    createWindow(Gamma);
    
end

window = getWindow();

[W, H] = getResolution();

% end of parameters

px = -W/2:W/2;

deg = px2deg(px, screenReso, viewD);

% creating workspace dump

dump = packWorkspace();

startTime = GetSecs();

while 1
    
    t = GetSecs() - startTime; 
    
    phase = -dir * t * 360 * temporalFreq;
    
    y = sin(2*pi*deg*spatialFreq + phase);

    y = 128 + y * contrast * 128;
    
    id = Screen('MakeTexture', window, y);
    
    Screen('DrawTexture', window, id, [], [1 1 W H]);
    
    Screen('close', id);
    
    Screen(window, 'Flip');
    
    [~, ~, keyCode ] = KbCheck;
    
    if enaAbort && keyCode(KbName('Escape'))
        
        break;
        
    end
    
    if timeLimit>0 && t>timeLimit
        
        break;
        
    end    
    
end
end
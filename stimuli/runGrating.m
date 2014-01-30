function [dump] = runGrating(expt)
%% initialization

KbName('UnifyKeyNames'); 

createWindow();

window = getWindow();

[W, H] = getResolution();

%% rendering stimulus

% parameters:

gratingType     = 1;        % 0 for sin, 1 for square
spatialFreq     = 0.0025;     % in cycles per pixel
temporalFreq    = 0.25;       % in cycles per second
dir             = -1;       % direction
enaAbort        = 1;        % 1 to enable user to abort by pressing Escape
timeLimit       = 0;        % stimulus duration (seconds), 0 to disable
contrast        = 1;        % [0, 1]

if nargin>0
    unpackStruct(expt);         % load overridden parameter values
end

% end of parameters

if gratingType == 0
    [gratingid, ~] = CreateProceduralSineGrating(window, W, H, [0.5 0.5 0.5 0], [], 0.5); % [, radius=inf][, contrastPreMultiplicator=1])
else
    [gratingid, ~] = CreateProceduralSquareGrating(window, W, H, [0.5 0.5 0.5 0], [], 0.5); % [, radius=inf][, contrastPreMultiplicator=1])
end

Angle = 0;

% creating workspace dump

dump = packWorkspace();

startTime = GetSecs();

while 1
    
    t = GetSecs() - startTime; 

    phase = -dir * t * 360 * temporalFreq;
    
    Screen('DrawTexture', window, gratingid, [], [], Angle, [], [], [], [], [], [phase, spatialFreq, contrast, 0]);
    
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
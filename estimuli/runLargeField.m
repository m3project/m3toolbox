function exitCode = runLargeField(expt)
%% Initialization

KbName('UnifyKeyNames');

Gamma = 2.127; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[sW, sH] = getResolution();

%% parameters

bugColor = 0;

radius = 30; % dot radius (px)

disp_max = 6; % maximum disparity (px)

n = 2e3; % number of dots

dynamic = 1; % 1 or 0 to enable/disable dynamic background

frequency = 2; % disparity oscillation frequency (Hz)

%% loading overrides

if nargin>0
    
    unpackStruct(expt);
    
end

%% print keyboard shortcuts

shortcuts = {
    'f',                        'Bring disparity plane to front', ... 
    'b',                        'Bring disparity plane to back', ... 
    'o',                        'Set disparity plane to oscillate', ... 
    'Escape or End',            'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% functions

disp_static_front = @(t) disp_max;

disp_static_back = @(t) -disp_max;

disp_oscillation = @(t) disp_max * sin(2*pi*frequency*t);

%% rendering loop

disp = disp_static_front;

startTime = GetSecs();

i = 1;

while (1)
    
    t = GetSecs() - startTime;
    
    if dynamic || i == 1
    
    dotX = rand(n, 1) * sW;
    
    dotY = rand(n, 1) * sH;
    
    end
    
    dotPos = [dotX+disp(t)./2 dotY];
    
    dotRect = [dotPos dotPos+radius];
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('FillOval', window, bugColor, dotRect');
    
    dotPos = [dotX-disp(t)./2 dotY];
    
    dotRect = [dotPos dotPos+radius];
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('FillOval', window, bugColor, dotRect');
    
    Screen('Flip', window);
    
    %% processing keyboard shortcuts
    
     [~, ~, keycode] = KbCheck;
    
    if keycode(KbName('b'))
        
        disp = disp_static_back;
        
    end
    
    if keycode(KbName('f'))
        
        disp = disp_static_front;
        
    end
    
    if keycode(KbName('o'))
        
        disp = disp_oscillation;
        
    end
    
    if keycode(KbName('Escape'))
        
        exitCode = 0;
        
        break;
        
    end
    
    if keycode(KbName('END'))
        
        exitCode = 1;
        
        break;
        
    end
    
    i = i + 1;
    
end

% closeWindow();

end
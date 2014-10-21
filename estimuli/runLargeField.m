function exitCode = runLargeField(logEvent, keyPress)

if nargin<1
    
    logEvent = @(str) str; % dummy function
    
end

if nargin<2
    
    keyPress = @(keyCode) 1; % dummy function
    
end

logEvent('runLargeField');

%% Initialization

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

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

dynamic = 0; % 1 or 0 to enable/disable dynamic background

frequency = 2; % disparity oscillation frequency (Hz)

%% print keyboard shortcuts

shortcuts = {
    'p',                        'Set disparity to positive', ... 
    'n',                        'Set disparity to negative', ... 
    '0',                        'Set disparity to zero', ...     
    'o',                        'Set disparity to oscillate', ...
    'Escape or End',            'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% functions

disp_pos = @(t) disp_max;

disp_neg = @(t) -disp_max;

disp_zero = @(t) 0;

disp_oscillation = @(t) disp_max * sin(2*pi*frequency*t);

%% rendering loop

disp = disp_pos;

startTime = GetSecs();

i = 1;

oldKeyIsDown = 1;

while (1)
    
    t = GetSecs() - startTime;
    
    if dynamic || i == 1
        
        dotX = rand(n, 1) * sW;
        
        dotY = rand(n, 1) * sH;
        
    end
    
    dotPos = [dotX-disp(t)./2 dotY];
    
    dotRect = [dotPos dotPos+radius];
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('FillOval', window, bugColor, dotRect');
    
    dotPos = [dotX+disp(t)./2 dotY];
    
    dotRect = [dotPos dotPos+radius];
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('FillOval', window, bugColor, dotRect');
    
    Screen('Flip', window);
    
    %% processing keyboard shortcuts
    
    [keyIsDown, ~, keycode] = KbCheck;
    
    if keyIsDown && ~oldKeyIsDown
        
        keyPress(keyCode);
        
        if keycode(KbName('n'))
            
            disp = disp_neg;
            
            logEvent('set disparity to negative');
            
        end
        
        if keycode(KbName('p'))
            
            disp = disp_pos;
            
            logEvent('set disparity to positive');
            
        end
        
        if keycode(KbName('o'))
            
            disp = disp_oscillation;
            
            logEvent('set disparity to oscillate');
            
        end
        
        if keycode('0')
            
            disp = disp_zero;
            
            logEvent('set disparity to 0');
            
        end
        
        if keycode(KbName('Escape'))
            
            exitCode = 0;
            
            break;
            
        end
        
        if keycode(KbName('END'))
            
            exitCode = 1;
            
            break;
            
        end
        
    end
    
    oldKeyIsDown = keyIsDown;
    
    i = i + 1;
    
end

closeWindow();

end
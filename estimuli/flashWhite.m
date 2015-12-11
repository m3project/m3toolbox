function exitCode = flashWhite(varargin)
%% Initialization

KbName('UnifyKeyNames');

closeWindow(); 

Gamma = 2.188; % for DELL U2413

createWindow(Gamma);

%% parameters

tOn = 2;

tOff = 2;

%% functions

T = tOn + tOff;

%% rendering loop:

flashEna = 1;

window = getWindow();

startTime = GetSecs();

while 1
    
    tnow = GetSecs();
    
    t = tnow - startTime;
    
    if t>T
        
        startTime = tnow;        
        
    end
    
    flash = t<tOn;
    
    Screen(window, 'FillRect', [1 1 1] * flash * 255 * flashEna, []);

    Screen('Flip', window);    
    
    [~, ~, keyCode] = KbCheck;
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode
        
        return
        
    end
    
    if keyCode(KbName('Space'))
        
        flashEna = 1 - flashEna;
        
        pause(0.2);
        
    end
    
end

closeWindow();

end

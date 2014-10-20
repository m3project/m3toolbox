function exitCode = flashWhite()
%% Initialization

KbName('UnifyKeyNames');

closeWindow(); 

Gamma = 2.188; % for DELL U2413

createWindow(Gamma);

%% parameters

tOn = 0.25;

tOff = 1;

%% functions

T = tOn + tOff;

%% rendering loop:

flashEna = 0;

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
    
    if keyCode(KbName('Escape'))
        
        exitCode = 0;
        
        break;
        
    end
    
    if keyCode(KbName('Space'))
        
        flashEna = 1 - flashEna;
        
        pause(0.2);
        
    end
    
    if keyCode(KbName('END'))
        
        exitCode = 1;
        
        break;
        
    end
   
end

closeWindow();

end

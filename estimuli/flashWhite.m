function exitCode = flashWhite(varargin)
%% Initialization

KbName('UnifyKeyNames');

closeWindow(); 

Gamma = 2.188; % for DELL U2413

createWindow(Gamma);

sobj = initSerial();

ss = @(str) sendSerial(sobj, str);

%% parameters

tOn = 2;

tOff = 2;

%% functions

T = tOn + tOff;

%% rendering loop:

flashEna = 1;

window = getWindow();

startTime = GetSecs();

conds = {'off', 'on'};

prevFlash = 0;

oldKeyIsDown = 0;

while 1
    
    tnow = GetSecs();
    
    t = tnow - startTime;
    
    if t>T
        
        startTime = tnow;        
        
    end
    
    flash = t<tOn;
    
    Screen(window, 'FillRect', [1 1 1] * flash * 255 * flashEna, []);
    
    Screen('Flip', window);
    
    currFlash = flash * flashEna;
    
    if currFlash ~= prevFlash
        
        ss(conds{currFlash+1});
    
    end
        
    prevFlash = currFlash;   
    
    [keyIsDown, ~, keyCode] = KbCheck;
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode
        
        return
        
    end
    
    if keyCode(KbName('Space')) && ~oldKeyIsDown
        
        flashEna = 1 - flashEna;
        
    end
    
    oldKeyIsDown = keyIsDown;
    
end

end

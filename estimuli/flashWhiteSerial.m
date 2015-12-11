function exitCode = flashWhiteSerial(varargin)
%% Initialization

sobj = initSerial();

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

% startTime = GetSecs();

oldFlash = 0;

flash = 0;

while 1
    
%     tnow = GetSecs();
%     
%     t = tnow - startTime;
%     
%     if t>T
%         
%         startTime = tnow;        
%         
%     end
    
%     flash = t<tOn;

pause(0.25);

flash = 1 - flash;
    
    if flash ~= oldFlash
        
        sendSerial(sobj, sprintf('Switched lum to %d', flash));
        
        oldFlash = flash;
        
    end
    
    Screen(window, 'FillRect', [1 1 1] * flash * 255, []);

    Screen('Flip', window);    
    
    [~, ~, keyCode] = KbCheck;
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode
        
        sca
        return
        
    end
    
%     if keyCode(KbName('Space'))
%         
%         flashEna = 1 - flashEna;
%         
%         pause(0.2);
%         
%     end
    
end

closeWindow();

end

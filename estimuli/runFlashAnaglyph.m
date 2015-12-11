function exitCode = runFlashAnaglyph(varargin)

KbName('UnifyKeyNames');

closeWindow();

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

sequence = [
    1 1 % bright both
    0 0 % dark both
    1 0.5 % bright green
    0.5 1 % bright blue
    0 0.5 % dark green
    0.5 0 % dark blue
    ];

tswitch = 2; % seconds

%% body

n = size(sequence, 1);

fbox = createFlickerBox(150, 55);

while 1
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen(window, 'FillRect', [1 1 1] * 0.5, []);
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen(window, 'FillRect', [1 1 1] * 0.5, []);
    
    Screen(window, 'Flip');
 
    while 1
    
    [~, ~, keyCode] = KbCheck;
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode
        
        return
        
    end
    
    if keyCode(KbName('Space'))
        
        break;
        
    end
    
    end    
    
    for i=1:n
        
        fbox.pattern = 1 * i/n;
        
        s = sequence(i, :);
        
        Screen('SelectStereoDrawBuffer', window, 0);
        
        Screen(window, 'FillRect', [1 1 1] * s(1), []);
        
        drawFlickerBox(window, fbox);
        
        Screen('SelectStereoDrawBuffer', window, 1);
        
        Screen(window, 'FillRect', [1 1 1] * s(2), []);
        
        fbox = drawFlickerBox(window, fbox);
        
        Screen(window, 'Flip');
        
        t0 = GetSecs();
        
        while GetSecs - t0 < tswitch
            
            [~, ~, keyCode] = KbCheck;
            
            exitCode = checkEscapeKeys(keyCode);
            
            if exitCode
                
                return
                
            end
            
        end
        
    end

    
end


end
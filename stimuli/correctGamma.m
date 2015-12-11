function correctGamma()

KbName('UnifyKeyNames');

createWindow(1.001);

w = getWindow();

Screen(w, 'TextFont', 'Arial');

Screen(w, 'TextSize', 120);

[sW, sH] = getResolution();

b = 0.5;

oldKeyIsDown = 1;

while 1
    
    [keyIsDown, ~, keycode] = KbCheck;
    
    if keyIsDown && ~oldKeyIsDown
        
        if keycode(KbName('UpArrow')) || keycode(KbName('RightArrow'))
            
            b = min(b + 0.1, 1);
            
        end
        
        if keycode(KbName('DownArrow')) || keycode(KbName('LeftArrow'))
            
            b = max(b - 0.1, 0);
            
        end
        
        if keycode(KbName('Home'))
            
            b = 0;
            
        end
        
        if keycode(KbName('End'))
            
            b = 1;
            
        end
        
        if keycode(KbName('Escape'))
            
            break;
            
        end
        
    end
    
    oldKeyIsDown = keyIsDown;
    
    Screen(w, 'FillRect' , [1 1 1] * 1 * b , [] );
    
    str = sprintf('%1.1f', b);
    
    Screen(w, 'DrawText', str, sW * 0.75, sH * 0.75, (1 - b>0.5) * [1 1 1] * 1);
    
    Screen(w, 'Flip');
    
end

closeWindow();

end
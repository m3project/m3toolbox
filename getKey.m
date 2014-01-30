function key = getKey()

% checking for key presses

disp('Press (Left, Right, Otherwise) to indicate mantid viewing direction');

pause(0.1);

while (1)
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('LeftArrow')))
        
        key = 0; break;
        
    end
    
    if (keyCode(KbName('RightArrow')))
        
        key = 1; break;
        
    end
    
    if (keyCode(KbName('UpArrow')))
        
        key = 2; break;
        
    end
    
    if (keyCode(KbName('Return')))
        
        key = 3; break;
        
    end
    
    if (keyCode(KbName('Space')))
        
        key = 4; break;
        
    end
    
    
end

end
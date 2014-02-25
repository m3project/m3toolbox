function key = getDirectionJudgement()

% checking for key presses

disp('Press (Left, Right, Otherwise) to indicate mantid viewing direction');

pause(0.1);

while (1)
    
    drawnow
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('LeftArrow')))
        
        key = -1; break;
        
    end
    
    if (keyCode(KbName('RightArrow')))
        
        key = 1; break;
        
    end
    
    if (keyCode(KbName('UpArrow')))
        
        key = 0; break;
        
    end
    
    if (keyCode(KbName('Return')))
        
        key = 0; break;
        
    end
    
    if (keyCode(KbName('Space')))
        
        key = 0; break;
        
    end
    
    
end

end
function key = getTrackingJudgement()

% checking for key presses

disp('Press Right to indicate tracking or Left to indicare no response');

pause(0.1);

while (1)
    
    drawnow
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('LeftArrow')))
        
        key = 0; break;
        
    end
    
    if (keyCode(KbName('RightArrow')))
        
        key = 1; break;
        
    end   
    
end

end
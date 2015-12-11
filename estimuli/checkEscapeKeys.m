% this function is used by many ephys stimuli, it checks whether any escape
% shortcuts have been pressed and returns the approporiate exitCode

function exitCode = checkEscapeKeys(keyCode)

exitCode = 0;

if nargin < 1

    [~, ~, keyCode] = KbCheck;
    
end

if keyCode(KbName('Escape'))
    
    exitCode = 1;
    
elseif keyCode(KbName('END'))
    
    exitCode = 2;
    
elseif keyCode(KbName('Alt'))
    
    numsPressed = intersect(find(keyCode), ('1':'9') + 0);
    
    if ~isempty(numsPressed)
        
        exitCode = 100 + min(numsPressed) - '0'; % special exit code to switch stimuli
        
        return
        
    end
    
    chars = 'qwertyuiop';
    
    for i=1:length(chars)
        
        if keyCode(KbName(chars(i)))
            
            exitCode = 110 + i - 1;
            
            return;
            
        end
        
    end
    
end

end
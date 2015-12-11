function testGamma()

KbName('UnifyKeyNames');

[sW, sH] = getResolution();

%% parameters

blockSize = 1;

H = sH; % height of stripes

%% body

window = getWindow();

hMargin = (sH - H)/2;

pattern = genChequer(struct('W', sW, 'H', 1, 'blockSize', blockSize, 'random', 0));

while 1
    
    Screen(window, 'FillRect', [1 1 1] * 0.5);
    
    pattern = 1 - pattern;
    
    patTex = Screen('MakeTexture', window, pattern * 255);
    
    Screen(window, 'DrawTexture', patTex, [], [0 hMargin sW sH-hMargin]);
    
    Screen(window, 'Flip');
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('Escape')))        
        
        return
        
    end
    
end

end
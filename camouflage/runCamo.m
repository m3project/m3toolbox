function runCamo(s, expt)

if isempty(s)
    
    return
    
end

contrast = 1;

duration = inf;

bugTexture = 1 * (rand(100, 20) > 0.15);

bugSpeed = 500;

bugJitter = 0;

bugDirection = 1;

if nargin>1
    
    unpackStruct(expt);
    
end

bugSize = size(bugTexture);

S = 1; % scaling factor

KbName('UnifyKeyNames');

[H, W, ~] = size(s);

W = W * S;

H = H * S;

disp('rendering ...')

createWindow(1); window = getWindow();

[sW, sH] = getResolution();

blocksX = ceil(sW / W);

blocksY = ceil(sH / H);
    
mx = mean(abs(s(:))) * 4;

frames = size(s, 3);

exitCode = 0;

startTime = GetSecs();

bugTex = Screen('MakeTexture', window, bugTexture' * 255);

while exitCode == 0
    
    for i=1:frames
        
        t = GetSecs() - startTime;
        
        k = abs(s(:, :, i));
        
        k2 = (0.5 + (k / mx - 0.5) * contrast) * 255;
        
        tex = Screen('MakeTexture', window, k2);
        
        for x=0:blocksX
            
            for y=0:blocksY
                
                rect = [1 1 W+1 H+1] + [x y x y] .* [W H W H];
                
%                 rect = [1 1 W H];
                
                Screen('DrawTexture', window, tex, [], rect);
                
            end
            
        end
        
        bugY = sH / 2 - bugSize(2)/2;
        
        bugX = sW / 2 - bugSize(1)/2 + t * bugSpeed * bugDirection;
        
        bugX = mod(t * bugSpeed * bugDirection, sW);
        
        jitXY = (rand(1, 2)-0.5) * bugJitter;
        
        bugY = round(bugY);
        
        bugX = round(bugX);
        
        bugRect = [1 0 1 0] * bugX + [0 1 0 1] * bugY ...
            + [0 0 bugSize] + [jitXY jitXY];
        
        Screen('DrawTexture', window, bugTex, [], bugRect);
        
        %Screen(window, 'FillRect', [1 1 1]*0, bugRect);
        
        Screen(window, 'Flip');
        
        Screen('Close', tex);
        
        % checking for key presses
        
        [~, ~, keyCode ] = KbCheck;
        
        if (keyCode(KbName('Escape')))
            
            exitCode = 1;
            
            break;
                
        end
        
        if GetSecs() - startTime > duration
            
            exitCode = 1;
            
            break;
            
        end
        
    end
    
end

end
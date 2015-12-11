function runTextureAnimation(args)

KbName('UnifyKeyNames');

% parameters

duration = 5;

escapeEnabled = 1;

motionFunctions{1} = @(t) exampleMotionFunction(t, 400, 400, 0);
motionFunctions{2} = @(t) exampleMotionFunction(t, 400, 600, pi/3);

textures{1} = ones(50, 50);
textures{2} = ones(50, 50);

%% load overrides

if nargin>0
    
    unpackStruct(args);
    
end

%% body

createWindow();

window = getWindow();

fps = Screen(window, 'FrameRate');

frames = duration * fps;

n = length(textures);

makeTextureFun = @(txt) Screen('MakeTexture', window, txt * 255);

txtIDs = cellfun(makeTextureFun, textures);

obj1 = onCleanup(@() Screen('close', txtIDs));

for i=1:frames
    
    t = i/fps;
    
    for j=1:n
        
        [tH, tW] = size(textures{j});
        
        fun1 = motionFunctions{j};
        
        [tx, ty] = fun1(t);
        
        dest = [0 0 tW tH] + [1 0 1 0] * tx + [0 1 0 1] * ty;
        
        Screen('DrawTexture', window, txtIDs(j), [], dest);        
        
    end
    
    Screen('Flip', window);    
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('Escape')) && escapeEnabled)
        
        break;
        
    end    
    
end


end

function [x, y] = exampleMotionFunction(t, cx, cy, phase)

r = 200;

x = cx + sin(2*pi*t + phase) * r;

y = cy + cos(2*pi*t + phase) * r;

end
function runCamoPattern(args)

% parameters

duration = inf;

backPattern = 0.5 * ones(500, 500);

bugPattern = 0.5;

getBugPosition = @(t) getBugPosition_internal(t);

escapeEnabled = 1;

tileMode = 1; % 0 = stretch, 1 = tile

videoFile = '';

%% load overides

if nargin>0
    
    unpackStruct(args);
    
end

%% body

S = 1; % scaling factor

KbName('UnifyKeyNames');

[H, W, ~] = size(backPattern);

W = W * S;

H = H * S;

disp('rendering ...')

createWindow(); window = getWindow();

[sW, sH] = getResolution();

blocksX = ceil(sW / W);

blocksY = ceil(sH / H);

frames = size(backPattern, 3);

exitCode = 0;

startTime = GetSecs();

bugPattern = bugPattern';

bugTex = Screen('MakeTexture', window, bugPattern' * 255);

bugSize = size(bugPattern(:, :, 1));

% prepare background textures

texIDs = nan(frames, 1);

for i=1:frames
    
    k = backPattern(:, :, i);
    
    texIDs(i) = Screen('MakeTexture', window, k, [], [], 2);
    
end

cleanFunc1 = @() Screen('Close', texIDs);

obj1 = onCleanup(cleanFunc1);

recording = recordStimulus(videoFile);

j = 0;

fps = 60; % for recording

% render loop

while exitCode == 0
    
    for i=1:frames
        
        if isempty(recording)
            
            t = GetSecs() - startTime;            
            
        else
        
            t = j/fps;
            
            j = j + 1;            
            
        end            
        
        Screen(window, 'FillRect', [1 1 1] * 255/2);
        
        if tileMode
            
            % tile
            
            for x=0:blocksX
                
                for y=0:blocksY
                    
                    rect = [0 0 W H] + [x y x y] .* [W H W H];
                    
                    Screen('DrawTexture', window, texIDs(i), [], rect);
                    
                end
                
            end
            
        else
            
            % stretch
            
            rect = [0 0 sW sH]; %#ok
            
            Screen('DrawTexture', window, texIDs(i), [], rect);
            
        end
        
        bugPos = getBugPosition(t);
        
        bugY = round(bugPos(2) - bugSize(2)/2);
        
        bugX = round(bugPos(1) - bugSize(1)/2);
        
        bugRect = [1 0 1 0] * bugX + [0 1 0 1] * bugY + [0 0 bugSize];
        
        if numel(bugPattern)>1
        
            Screen('DrawTexture', window, bugTex, [], bugRect);
        
        end
        
        Screen(window, 'Flip');
        
        recording = recordStimulus(recording);
        
        % checking for key presses
        
        [~, ~, keyCode ] = KbCheck;
        
        if (keyCode(KbName('Escape'))) && escapeEnabled
            
            exitCode = 1;
            
            break;
                
        end
        
        if t > duration
            
            exitCode = 1;
            
            break;
            
        end
        
    end
    
end

recordStimulus(recording);

end

function pos = getBugPosition_internal(t)

bugSpeed = 500;

sW = 1920;

sH = 1200;

bugDirection = 1;

t = max(0, t-2);

pos(1) = mod(sW / 2 + t * bugSpeed * bugDirection, sW);

pos(2) = sH * 0.5;

end
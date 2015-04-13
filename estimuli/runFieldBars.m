function runFieldBars

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

frameRate = Screen(window, 'FrameRate');

[sW, sH] = getResolution();

%% parameters

aperture = [0 0 sW sH]; % x1, y1, x2, y2

%aperture = [200 200 sW-200 sH-200]; % use this for testing

nbars = 25; % number of bars

barCols = [0 1]; % bar colors (0 is black, 0.5 is gray [background] and 1 is white)

tOn = 0.1; % seconds

tOff = 1; % seconds

drawGrid = 0; % set to 1 to render the bar grid instead of the pattern

%% rendering

barW = ceil((aperture(3) - aperture(1)) / nbars);

getBar = @(i) [aperture(1)+(i-1)*barW aperture(2) aperture(1)+i*barW aperture(4)];

if drawGrid
    
    clearWindow([0 0 0], 1);
    
    Screen(window, 'FrameRect', [1 0 0] * 255, aperture);
    
    for i=1:nbars
        
        Screen(window, 'FrameRect', [0.5 1 0] * 1, getBar(i));
        
    end
    
    Screen(window, 'flip');
    
    return
    
end

fbox = createFlickerBox(150, 150);

while 1
    
    clearWindow([1 1 1]*0.5, 1);
    
    % wait for number press or Escape
    
    disp('Press (1-9) to select presentation pattern or Escape to abort');
    
    escapePressed = 0;
    
    numPressed = 0;
    
    while 1
        
        [~, ~, keyCode ] = KbCheck;
        
        if keyCode(KbName('Escape'))
            
            escapePressed = 1;
            
            break;
            
        end
        
        numsPressed = intersect(find(keyCode), ('1':'9') + 0);
        
        if ~isempty(numsPressed)
            
            numPressed = min(numsPressed) - '0';
            
            break;
            
        end
        
    end
    
    if escapePressed
        
        disp('aborted');
        
        break;
        
    end
    
    fprintf('Selected pattern %i ...\n', numPressed);
    
    paramSet = genParamSet(nbars, barCols, numPressed);
    
    totalTime = size(paramSet, 1) * (tOn + tOff);

    fprintf('estimated total time = %g seconds\n', totalTime);
    
    % start presenting
    
    for i=1:size(paramSet, 1)
        
        p = paramSet(i, :);
        
        fprintf('%g, ', p);
        
        fprintf('\n');
        
        Screen('SelectStereoDrawBuffer', window, 0);
        
        Screen(window, 'FillRect', [1 1 1] * p(3), getBar(p(1)));
        
        drawFlickerBox(window, fbox);
        
        Screen('SelectStereoDrawBuffer', window, 1);
        
        Screen(window, 'FillRect', [1 1 1] * p(4), getBar(p(2)));
        
        fbox = drawFlickerBox(window, fbox);
        
        Screen(window, 'Flip');
        
        if pause2(tOn - 1/frameRate, @checkEscape)
            
            return;
            
        end
        
        Screen('SelectStereoDrawBuffer', window, 0);
        
        drawFlickerBox(window, fbox);
        
        Screen('SelectStereoDrawBuffer', window, 1);
        
        fbox = drawFlickerBox(window, fbox);        
        
        Screen(window, 'Flip');
        
        if pause2(tOff - 1/frameRate, @checkEscape)
            
            return;
            
        end
        
    end
    
end

end

function result = checkEscape()

[~, ~, keyCode ] = KbCheck;

result = keyCode(KbName('Escape'));

end

function paramSet = genParamSet(nbars, barCols, seed)

paramSet1 = createTrial(1:nbars, 1:nbars, barCols, barCols);

paramSet2 = createTrial(1:nbars, 1, barCols, 0.5);

paramSet3 = createTrial(1, 1:nbars, 0.5, barCols);

paramSet = [paramSet1; paramSet2; paramSet3];

rng(seed);

k = randperm(size(paramSet, 1));

paramSet = paramSet(k, :);

end
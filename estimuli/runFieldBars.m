function exitCode = runFieldBars(varargin)

exitCode = 0;

obj1 = onCleanup(@cleanup);

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

% aperture = [200 200 300 400]; % use this for testing

nbars = 12; % number of bars

barCols = [0 1]; % bar colors (0 is black, 0.5 is gray [background] and 1 is white)

tOn = 0.0166; % seconds

tOff = 0.25; % seconds

drawGrid = 0; % set to 1 to render the bar grid instead of the pattern

generateParams = 0; % set to 1 to export bar positions and patterns (to file)

%% estimating rendering time

paramSet = genParamSet(nbars, barCols, 0, 0);

totalTime = size(paramSet, 1) * (tOn + tOff);

fprintf('estimated total time (binocular) = %g minutes\n', totalTime/60);

paramSet = genParamSet(nbars, barCols, 0, 1);

totalTime = size(paramSet, 1) * (tOn + tOff);

fprintf('estimated total time (monocular) = %g minutes\n', totalTime/60);

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

if generateParams
    
    data.barPositions = nan(nbars, 4);
    
    for i=1:nbars
        
        Screen(window, 'FrameRect', [0.5 1 0] * 1, getBar(i));
        
        data.barPositions(i, :) = getBar(i);
        
    end
    
    for j=1:9
       
        data.monocularPattern{j} = genParamSet(nbars, barCols, j, 0);
        data.binocularPattern{j} = genParamSet(nbars, barCols, j, 1);
        
    end
    
    save('d:\runFieldBars_data.mat', 'data');
    
    return
    
end

fbox = createFlickerBox(150, 55);

numPressed = 1;
    
pmode = 1; % presentation mode: 0 = monocular, 1 = binocular

while 1
    
    clearWindow([1 1 1]*0.5, 1);
    
    disp('Press (1-9) to select presentation pattern');
    
    disp('Press (m) for monocular mode or (b) for binocular');
    
    disp('Press Space to start ...');
    
    while 1
        
        [~, ~, keyCode ] = KbCheck;
        
        exitCode = checkEscapeKeys(keyCode);
        
        if exitCode
            
            return
            
        end
        
        if keyCode(KbName('m')) && pmode == 1
            
            pmode = 0;
            
            disp('switched to monocular');
            
        end
        
        if keyCode(KbName('b')) && pmode == 0
            
            pmode = 1;
            
            disp('switched to binocular');
            
        end
        
        numsPressed = intersect(find(keyCode), ('1':'9') + 0);
        
        if ~isempty(numsPressed)
            
            oldNumPressed = numPressed;
            
            numPressed = min(numsPressed) - '0';
            
            if numPressed ~= oldNumPressed
            
                fprintf('selected pattern %d\n', numPressed);
                
            end
            
        end
        
        if (keyCode(KbName('Space')))
            
            break;
            
        end
        
    end
    
    clc
    
    temp_arr = {'monocular', 'binocular'};
    
    fprintf('Selected mode : %s\n\n', temp_arr{pmode+1});    
    
    fprintf('Selected pattern : %i\n\n', numPressed);
    
    paramSet = genParamSet(nbars, barCols, numPressed, pmode);
    
    % start presenting
    
    for i=1:size(paramSet, 1)
        
        p = paramSet(i, :);
        
        fprintf('condition %d of %d: ', i, size(paramSet, 1));
        
        fprintf('%g, ', p);
        
        fprintf('\n');
        
        Screen('SelectStereoDrawBuffer', window, 0);
        
        Screen(window, 'FillRect', [1 1 1] * p(3), getBar(p(1)));
       
        drawFlickerBox(window, fbox);
        
        Screen('SelectStereoDrawBuffer', window, 1);
        
        Screen(window, 'FillRect', [1 1 1] * p(4), getBar(p(2)));
        
        fbox = drawFlickerBox(window, fbox);
        
        Screen(window, 'Flip');
        
        k = pause2(tOn - 1/frameRate, @checkEscapeKeys);
        
        if k
            
            exitCode = k;
            
            return;
            
        end
        
        Screen('SelectStereoDrawBuffer', window, 0);
        
        drawFlickerBox(window, fbox);
        
        Screen('SelectStereoDrawBuffer', window, 1);
        
        fbox = drawFlickerBox(window, fbox);
        
        Screen(window, 'Flip');
        
        k = pause2(tOff - 1/frameRate, @checkEscapeKeys);
        
        if k
            
            exitCode = k;
            
            return;
            
        end
        
    end
    
end

end

function paramSet = genParamSet(nbars, barCols, seed, pmode)

paramSet1 = createTrial(1:nbars, 1:nbars, barCols, barCols);

paramSet2 = createTrial(1:nbars, 1, barCols, 0.5);

paramSet3 = createTrial(1, 1:nbars, 0.5, barCols);

if pmode == 1

    paramSet = [paramSet1; paramSet2; paramSet3];
    
    rng(seed);

    k = randperm(size(paramSet, 1));
    
    paramSet = paramSet(k, :);

else
    
    rng(seed);

    k2 = randperm(size(paramSet2, 1));
    
    k3 = randperm(size(paramSet3, 1));
    
    paramSet2 = paramSet2(k2, :);
    
    paramSet3 = paramSet3(k3, :);
    
    paramSet = [paramSet2; paramSet3];
    
    % final step, re-arrange elements such that rows from paramSet2 and
    % paramSet3 alternate
    
    nconds = size(paramSet, 1);
    
    k = transp(reshape(1:nconds, [nconds/2 2]));
    
    k2 = k(:);
    
    paramSet = paramSet(k2, :);
    
end

end

function cleanup

closeWindow();

end
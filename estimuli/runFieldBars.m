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

m = 200; % horizontal margin - both left and right (px)

screenReso = 37; % px/cm

viewD = 7; % viewing distance (cm)

%aperture = [m 0 sW-m sH]; % x1, y1, x2, y2

% aperture = [200 200 300 400]; % use this for testing

nbars = 10; % number of bars

barCols = [0]; % bar colors (0 is black, 0.5 is gray [background] and 1 is white)

tOn = 10*0.166666666; % seconds

tOff = 0.5; % seconds

drawGrid = 0; % set to 1 to render the bar grid instead of the pattern

generateParams = 0; % set to 1 to export bar positions and patterns (to file)

barFlickerFramePeriod = 1; % how often the bars flicker (in frames) when flickering is enabled

barFlickerEnabled = 0;

if nargin == 1
    
    if ischar(varargin{1})
        
        generateParams = 1;
        
    end
    
end

%% estimating rendering time

paramSet = genParamSet(nbars, barCols, 0, 0);

totalTime = size(paramSet, 1) * (tOn + tOff);

fprintf('estimated total time (monocular) = %g minutes\n', totalTime/60);

paramSet = genParamSet(nbars, barCols, 0, 1);

totalTime = size(paramSet, 1) * (tOn + tOff);

fprintf('estimated total time (binocular) = %g minutes\n', totalTime/60);

%% rendering

barPos = calBarPositions(sW, screenReso, viewD, m, nbars);

% barW = ceil((aperture(3) - aperture(1)) / nbars);

% getBar = @(i) [aperture(1)+(i-1)*barW aperture(2) aperture(1)+i*barW aperture(4)];

getBar = @(i) [barPos(i, 1) 0 barPos(i, 2) sH];

if drawGrid
    
    clearWindow([0 0 0], 1);
    
    Screen(window, 'FrameRect', [1 0 0] * 255, aperture);
    
    for i=1:nbars
        
        Screen(window, 'FrameRect', [0.5 1 0] * 1, getBar(i));
        
    end
    
    Screen(window, 'flip');
    
    pause
    
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
    
    exitCode = data;
    
    %     save('c:\runFieldBars_data.mat', 'data');
    
    return
    
end

fbox = createFlickerBox(150, 55);

numPressed = 1;

pmode = 1; % presentation mode: 0 = monocular, 1 = binocular

while 1
    
    clearWindow([1 1 1]*0.5, 1);
    
    disp('Press (1-9) to select presentation pattern');
    
    disp('Press (m) for monocular mode or (b) for binocular');
    
    disp('Press (f) for flickering bars or (s) for static bars');
    
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
        
        if keyCode(KbName('f')) && barFlickerEnabled == 0
            
            barFlickerEnabled = 1;
            
            disp('switched to flickering bars');
            
        end
        
        if keyCode(KbName('s')) && barFlickerEnabled == 1
            
            barFlickerEnabled = 0;
            
            disp('switched to static bars');
            
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
    
    home
    
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
        
        % draw ON
        
        w = 0;
        
        fbox.pattern = [0 1];
        
        j = 1;
        
        startTime = GetSecs();
        
        while GetSecs - startTime < (tOn - 1/frameRate)
            
            w = mod(w+1, barFlickerFramePeriod);
            
            if w == 0 && barFlickerEnabled
            
                j = 1 - j;
            
            end
            
            c1 = j * p(3) + (1-j) * 0.5;
            c2 = j * p(4) + (1-j) * 0.5;
            
            Screen('SelectStereoDrawBuffer', window, 0);
            
            Screen(window, 'FillRect', [1 1 1] * c1, getBar(p(1)));
            
            drawFlickerBox(window, fbox);
            
            Screen('SelectStereoDrawBuffer', window, 1);
            
            Screen(window, 'FillRect', [1 1 1] * c2, getBar(p(2)));
            
            fbox = drawFlickerBox(window, fbox);
            
            Screen(window, 'Flip');
            
            k = checkEscapeKeys();
            
            if k
                
                exitCode = k;
                
                return
                
            end
            
        end
        
        % end of draw on
        
        % draw off
        
        fbox.pattern = [0 0.25]; 
        
        startTime = GetSecs();
        
        while GetSecs - startTime < (tOff - 1/frameRate)
            
            Screen('SelectStereoDrawBuffer', window, 0);
            
            drawFlickerBox(window, fbox);
            
            Screen('SelectStereoDrawBuffer', window, 1);
            
            fbox = drawFlickerBox(window, fbox);
            
            Screen(window, 'Flip');
            
            k = checkEscapeKeys();
            
            if k
                
                exitCode = k;
                
                return;
                
            end
            
        end
        
        % end of draw off
        
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
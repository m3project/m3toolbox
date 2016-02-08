function exitCode = runFieldBars(varargin)

exitCode = 0;

obj1 = onCleanup(@cleanup);

sobj = initSerial();

ss = @(str) sendSerial(sobj, str);

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[sW, sH] = getResolution();

fps = getFrameRate();

%% parameters

cModeDelay = 4; % number of seconds between patterns

m = 666; % horizontal margin - both left and right (px) (was 200 till 19/08/2015)

vm = [0 0]; % vertical margin - [top bottom] (px)

screenReso = 37; % px/cm

viewD = 10; % viewing distance (cm)

%aperture = [m 0 sW-m sH]; % x1, y1, x2, y2

% aperture = [200 200 300 400]; % use this for testing

nbars = 6; % number of bars

barCols = 0; % bar colors (0 is black, 0.5 is gray [background] and 1 is white)

tOn = 0.5; % seconds (will be rounded to the nearest number of frames)

tOff = 0.5; % seconds (will be rounded to the nearest number of frames)

drawGrid = 0; % set to 1 to render the bar grid instead of the pattern

generateParams = 0; % set to 1 to export bar positions and patterns (to file)

barFlickerFramePeriod = 3; % how often the bars flicker (in frames) when flickering is enabled

barFlickerEnabled = 0; % starting (initial) value of the setting

if nargin == 1
    
    if ischar(varargin{1})
        
        generateParams = 1;
        
    end
    
    if isstruct(varargin{1})
        
        unpackStruct(varargin{1});
        
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

getBar = @(i) [barPos(i, 1) vm(1) barPos(i, 2) sH-vm(2)];

if drawGrid
    
    clearWindow([0 0 0], 1); %#ok
    
%     Screen(window, 'FrameRect', [1 0 0] * 255, aperture);
    
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
    
    save('d:\runFieldBars_data.mat', 'data');
    
    return
    
end

fbox = createFlickerBox(150, 55);

% fbox.simulate = 1;

numPressed = 1;

pmode = 1; % presentation mode: 0 = monocular, 1 = binocular, 2 = two-bar

onFrames = round(tOn * fps);

offFrames = round(tOff * fps);

cMode = 0; % continous presentation mode (0 = off, 1 = on)

while 1
    
    disp('Press (1-9) to select presentation pattern');
    
    disp('Press (m) for monocular, (b) for binocular or (hold t + 1,2,3,4 or 5) for two-bar mode');
    
    disp('Press (f) for flickering bars or (s) for static bars');
    
    disp('Press (d) for dark bars or (l) for light bars');
    
    disp('Press (c) to start continuous presentation');
    
    disp('During continuous mode, press (s) to end presentation');
    
    disp('Press Space or (c) to start ...');
    
    while ~cMode
        
        fbox = drawBlank(window, fbox);
        
        [~, ~, keyCode ] = KbCheck;
        
        exitCode = checkEscapeKeys(keyCode);
        
        if exitCode
            
            return
            
        end
        
        if keyCode(KbName('m')) && pmode ~= 0
            
            pmode = 0;
            
            disp('switched to monocular');
            
            ss('m (monocular)');
            
        end
        
        if keyCode(KbName('b')) && pmode ~= 1
            
            pmode = 1;
            
            disp('switched to binocular');
            
            ss('b (binocular)');
            
        end
        
        if keyCode(KbName('t'))
            
            numsPressed = intersect(find(keyCode), ('1':'5') + 0);
            
            if ~isempty(numsPressed)
                
                num = min(numsPressed) - '0';
                
                new_pmode = -num;
                
                if pmode ~= new_pmode
                    
                    pmode = new_pmode;                    
                    
                    ss(sprintf('t (two-bar, bars: %i, %i)', -pmode, -pmode+1));
                    
                    continue;
                    
                end
                
            end
            
        else
             
            numsPressed = intersect(find(keyCode), ('1':'9') + 0);
            
            if ~isempty(numsPressed)
                
                oldNumPressed = numPressed;
                
                numPressed = min(numsPressed) - '0';
                
                if numPressed ~= oldNumPressed
                    
                    fprintf('selected pattern %d\n', numPressed);
                    
                    str1 = sprintf('%d (pattern %d)', numPressed, numPressed);
                    
                    ss(str1);
                    
                end
                
            end
            
        end
        
        if keyCode(KbName('f')) && barFlickerEnabled == 0
            
            barFlickerEnabled = 1;
            
            disp('switched to flickering bars');
            
            ss('f (flickering bars)');
            
        end
        
        if keyCode(KbName('s')) && barFlickerEnabled == 1
            
            barFlickerEnabled = 0;
            
            disp('switched to static bars');
            
            ss('s (static bars)');
            
        end
        
        if keyCode(KbName('d')) && ~isequal(barCols, 0)
            
            barCols = 0;
            
            disp('switched to dark bars');
            
            ss('d (dark bars)');
            
        end    
        
        if keyCode(KbName('l')) && ~isequal(barCols, 1)
            
            barCols = 1;
            
            disp('switched to light bars');
            
            ss('l (light bars)');
            
        end          
        
       
        
        if (keyCode(KbName('Space')))
            
            str1 = ifelse(barCols, 'light', 'dark');
            
            str2 = ifelse(barFlickerEnabled, 'flickering', 'static');
            
            str3 = ifelse(pmode, 'binocular', 'monocular');
            
            str4 = sprintf('pattern %d', numPressed);
            
            strAll = sprintf( ...
                'space (start presenting: %s, %s, %s, %s)', ...
                str1, str2, str3, str4);
            
            ss(strAll);
            
            break;
            
        end
        
        if (keyCode(KbName('c')))
            
            cMode = 1;
            
            numPressed = 1;
            
            ss('started continuous presentation mode');
            
            break;
            
        end
        
        
    end
    
    home
    
    map1 = createMap({0 1 -1 -2 -3 -4 -5}, {'monocular', 'binocular', ...
        'two-bar (1,2)', 'two-bar (2,3)', 'two-bar (3,4)', ...
        'two-bar (4,5)', 'two-bar (5,6)'});
    
    fprintf('Selected mode : %s\n\n', map1.get(pmode));
    
    ss(sprintf('Starting pattern %d', numPressed));
    
    paramSet = genParamSet(nbars, barCols, numPressed, pmode);    
    
    % start presenting
    
    for i=1:size(paramSet, 1)
        
        p = paramSet(i, :);
        
        ss(sprintf('condition %d of %d', i, size(paramSet, 1)));
        
        fprintf('condition %d of %d: ', i, size(paramSet, 1));
        
        fprintf('%g, ', p);
        
        fprintf('\n');
        
        % draw ON
        
        w = 0;        
        
        j = 1;
        
        ss('ON');
        
        for dummy=1:onFrames
            
            w = mod(w+1, barFlickerFramePeriod);
            
            if w == 0 && barFlickerEnabled
            
                j = 1 - j;
            
            end
            
            fbox.pattern = 0.5 * (1 + j);
            
            if barCols
                
                fbox.pattern = fbox.pattern * 0.1;
                
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
            
            if checkS() && cMode
               
                ss('pressed (s) - continuous mode will end after this pattern');
                
                cMode = 0;
                
            end
            
        end
        
        % end of draw on
        
        % draw off
        
        ss('OFF');
        
        fbox.pattern = 0.2;
        
        if barCols
            
            fbox.pattern = fbox.pattern * 0.1;
            
        end
        
        for dummy=1:offFrames
            
            Screen('SelectStereoDrawBuffer', window, 0);
            
            drawFlickerBox(window, fbox);
            
            Screen('SelectStereoDrawBuffer', window, 1);
            
            fbox = drawFlickerBox(window, fbox);
            
            Screen(window, 'Flip');
            
            k = checkEscapeKeys();
            
            if checkS() && cMode
               
                ss('pressed (s) - continuous mode will end after this pattern');
                
                cMode = 0;
                
            end
            
            if k
                
                exitCode = k;
                
                return;
                
            end
            
        end
        
        % end of draw off
        
    end
    
    ss('end of pattern');
    
    if cMode
        
        pause(cModeDelay);
        
        numPressed = numPressed + 1;
        
        if numPressed > 9            
            
            numPressed = 1;
            
        end
        
    end
    
end

end

function s = checkS()

s = 0;

[~, ~, keyCode] = KbCheck;
    
if keyCode(KbName('s'))
    
    s = 1;    

end

end

function paramSet = genParamSet(nbars, barCols, seed, pmode)

paramSet1 = createTrial(1:nbars, 1:nbars, barCols, barCols);

paramSet2 = createTrial(1:nbars, 1, barCols, 0.5);

paramSet3 = createTrial(1, 1:nbars, 0.5, barCols);

if pmode<0
    
    b1 = -pmode;
    b2 = b1+1;
    
    % thus:
    % pmode = -1 -> 1,2
    % pmode = -2 -> 2,3
    % pmode = -3 -> 3,4
    % pmode = -4 -> 4,5
    % pmode = -5 -> 5,6
    
    conds = [b1 b2 0 0; b2 b1 0 0] + [0 0 1 1; 0 0 1 1] * barCols;
    
    paramSet = repmat(conds, [1e4/2 1]);    

elseif pmode == 2
    
    % two bars
    
    % deprecated mode
    
    conds = [3 4 0 0; 4 3 0 0] + [0 0 1 1; 0 0 1 1] * barCols;
    
    paramSet = repmat(conds, [1e4/2 1]);

elseif pmode == 1
    
    % monocular
    
    paramSet = [paramSet1; paramSet2; paramSet3];
    
    rng(seed);
    
    k = randperm(size(paramSet, 1));
    
    paramSet = paramSet(k, :);
    
elseif pmode == 0
    
    % binocular
    
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

function fbox = drawBlank(window, fbox)

fbox.pattern = 0;

Screen('SelectStereoDrawBuffer', window, 0);

drawFlickerBox(window, fbox);

Screen('SelectStereoDrawBuffer', window, 1);

fbox = drawFlickerBox(window, fbox);

Screen(window, 'Flip');
     
end
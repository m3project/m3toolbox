% runFieldDots
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 11/12/2015

function exitCode = runFieldDots(varargin)

% dot reso is number of dots per unit area

stimType = 0;

dotReso = 55; % dots (per unit area - as defined in renderFieldDots)

% NB: stimType and dotReso can be overriden by supplying a packed struct as
% an input to this function. The function runFieldLines() does that.

if nargin>0
    
    if isstruct(varargin{1})
        
        args = varargin{1};
        
        unpackStruct(args);
        
    end
    
end

exitCode = 0;

sobj = initSerial();

ss = @(str) sendSerial(sobj, str);

expt = struct('dot_pB', 0.5, 'dotContrast', 1, 'ss', ss, ...
    'stimType', stimType, 'dotReso', dotReso, 'bars', [3 4]);

initWindow();

while 1 % outer loop (input and presentation)
    
    disp('Press (1-9) to set dot contrast to 0.1 -> 0.9');
    
    disp('Press (0) to set dot contrast to 1.0');
    
    disp('Hold (t) and press (1-5) to select bar positions');
    
    disp('Press (d) for dark dots, (l) for light dots or (m) for mixed dots');
    
    disp('Press (Space) to start presentation');
    
    disp('Press (e) to end presentation');
    
    while 1 % inner loop (input)
        
        [~, ~, keyCode] = KbCheck;
        
        exitCode = checkEscapeKeys(keyCode);
        
        if exitCode, return, end
        
        if keyCode(KbName('d')) && ~isequal(expt.dot_pB, 0)
            
            expt.dot_pB = 0;
            
            ss('d (dark dots)');
            
        end
        
        if keyCode(KbName('l')) && ~isequal(expt.dot_pB, 1)
            
            expt.dot_pB = 1;
            
            ss('l (light dots)');
            
        end
        
        if keyCode(KbName('m')) && ~isequal(expt.dot_pB, 0.5)
            
            expt.dot_pB = 0.5;
            
            ss('m (mixed dots)');
            
        end
        
        if keyCode(KbName('t'))
            
            numsPressed = intersect(find(keyCode), ('1':'5') + 0);
            
            if ~isempty(numsPressed)
                
                numPressed = min(numsPressed) - '0';
                
                new_bars = numPressed + [0 1];
                
                if ~isequal(new_bars, expt.bars)
                    
                    expt.bars = new_bars;
                    
                    ss(sprintf('switched to bars %d,%d', ...
                        new_bars(1), new_bars(2)));
                    
                end
                
            end
            
        else
            
            numsPressed = intersect(find(keyCode), ('0':'9') + 0);
            
            if ~isempty(numsPressed)
                
                numPressed = min(numsPressed) - '0';
                
                newContrast = ifelse(numPressed>0, numPressed/10, 1);
                
                if newContrast ~= expt.dotContrast
                    
                    expt.dotContrast = newContrast;
                    
                    str1 = sprintf('dot contrast = %1.1f', newContrast);
                    
                    ss(str1);
                    
                end
                
            end
            
        end
        
        if (keyCode(KbName('Space')))
            
            break; % quit input selection
            
        end
        
    end
    
    % after breaking from input loop, start presentation
    
    exitCode = renderFieldDots(expt);
    
    if exitCode, return, end
    
end

end

function initWindow(DEBUG) %#ok

KbName('UnifyKeyNames');

windowOpen = ~isempty(Screen('windows'));

if nargin>0
    
    warning('DEBUG=1 in initWindow, set to zero when running experiment');
    
    if windowOpen, return, end
    
end

if windowOpen
    
    error('please close existing PTB windows');
    
end

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

for channel = [0 1]
    
    Screen('SelectStereoDrawBuffer', window, channel);
    
    Screen(window, 'FillRect', [1 1 1] * 0.5);
    
end

Screen(window, 'flip');

end

function exitCode = renderFieldDots(expt)

% overridable parameters

dotContrast = 1;

dot_pB = 0.5; % sensible value: 0 or 1

escapeEnabled = 1;

ss = @(str) []; % serial send function (to be overridden)

bars = [3 4]; % two bar positions (1 through 6)

%% control parameters

drawGrid = 0; % preview bar grid

testRedBlue = 0; % 1 for red/blue, 0 for green/blue (NB sca after changing)

dotRefreshPeriod = 30; % refresh period in frames

previewHuman = 0; % set to 1 to enable easy settings for human preview

%% constants

dot_pC = 1; % sensible values: 0 or 1

bg_pB = dot_pB;
bg_pC = dot_pC;

drawBars = 1;
drawBG = 1;

nreps = 1e5; % numer of repeats, each rep is left/off/right/off

%% parameters that match behavioral experiments

% NB values below are the same as Vivek's behav experiment
% (runMantisExperimentCorrAnaglyph)
% i.e. dotReso = 55; unitArea = 1e4; dotRad = 20;

if ~all(isfield(expt, {'dotReso', 'stimType'}))
    
    error('function renderFieldDots() requires arguments `dotReso` and `stimType`');
    
end

unitArea = 100 * 100; % px^2

dotRad = 15; % dot radius (px) % changed this on 10/12/2015 (GT,RR)

%% load overrides

if nargin>0

    unpackStruct(expt);

end

%% parameters from runFieldBars

% NB these must have the same values as in runFieldBars so that bars
% have identical positions and sizes

nbars = 6; % number of bars

% vm = [550 390]; % top and bottom margins (px)

vm = [0 0];

screenReso = 37; % px/cm

viewD = 10; % viewing distance (cm)

m = 666; % horizontal margin - both left and right (px)

tOn = 0.5; % seconds (will be rounded to the nearest number of frames)

tOff = 0.5; % seconds (will be rounded to the nearest number of frames)

%% prepare window

window = getWindow();

[sW, sH] = getResolution();

if testRedBlue
    
    SetAnaglyphStereoParameters('RightGains', window, [1 0 0]); %#ok
    
    SetAnaglyphStereoParameters('LeftGains', window, [0 0 1]);
    
end

%% calculate on and off periods

fps = 60;

if abs(fps - getFrameRate() > 3)
    
    error('fps set to %d while getFrameRate() returns %d', fps, getFrameRate());
    
end

onFrames = round(tOn * fps);

offFrames = round(tOff * fps);

nF = ones(onFrames, 1);
fF = zeros(offFrames, 1);

sequence = [nF; fF; -nF; fF];

if mod(length(sequence), dotRefreshPeriod)
    
    % if this is triggered then dot refreshes and sequences may not be
    % sync
    
    warning('sequence length is not integer multiple of dotRefreshPeriod');
    
    keyboard
    
end

% each element in sequence indicates:
% 1 : draw bars
% 0 : do not draw bars (off frame)
% -1 : draw bars but flip channels

%% prepare bar position functions

barPos = calBarPositions(sW, screenReso, viewD, m, nbars);

getBar = @(i) [barPos(i, 1) vm(1) barPos(i, 2) sH-vm(2)];

%% wrapper functions

makeDots = @(rect, pB, pC) ...
    makeRandDotPattern(dotReso, unitArea, rect, pB, pC);

drawDots = @(pos, channel) drawDots0(pos, window, dotRad, ...
    channel, dotContrast, stimType, sH);

%% preview grid

if drawGrid
    
    for channel = [0 1] %#ok
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * 0.5);
        
        for i=1:nbars
            
            Screen(window, 'FrameRect', [0 0 0], getBar(i));
            
        end
        
    end
    
    Screen(window, 'flip');
    
    return
    
end

%% send parameters via ss

map1 = createMap({0, 0.5, 1}, {'dark', 'mixed', 'light'});

dotTypeStr = map1.get(dot_pB);

ss(sprintf('start (%s dots with contrast=%1.1f)', dotTypeStr, dotContrast));

%% draw

exitCode = 0;

fbox = createFlickerBox(150, 55);

fbox.pattern = 0.5 + 0.5 * sequence;

n = length(sequence);

for i = repmat(1:n, [1 nreps])
    
    if (dotRefreshPeriod==1) || mod(i, dotRefreshPeriod) == 1
        
        sRect = [0 0 sW sH];
        
        bgs(:, :, 1) = makeDots(sRect, bg_pB, bg_pC);
        bgs(:, :, 2) = makeDots(sRect, bg_pB, bg_pC);
        
        bgs(:, :, 2) = bgs(:, :, 1);
        
        cutOutRect(:, :, 1) = getBar(bars(1));
        cutOutRect(:, :, 2) = getBar(bars(2));
        
        cutOutRect(1, 3, 1) = cutOutRect(1, 3, 1) + 1;
        
        if previewHuman
        
            cutOutRect(:, :, 2) = cutOutRect(:, :, 1) + [1 0 1 0] * 20; %#ok
        
        end
        
        barDots = makeDots(cutOutRect(:,:,1), dot_pB, dot_pC);
        
    end
    
    sequenceFrame = mod(i-1, length(sequence))+1;
    
    frameType = sequence(sequenceFrame);
    
    oldFrameType = sequence(max(sequenceFrame-1, 1));
    
    frameTypeChange = (i==1) || (frameType ~= oldFrameType);
    
    if frameTypeChange
        
        ss(sprintf('%d', frameType));
        
    end
    
    for channel = [0 1]
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'FillRect', [1 1 1] * 0.5);
        
        if ~frameType
            
            % off frame
            
            chRect = [0 0 0 0]; % no cut-out rectangle
            
        else
            
            % this bit will flip channel when frameType == -1
            
            selChannel = ifelse(frameType==1, channel, 1-channel);
            
            chRect = cutOutRect(:, :, selChannel+1);
            
        end
        
        % draw background
        
        if drawBG
            
            bg = bgs(:, :, channel+1);
            
            bg = keepOutside(bg, chRect);
            
            drawDots(bg, channel);
            
        end
        
        % draw bars
        
        if drawBars && abs(frameType)
            
            barDotsChannel = moveDots(barDots, cutOutRect(:,:, selChannel+1), chRect);
            
            drawDots(barDotsChannel, channel);
            
        end
        
        drawFlickerBox(window, fbox);
        
    end
    
    fbox = drawFlickerBox(window, fbox);
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('e'))) && escapeEnabled
        
        ss('presentation ended');
            
        break;            

    end
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode, return, end
    
    Screen(window, 'Flip');

end

end

function pos = makeRandDotPattern(dotReso, unitArea, rect, pB, pC)

% this function generates N dots in the reactangle `rect`
% where N is `dotReso` x `unitArea`

% pB is proportion of bright dots (0 to 1)
% pC is proportion of correlated dots (0 to 1)

% it returns an Nx4 matrix where each row represents a single dot as:
% [x, y, b, c]

% where:
% x, y are the dot coordinates
% b is the dot brightness (0 for dark, 1 for bright)
% c specifies dot correlation when painting (1 for corr, 0 for anti-corr)

rW = rect(3) - rect(1);
rH = rect(4) - rect(2);

nDots = round(dotReso / unitArea * rW * rH);

rx0 = rect(1);
ry0 = rect(2);

% pB = 1; % proportion of bright dots (0 to 1)
% pC = 1; % proportion of correlated dots (0 to 1)

b = rand(nDots, 1) > (1-pB);
c = rand(nDots, 1) > (1-pC);

rr = @(x) rand(nDots, 1) * x;

pos = [rx0+rr(rW) ry0+rr(rH) b c];

end

function drawDots0(pos, window, dotRad, channel, dotContrast, stimType, sH)

if ~isempty(pos)
    
    B = pos(:, 3);
    
    if channel
        
        B = B .* pos(:,4) + (1-B) .* (1-pos(:,4));
        
    end
    
    B = 0.5 - dotContrast * 0.5 * power(-1, B);
    
    if ~stimType
        
        Screen(window, 'DrawDots', pos(:,1:2)', dotRad, (B * [1 1 1])', [], 2);
        
    else
        
        x = round(pos(:, 1) - dotRad/2);
        
        rectPos = [x x*0 x+dotRad x*0+sH];
        
        Screen(window, 'FillRect', (B * [1 1 1])' , rectPos');
        
    end
    
end

end

function pos = moveDots(pos, oldRect, newRect)

recW = @(rect) rect(3) - rect(1);
recH = @(rect) rect(4) - rect(2);

if ~isequal([recW(oldRect) recH(oldRect)], [recW(newRect) recH(newRect)])
    
    error('rectangles must be of equal sizes');
    
end

dx = newRect(1) - oldRect(1);
dy = newRect(2) - oldRect(2);

pos = [pos(:,1)+dx pos(:,2)+dy pos(:,3:4)];

end

function y = inside(pos, rect)

y = ...
(pos(:, 1)>rect(1)) .* ...
(pos(:, 1)<rect(3)) .* ...
(pos(:, 2)>rect(2)) .* ...
(pos(:, 2)<rect(4));

end

function pos = keepInside(pos, rect) %#ok

y = inside(pos, rect);

pos = pos(y>0, :);

end

function pos = keepOutside(pos, rect)

y = inside(pos, rect);

pos = pos(~y, :);

end

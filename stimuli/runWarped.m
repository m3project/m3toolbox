function runWarped(args)

% stimulus parameters

screenReso = 40; % px/cm

viewD = 7; % cm

fs = 0.1; % spatial frequency (cpd)

initialDelay = 1; % seconds

n = 2; % bug oscillation count

bugSpeed = 74; % deg/sec

bugWidth = 23.3; % FWHM of bug (degrees)

bugType = 1; % 0 = black bug, 1 = sine bug

dir = 1; % -1 or 1

bugContrast = 1;

escapeEnabled = 1;

offScreenDuration = 2; % seconds

applyWarping = 0;

addChequer = 0;

if nargin
    
    unpackStruct(args);
    
end

%% get screen parameters

if isempty(Screen('windows'))

    createWindow(1.01);
    
    warning('PTB window created by stimulus, Gamma setting may be incorrect');
    
end

window = getWindow();

fps = getFrameRate();

[sW, sH] = getResolution();

% calculations

bugHeightPx = 200;

if applyWarping
    
    degs = px2deg(sW, screenReso, viewD);
    
    ydegs = px2deg(bugHeightPx, screenReso, viewD);
    
else
    
    degs = (1:sW) - sW/2;
    
    period_degs = 1/fs;
    
    period_px = 2 * tand(period_degs/2) * viewD * screenReso;
    
    fs_cppx = 1/period_px;
    
    tf = bugSpeed * fs;
    
    bugSpeed_px_sec = tf / fs_cppx;
    
    bugWidth_px = 2 * tand(bugWidth/2) * viewD * screenReso;
    
    ydegs = (1:bugHeightPx) - bugHeightPx/2;
    
    % change
    
    fs = fs_cppx;
    
    bugSpeed = bugSpeed_px_sec;

    bugWidth = bugWidth_px;

end

scrWidthDegs = range(degs);

buffer = bugSpeed/2 * offScreenDuration;

extent = (scrWidthDegs/2 + buffer);

duration = initialDelay + 4 * extent / bugSpeed * n;

sd = bugWidth / 2.3548; % in degrees

frames = duration * fps;

%% position calculations

t0 = initialDelay - offScreenDuration/2;

getPosition = @(t) zigZag_wrapper(t0, n, extent, bugSpeed, t);

previewPosFunc = 0;

if previewPosFunc
    
    ezplot(getPosition, [0 duration]);
    
    return
    
end

%% generate chequered texture

if addChequer
    
    chequer = genChequer(struct('W', sW, 'H', sH, 'blockSize', 40));
    
    chequerID = Screen('MakeTexture', window, chequer, [], [], 2);
    
end

%% rendering loop

KbName('UnifyKeyNames')

f1 = @(varargin) deallocTextures(window);

obj1 = onCleanup(f1);

for i=1:frames
    
    t = i/fps;

    m = -dir * getPosition(t);

    xenv = gauss(m, sd, degs);
    
    if bugType == 0
        
        xstrip = -xenv;
        
    elseif bugType == 1
    
        xstrip = sin(2*pi*((degs-m)*fs)) .* xenv;
        
    else
        
        error('invalid bugType');
        
    end
    
    ystrip = gauss(0, sd/2, ydegs); 
    
    bugPatContrast = ystrip' * xstrip;
    
    bugPatLum = 0.5 + bugContrast/2 * bugPatContrast;

    % draw
    
    txtID = Screen('MakeTexture', window, bugPatLum, [], [], 2);

    rect = [0 0 sW bugHeightPx] + [0 1 0 1] * (sH - bugHeightPx)/2;
    
    Screen(window, 'FillRect' , [1 1 1] * 0.5);
    
    if addChequer
    
        Screen('DrawTexture', window, chequerID);
        
    end
    
    Screen('DrawTexture', window, txtID, [], rect);
    
    Screen(window, 'Flip');
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('Escape'))) && escapeEnabled
        
        break;
        
    end
    
end

end

function deallocTextures(window)

scrIDs = Screen('windows');

txtIDs = setdiff(scrIDs, window);

Screen('close', txtIDs);

end

function y = gauss(m, sd, x)

y = exp(-(x-m).^2/(2*sd^2));

end

function s = zigZag_wrapper(t0, n, extent, speed, t)

% this is a wrapper for zigZag

% the parameters are:
% t0     : initial delay
% n      : number of oscillations
% extent : amplitude of oscillation
% speed  : defined as (2*extent/period)

period = 4 * extent / speed;

s = extent * zigZag(t0, period, n, t);

end

function s = zigZag(t0, period, n, t)

% a zig-zag oscillation function, starts at -1 and from t0 to (t0+period*n)
% oscillates with a period of `period`

% params

% t0 = 1; % initial delay
% 
% period = 10; % period of oscillation
% 
% n = 3; % number of oscillations
% 
% t = linspace(0, 50, 1e3);

% body

y = sawtooth((t-t0)/period*(2*pi), 0.5);

t1 = t0 + period * n;

w = (t>t0) .* (t<t1);

s = (y .* w) -1 * (1-w);

% plot(t, s);

end

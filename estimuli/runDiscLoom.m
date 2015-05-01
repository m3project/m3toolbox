function exitCode = runDiscLoom(logEvent, keyPress)

if nargin<1
    
    logEvent = @(str) str; % dummy function
    
end

if nargin<2
    
    keyPress = @(keyCode) 1; % dummy function
    
end

logEvent('runDiscLoom');

%% flicker brightness levels

flickerLevels_motion = [0 40];

flickerLevels_loom = [80 255];

flickerLevels_receed = [80 120];

%% parameters

spatialPeriod = 192; % pixels (use a divisor of the screen width)

b = 1; % background brightness (0 to 1)

bugY = 0.6; % vertical position (0 to 1)

flickSize = 150; % dimensions of photodiode patch (px)

preview = 0; % plots bug motion sequences

displayPlot = 0; % live plot of diode and bug radius

gratingSpeed = 1000; % px/sec (use sign to indicate motion direction)

jitterSpeed = 0; % max speed of jitter (px) using rand()

d0 = 4; % initial delay

d1 = 4; % min-sequence delay ("stationary disc duration +looming duration")

d2 = 2; % background motion buffer

d3 = 0; % first x seconds when bug is invisible

enaExtraSlide = 1; % when set to 1 the background will move in integer steps of spatialPeriod

%% setup ptb windows

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

createWindow(Gamma);

window = getWindow();

[sW, sH] = getResolution();

close all;

%% bug and looming parameters

bugColor = [0 0 0];

viewD = 5;

virtDist1 = 5;

virtDist2 = 0.05;

speed = 5;

t2 = 5;

%% print keyboard shortcuts

shortcuts = {
    'Up',               'Loom', ...
    'Down',             'Receed', ...
    'Right',            'Loom (with background motion)', ...
    'Left',             'Receed (with background motion)', ...
    'l',                'Switch direction to left', ...
    'r',                'Switch direction to right', ...
    'Escape or End',	'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% motion function

dtr = (virtDist1 - virtDist2) / speed; % transition time

r1 = getR(viewD, virtDist1, virtDist2, speed);

[rLoom1, rReceed1, backMotionEna1] = getFuncs(d0, d1, 0, d3, r1, t2, dtr);

[rLoom2, rReceed2, backMotionEna2] = getFuncs(d0+d2, d1, d2, d3, r1, t2, dtr);

if preview
    
    t = 0:1/1200:30;
    
    subplot(2, 1, 1);
    
    plot(t, [rLoom1(t); rReceed1(t); backMotionEna1(t)*100]);
    
    subplot(2, 1, 2);
    
    plot(t, [rLoom2(t); rReceed2(t); backMotionEna2(t)*100]);
    
    return
    
end

%% constants and inline functions for texture generation

x = 1:sW;

sin2 = @(x) (1+sin(x)*b)/2;

cos2 = @(x) (1+cos(x)*b)/2;

%% flicker box

flickerRect = [0 sH-55 150 sH];

flicker = 0;

%% animation

startTime = GetSecs();

r = @(t) rLoom1(0);

oldR = r(0);

n = 800;

colorHistory = zeros(n, 1);

rHistory = zeros(n, 1);

if displayPlot
    
    figure(1); subplot(2, 1, 1);
    
    h1 = plot(colorHistory);
    
    axis([1 n 1 500]); title('Diode');
    
    subplot(2, 1, 2);
    
    h2 = plot(rHistory);
    
    axis([1 n 1 1000]); title('R');
    
end

%d = @(t) t * gratingSpeed;

d = 0;

% the initial shift (d) is chosen such that the screen center is white

levels = [0 0];

oldT = startTime;

mEna = @(t) 0;

dir = 1;

oldKeyIsDown = 1;

flip_t1 = 0;

processTimes = zeros(1e3, 1);

i = 1;

while 1
    
    t = GetSecs() - startTime;
    
    deltaT = t - oldT;
    
    d = d + deltaT * gratingSpeed * mEna(t) * dir;
    
    d = d + deltaT * jitterSpeed * rand * mEna(t) * dir;
    
    shift_error = mod(d, spatialPeriod);
    
    if enaExtraSlide && ~mEna(t) && abs(shift_error)>15
        
        d = d + deltaT * gratingSpeed * dir;
        
    end
    
    oldT = t;    
    
    s = sign(r(t) - oldR);
    
    if abs(s) || mEna(t)
        
        flicker = 1 - flicker;
    
    end
    
    if mEna(t)
        
        levels = flickerLevels_motion;
        
    end
    
    if s == 1
        
        levels = flickerLevels_loom;
        
    end
    
    if s == -1
        
        levels = flickerLevels_receed;
        
    end
    
    oldR = r(t);   
    
    rect = [1 0 1 0] * sW * 0.5 + [0 1 0 1] * sH * bugY + [-1 -1 1 1] * r(t)/2;
    
    texture1 = cos2(2*pi*(x-d)/spatialPeriod) * 255;

    textureIndex = Screen(window, 'MakeTexture', texture1);    
    
    Screen(window, 'DrawTexture', textureIndex, [], [0 0 sW sH]);
    
    Screen(window, 'FillOval', bugColor, rect');
    
    Screen(window, 'FillRect', [1 1 1] * levels(flicker+1), flickerRect);
    
    if displayPlot
        
        colorHistory = [colorHistory(2:end); levels(flicker+1)];
        
        rHistory = [rHistory(2:end); r(t)];
        
        set(h1, 'YData', colorHistory);
        
        set(h2, 'YData', rHistory);
        
        drawnow;
        
    end
    
    flip_t2 = GetSecs();
    
    processTimes(i) = flip_t1 - flip_t2;
    
    Screen(window, 'Flip');
    
    flip_t1 = GetSecs();
    
    i = mod(i, 1e3) + 1;
    
    [keyIsDown, ~, keyCode] = KbCheck;
    
    exitCode = checkEscapeKeys(keyCode);
    
    if exitCode
        
        return
        
    end
    
    if keyIsDown && ~oldKeyIsDown
        
        keyPress(keyCode);
        
        if r(t)
            
            y = [KbName('UpArrow') KbName('DownArrow') KbName('RightArrow') KbName('LeftArrow')];
            
            if any(keyCode(y))
                
                %  warning('Current motion sequence still playing');
                
            end
            
        else
            
            if keyCode(KbName('UpArrow'))
                
                r = @(ct) rLoom1(ct - t);
                
                mEna = @(ct) backMotionEna1(ct - t);
                
                logEvent('start looming (static background)');
                
            end
            
            if keyCode(KbName('DownArrow'))
                
                r = @(ct) rReceed1(ct - t);
                
                mEna = @(ct) backMotionEna1(ct - t);
                
                logEvent('start receeding (static background)');
                
            end
            
            if keyCode(KbName('RightArrow'))
                
                r = @(ct) rLoom2(ct - t);
                
                mEna = @(ct) backMotionEna2(ct - t);
                
                logEvent('start looming (moving background)');
                
            end
            
            if keyCode(KbName('LeftArrow'))
                
                r = @(ct) rReceed2(ct - t);
                
                mEna = @(ct) backMotionEna2(ct - t);
                
                logEvent('start receeding (moving background)');
                
            end
            
        end
        
        if keyCode(KbName('l')) && dir == 1
            
            dir = -1;
            
            disp('direction switched to left');
            
            logEvent('direction switched to left');
            
        end
        
        if keyCode(KbName('r')) && dir == -1
            
            dir = 1;
            
            disp('direction switched to right');
            
            logEvent('direction switched to right');
            
        end        
       
    end
    
    oldKeyIsDown = keyIsDown;
    
end

closeWindow();

end

function r = getR(viewD, virtDist1, virtDist2, speed)

% this function returns a looming motion function

d = @(t) max(virtDist1 - t * speed, virtDist2);

theta = @(t) atand(viewD./d(t));

r = @(t) viewD * tand(theta(max(t, 0)));

end

function [rLoom, rReceed, backMotionEna] = getFuncs(d0, d1, d2, d3, r1, t2, dtr)

rLoom = @(t) (-r1(t2) + r1(t-d0) + r1(-(t-d1-d0-dtr))) .* (t>d3) .* (t<d0+dtr+d1+d0);

rReceed = @(t) (r1(dtr+d0-t) + r1(-(d1+d0-t))) .* (t>d3) .* (t<d0+dtr+d1+d0);

backMotionEna = @(t) (t>0) .* (t>d0-d2) .* (t<d0+d1+dtr+d2) * abs(sign(d2));

end
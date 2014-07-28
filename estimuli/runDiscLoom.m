function exitCode = runDiscLoom
%% parameters

spatialPeriod = 200; % pixels

b = 1; % background brightness (0 to 1)

bugY = 0.6; % vertical position (0 to 1)

flickSize = 150; % dimensions of photodiode patch (px)

preview = 0; % plots bug motion sequences

displayPlot = 0; % live plot of diode and bug radius

gratingSpeed = 1000; % px/sec (use sign to indicate motion direction)

jitterSpeed = 0; % max speed of jitter (px) using rand()

d0 = 4; % initial delay

d1 = 4; % min-sequence delay ("stationary disc duration +looming duration")

d2 = 4; % background motion buffer

d3 = 0; % first x seconds when bug is invisible

%% setup ptb windows

KbName('UnifyKeyNames');

createWindow();

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

%% motion function

dtr = (virtDist1 - virtDist2) / speed; % transition time

r1 = getR(viewD, virtDist1, virtDist2, speed);

[rLoom1, rReceed1, backMotionEna1] = getFuncs(d0, d1, 0, d3, r1, t2, dtr);

[rLoom2, rReceed2, backMotionEna2] = getFuncs(d0+d2, d1, d2, d3, r1, t2, dtr);

if preview
    
    t = 0:1/60:30;
    
    subplot(2, 1, 1);
    
    plot(t, [rLoom1(t); rReceed1(t); backMotionEna1(t)*100]);
    
    subplot(2, 1, 2);
    
    plot(t, [rLoom2(t); rReceed2(t); backMotionEna2(t)*100]);
    
    return
    
end

%% constants and inline functions for texture generation

x = 1:sW;

sin2 = @(x) (1+sin(x)*b)/2;

%% flicker box

flickerRect = [0 sH-flickSize flickSize sH];

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

levels = [0 0];

oldT = startTime;

mEna = @(t) 0;

while 1
    
    t = GetSecs() - startTime;
    
    deltaT = t - oldT;
    
    d = d + deltaT * gratingSpeed * mEna(t);
    
    d = d + deltaT * jitterSpeed * rand * mEna(t);
    
    oldT = t;    
    
    s = sign(r(t) - oldR);
    
    if abs(s) || mEna(t)
        
        flicker = 1 - flicker;
    
    end
    
    if mEna(t)
        
        levels = [0 40];
        
    end
    
    if s == 1
        
        levels = [80 255];
        
    end
    
    if s == -1
        
        levels = [80 120];
        
    end
    
    oldR = r(t);   
    
    rect = [1 0 1 0] * sW * 0.5 + [0 1 0 1] * sH * bugY + [-1 -1 1 1] * r(t)/2;
    
    texture1 = sin2(2*pi*(x-d)/spatialPeriod) * 255;

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
    
    Screen(window, 'Flip');
    
    [~, ~, keyCode ] = KbCheck;
    
    if r(t)
        
        y = [KbName('UpArrow') KbName('DownArrow') KbName('RightArrow') KbName('LeftArrow')];
        
        if any(keyCode(y))
            
          %  warning('Current motion sequence still playing');
            
        end
        
    else
        
    
        if keyCode(KbName('UpArrow'))

            r = @(ct) rLoom1(ct - t);

            mEna = @(ct) backMotionEna1(ct - t);

        end

        if keyCode(KbName('DownArrow'))

            r = @(ct) rReceed1(ct - t);

            mEna = @(ct) backMotionEna1(ct - t);

        end

        if keyCode(KbName('RightArrow'))

            r = @(ct) rLoom2(ct - t);

            mEna = @(ct) backMotionEna2(ct - t);

        end

        if keyCode(KbName('LeftArrow'))

            r = @(ct) rReceed2(ct - t);

            mEna = @(ct) backMotionEna2(ct - t);

        end   
    
    end
    
    if keyCode(KbName('Escape'))
        
        exitCode = 0;
        
        break;
        
    end
    
    if keyCode(KbName('END'))

        exitCode = 1;

        break;

    end
    
end

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
function runDotsJudith(expt)

%closeWindow();

KbName('UnifyKeyNames');

%% parameters

n = 5000; % number of dots

m = 1000; % number of bug dots

colormode = 1; % (0) white, (1) grayscale, (otherwise) colored

speed = 10; % speed of background dots

r = 20; % radius of dots

swim = 1; % (0) move in straight line, (1) swim

swimInterval = 0.1; % don't care

swimAngleMax = 45; % don't care

disparity = 20; % disparity in pixels (could be negative)

bugSpeed = 200; % horizontal bug speed

bugSize = 100; % bug size

padding = r/2; % don't care

bugY = 0.75; % vertical position of bug relative to screen (in the range 0 to 1)*

bugOscillation = 100; % vertical oscillation extent in pixels (peak-to-peak)*

dir = -1; % direction of bug travel (1=right, -1=left)

duration = 8; % duration of stimulus in seconds

bugStillTime = 2; % how long (in seconds) does the bug stay at the centre of the screen before moving

%% body

if nargin>0
    
    unpackStruct(expt);
    
end

createWindow3D();

window = getWindow();

[sW, sH] = getResolution();

xs = rand(n, 1) * sW;
ys = rand(n, 1) * sH/2;

bugxs = rand(m, 1) * bugSize;
bugys = rand(m, 1) * bugSize;

colMax = 255;

if colormode == 0
    
    cols = ones(n, 3) * colMax;
    
elseif colormode == 1
    
    cols = repmat(rand(n, 1), 1, 3) * colMax;
    
else
    
    cols = rand(n, 3) * colMax;
    
end

cols = uint8(cols);

angles = rand(n, 1) * 2 * pi;

startTime = GetSecs();

lastt = startTime;

lastSwim = 0;

swirlActive = 1;

swirlT = 0;

[swirlX, swirlY] = getSwirl(sW/2, sH/2 * bugY);

t3 = 0;

pos = @(x) x * (sign(x)+1)/2; % return x if x>0 and zero otherwise

while (1)
    
    t = GetSecs() - startTime;
    
    dt = t - lastt;
    
    lastt = t;
    
    if swim && (t - lastSwim)>swimInterval
        
        angleChange = (rand(n, 1)-0.5) * 2 * swimAngleMax * (pi/180);
        
        angles = angles + angleChange;
        
        lastSwim = t;
        
    end
    
    angles = mod(angles, 2*pi);
    
    dxs = speed * cos(angles);
    dys = speed * sin(angles);
    
    xs = mod(xs + dxs * dt, sW);
    ys = mod(ys + dys * dt, sH/2);
    
    % bouncing off the right edge:
    
    headingRight = (angles<pi/2) | (angles>1.5*pi);
    
    inBounceZone = (xs > sW - padding);
    
    toBounce = inBounceZone & headingRight;
    
    angles(toBounce) = pi - angles(toBounce);
    
    % bouncing off the left edge:
    
    headingLeft = (angles>pi/2) & (angles<1.5*pi);
    
    inBounceZone = (xs < padding);
    
    toBounce = inBounceZone & headingLeft;
    
    angles(toBounce) = pi - angles(toBounce);
    
    % bouncing off the top edge:
    
    headingUp = (angles>pi) & (angles<2*pi);
    
    inBounceZone = (ys < padding/2);
    
    toBounce = inBounceZone & headingUp;
    
    angles(toBounce) = 2*pi - angles(toBounce);
    
    % bouncing off the bottom edge:
    
    headingDown = (angles>0) & (angles<pi);
    
    inBounceZone = (ys > sH/2 - padding/2);
    
    toBounce = inBounceZone & headingDown;
    
    angles(toBounce) = 2*pi - angles(toBounce);
    
    if swirlActive
        
        absBugX = swirlX(t - t3);
        absBugY = swirlY(t - t3) + sin(2*pi*(t-t3)*10) * bugOscillation/2;
        
    else
        
        t2 = t - swirlT;
        
        
        %if dir == 1
        
            absBugX = sW/2 + dir * pos(t2-bugStillTime) * bugSpeed;
        
        %else
            
%            absBugX = sW - t2 * bugSpeed;
            
%        end
        
        absBugY = bugY * sH/2 + sin(2*pi*t2*10)*bugOscillation/2;
        
    end
    
    xs(end-m+1:end) = 0 + absBugX + bugxs;
    
    ys(end-m+1:end) = absBugY + bugys/2 - bugSize/4;
    
    rects = [xs ys xs+r ys+r/2];
    
    cols2 = cols;
    
    if swirlActive
        
        cols2(n-m:end, :) = 1;
        
    end
    
    for channel = [0 1]
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        k1 = 1:n-m;
        
        k2 = n-m+1:n;
        
        rects(k1, [1 3]) = rects(k1, [1 3]) + (0) * channel;
        
        rects(k2, [1 3]) = rects(k2, [1 3]) + disparity * (1-swirlActive) * channel;
        
        %Screen(window, 'FillOval', cols', rects');
        
        Screen(window, 'DrawDots', rects(:, [1 2])', r, cols2',[],2); % [,color] [,center] [,dot_type]);
        
        
    end
    
    Screen(window, 'Flip');
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('End')) && swirlActive)
        
        swirlActive = 0;
        
        swirlT = t;
        
        disp('Rendering the disparity stimulus ... ');
        
    end    
    
    if (keyCode(KbName('Escape')))
        
        break;
        
    end  
    
    if (keyCode(KbName('s')))
        
        t3 = t;
        
    end  
    
    if swirlActive == 0 && t-swirlT>duration
        
        break;
        
    end
    
    
end

end

function [X, Y] = getSwirl(centerX, centerY)

theta1 = @(t) (t * 2 * pi);

theta2 = @(t) (min(4, t) * 2 * pi);

motionR = @(t) 400 * (cos(theta2(t) * 0.1)+1);

v = 0.5;

X = @(t) centerX + cos(theta1(t) * v) * motionR(t);
Y = @(t) centerY + sin(theta1(t) * v) * motionR(t)/2;

% t1 = @(t) t;
%
% X = X(t1(t));
% Y = Y(t1(t));

%XY      = @(t) [X(t1(t)) Y(t1(t))];

end


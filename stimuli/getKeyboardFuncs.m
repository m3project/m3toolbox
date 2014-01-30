
function motionFuncs = getKeyboardFuncs(P)

% P is the probability that the bug will steer on its own ([0, 1])

motionFuncs.XY      = @(t) XY(t, P);
motionFuncs.Angle   = @(t) Angle(t);
motionFuncs.F       = @(t) t * 30;
motionFuncs.S       = @(t) 1;

end

function result = Angle(t, go_angle, emergency)

persistent alpha;
persistent steer_active;
persistent steer_final_angle;
persistent emergency_steer_active;

delta = 4;

if (nargin<3)
    
    emergency = 0;
    
end

if (isempty(alpha))
    
    alpha = 0;
    
end

if (isempty(steer_active))
    
    steer_active = 0;
    
end

if (isempty(steer_final_angle))
    
    steer_final_angle = 0;
    
end

if (isempty(emergency_steer_active))
    
    emergency_steer_active = 0;
    
end

if ((nargin > 1 && ~steer_active) || (emergency && ~emergency_steer_active))
    
    % initiate steering
    
    steer_active = 1;
    
    steer_final_angle = go_angle;
    
    if (emergency)
        emergency_steer_active = 1;
    end
    
end

if (steer_active)
    
    if (alpha < steer_final_angle - delta)
        
        % steer anti-clockwise
        
        alpha = mod(alpha + delta, 360);
        
    end
    
    if (alpha>steer_final_angle + delta)
        
        % steer clockwise
        
        alpha = mod(alpha - delta, 360);
        
    end
    
    if (abs(steer_final_angle - alpha) < 2 * delta)
        
        % finish steering
        
        steer_active = 0;
        
        emergency_steer_active = 0;
        
    end
    
    result = alpha;
    
    return; % exit function, do not process keyboard events
    
end

% keyboard steering:

[keyIsDown, secs, keyCode ] = KbCheck;

if (keyCode(KbName('LeftArrow')))
    
    alpha = mod(alpha + delta, 360);
    
end

if (keyCode(KbName('RightArrow')))
    
    alpha = mod(alpha - delta, 360);
    
end

result = alpha;

end

function b = isAngle(angle, dir)

switch dir
    case 'up'
        b = (angle >= 0) && (angle <= 180);
    case 'down'
        b = (angle >= 180) && (angle <= 360);
    case 'right'
        b = (angle <= 90) || (angle >= 270);
    case 'left'
        b = (angle >= 90) && (angle <= 270);
end

end

function result = XY(t, P)

% P is the probability that the bug will steer on its own ([0,1])

if (nargin<2)
    
    % if P is not specified, default to 0 (no steering)
    
    P = 0;
    
end



persistent x;
persistent y;

if (isempty(x))
    
    x = 0;
    
end

if (isempty(y))
    
    y = 0;
    
end

 [w h] = getResolution();

xMin=600 - w/2;
xMax=900 - w/2;

yMin=700 - h/2;
yMax=900 - h/2;

xDif = abs(x-(xMin+xMax)/2);

xDifMax = (xMax-xMin)/2;
yDifMax = (yMax-yMin)/2;

maxDif =  sqrt(xDifMax^2 + yDifMax^2);

yDif = abs(y-(yMin+yMax)/2);

speed = 1 + 0 * sqrt(xDif^2 + yDif^2) / maxDif ;
speed = 5;

x = x + cos(Angle(t) / 180 * pi) * speed;
y = y - sin(Angle(t) / 180 * pi) * speed;

%
% 
% xMax = w/2 - 100;
% 
% xMin = -xMax;
% 
% yMax = h/2 - 100;
% 
% yMin = -yMax;


b = 500;


if (x>xMax + b)
    x = xMin - 10;
end

if (x<xMin - b)
    x = xMax + 10;
end

if (y>yMax + b)
    y = yMin - 10;
end

if (y<yMin - b)
    y = yMax + 10;
end

if (x>xMax || x<xMin || y>yMax || y<yMin)
    
    xD = x-(xMin+xMax)/2;
    yD = y-(yMin+yMax)/2;
    
    beta = ATand2(-yD, xD) + 180;    
    
    beta = mod(beta, 360);
    
    Angle(t, beta);
    
else
    
    if (rand<P)
        
        % start steering
        
        theta = floor(rand*360);
        
        Angle(t, theta);
    end
    
end

result = [x y];

end

function motionFuncs = getMotionFuncs(id, varargin)

switch (id)
    
    case 'swirl'
        
        centerX = 0;
        centerY = 100;
        
        if nargin>1
            
            % if any additional arguments are supplied for 'swirl', they'll
            % be assumed as override values for centerX and centerY:
            
            centerX = varargin{1};
            centerY = varargin{2};
            
        end
        
        theta1 = @(t) (t * 2 * pi);
        
        theta2 = @(t) (min(4, t) * 2 * pi);
        
        motionR = @(t) 200 * (cos(theta2(t) * 0.1)+1);
        
        v = 0.5;
        
        X = @(t) centerX + cos(theta1(t) * v) * motionR(t);

        Y = @(t) centerY + sin(theta1(t) * v) * motionR(t);
        
        t1 = @(t) t;
        
        motionFuncs.XY      = @(t) [X(t1(t)) Y(t1(t))];
        motionFuncs.Angle   = @(t) 270 - (t1(t) * v * 360);
        motionFuncs.F       = @(t) t1(t) * 60;
        motionFuncs.S       = @(t) 1;        
       
    case 'circle'
        
        theta1 = @(t) (t * 2 * pi);
        
        motionR = @(t) 200;
        
        v = 0.25;
        
        X = @(t) cos(theta1(t) * v) * motionR(t);
        Y = @(t) sin(theta1(t) * v) * motionR(t);
        
        motionFuncs.XY      = @(t) [X(t) Y(t)];
        motionFuncs.Angle   = @(t) 270 - (t * v * 360);
        motionFuncs.F       = @(t) t * 60;
        motionFuncs.S       = @(t) 1;
        
    case 'sine'
        
        jitter = 10;
        
        %motionFuncs.XY      = @(t) [mod(t * 200, 700)-400 250] + rand * jitter;
        motionFuncs.XY      = @(t) [sin(t*2*pi/2/0.8/2)*400 - 50 250] + rand * jitter;
        motionFuncs.Angle   = @(t) 0;
        motionFuncs.F       = @(t) t * 60;
        motionFuncs.S       = @(t) 0.25 + 0.25 * abs(cos(t*2*pi/2/0.8/2));
        
    case 'horizontal'
        
        jitter = 10;
        
        motionFuncs.XY      = @(t) [t 0] + rand * jitter;
        motionFuncs.Angle   = @(t) 0;
        motionFuncs.F       = @(t) t * 60;
        motionFuncs.S       = @(t) 1;
        
    case 'zigzag'
        
        theta1 = @(t) (t * 2 * pi);
        
        motionR = @(t) 100;
        
        v = 1.005;
        
        X = @(t) -(mod(t * 500, 2000)- 300);
        Y = @(t) sin(theta1(t) * v) * motionR(t) + 150;
        Y = @(t) 300;
        
        motionFuncs.XY      = @(t) [-X(t) Y(t)];
        motionFuncs.Angle   = @(t) sin(theta1(t) * v) * 25;
        motionFuncs.Angle = @(t) 180;
        motionFuncs.F       = @(t) t * 60;
        motionFuncs.S       = @(t) 1;
        
    case 'keyboard'
        
        motionFuncs = getKeyboardFuncs(0);
        
    case 'auto'
        
        motionFuncs = getKeyboardFuncs(0.025);
        
    otherwise
        
        motionFuncs.XY      = @(t) [0 0];
        motionFuncs.Angle   = @(t) 0;
        motionFuncs.F       = @(t) t * 10;
        motionFuncs.S       = @(t) 1;
end

end

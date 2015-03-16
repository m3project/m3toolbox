
function runAlignmentStimulusNoBack()

% coordinates of bug swirling center:

x = 0;

y = 0;

% render alignment stimulus

expt = struct;

expt.interactiveMode = 1;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.enable3D = 0;

expt.disparity = 0;

expt.M = 40;

expt.R = 1;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) 0;

expt.stepDX = 0;

expt.bugFrames = getBugFrames('fly');

expt.motionFuncs = getSwirl(x, y);

expt.nominalSize = 0.25; % change bug size here

expt.bugVisible = 1;

expt.txtCount = 50;

expt.bugVisible = 1;

expt.timeLimit = 0;

expt.interactiveMode = 1;

disp('alignment mode (interactive), press Escape when mantis is aligned ...');

runAnimation2(expt);

end


function motionFuncs = getSwirl(varargin)

centerX = 0;

centerY = 350; % change bug y position

if nargin>1
    
    % if any additional arguments are supplied for 'swirl', they'll
    % be assumed as override values for centerX and centerY:
    
    centerX = varargin{1};
    centerY = varargin{2};
    
end

theta1 = @(t) (t * 2 * pi);

theta2 = @(t) (min(4, t) * 2 * pi);

motionR = @(t) 200 * (cos(theta2(t) * 0.1)+1);

v = 1.5; % change bug speed

X = @(t) centerX + cos(theta1(t) * v) * motionR(t);

Y = @(t) centerY + sin(theta1(t) * v) * motionR(t);

t1 = @(t) t;

motionFuncs.XY      = @(t) [X(t1(t)) Y(t1(t))];
motionFuncs.Angle   = @(t) 270 - (t1(t) * v * 360);
motionFuncs.F       = @(t) t1(t) * 60;
motionFuncs.S       = @(t) 1;

end
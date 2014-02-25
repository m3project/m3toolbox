function testDisparity()

disp('rendering the stimulus');

disparity = 20;

dir = 1;

expt = struct;

expt.disparity = disparity;

expt.interactiveMode = 0;

expt.timeLimit = 0;

expt.closeOnFinish = 0;

expt.M = 20;

expt.dynamicBackground = 0;

expt.txtCount = 200;

expt.R = 0.5;

expt.textured = 0;

expt.camouflage = 0;

expt.stepDX = 1;

expt.bugFrames{1} = ones(3,3); %getBugFrames('dot');

%expt.motionFuncs = getMotionFuncDispCamo(dir);

%expt.motionFuncs = getMotionFuncs('swirl');

expt.motionFuncs = getMotionFuncMouse();

expt.nominalSize = 1;

expt.bugVisible = 1;

expt.enable3D = 1;

expt.enableBackground = 1;

[~, ~, ~, exitCode, dump] = runAnimation3(expt);

end

function motionFuncs = getMotionFuncMouse()

motionFuncs.XY      = @(t) [getMouseX() getMouseY()]-500;

motionFuncs.Angle   = @(t) 180;
motionFuncs.F       = @(t) t * 60;
motionFuncs.S       = @(t) 1;

end

function x = getMouseX()

[x, ~] = GetMouse();

end

function y = getMouseY()

[~, y] = GetMouse();

end

function motionFuncs = getMotionFuncDispCamo(dir)

% preparing motion functions

theta1 = @(t) (t * 15 * pi);

theta3 = @(t) (t * 0.5 * pi);

theta2 = @(t) (min(10, t) * 3 * pi);

t2 = @(t) mod(t, 15);

v = 0.5;

motionR = @(t) 200 * (cos(theta2(t2(t)) * 0.1)+1);

 %motionR = @(t) 50;

%X = @(t) dir * (mod(t * 500, 2000));
X = @(t) 250 + 1 * -t2(t) + cos(theta2(t2(t)) * v) *  motionR(t2(t)) + rand*0;

Y = @(t) 250 + 1 * sin(theta2(t2(t)) * v) * motionR(t2(t))/2 + rand*0;

motionFuncs.XY      = @(t) [X(t) Y(t)];
motionFuncs.Angle   = @(t) sin(theta1(t) * v) * 25;
motionFuncs.Angle   = @(t) 180;
motionFuncs.F       = @(t) t * 60;
motionFuncs.S       = @(t) 1;

end

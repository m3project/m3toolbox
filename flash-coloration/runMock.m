function exitCode = runMock()

    condition = 1;

    recordGaze = 0;

    [sW, sH] = getResolution();

    bugHeight = 100; % px (tip to base)

    bugDir = randi([0 1]); % 0 for leftwards, 1 for rightwards

    bugY = sH/2; % bug y position (px)

    bugSpeed = 500; % px/sec

    margin = bugHeight;

    x1 = margin; x2 = sW - margin; % lower/upper limits of bug end position (px)

    %% Eyelink

    if recordGaze

        openEyelink();

        file = startEyelinkRecording();

        obj1 = onCleanup(@closeEyelink);

        onStart = @() tagEyelink('Start');

        onTrigger = @() tagEyelink('Trigger');

    else

        onStart = @() disp('Stimulus started ...');

        onTrigger = @() disp('Motion triggered ...');

    end

    %% Sanity checks

    % Check that x1 and x2 do not cause the bug to be out of the screen

    assert(x1 > bugHeight/2, 'x1 too small');

    assert(x2 < sW - bugHeight/2, 'x2 too large');

    %% Condition logic

    % For each condition, decide:
    %
    % distance: travelled distance, in integer multiples of bug height
    %
    % isBodyVisible: lambda specifying when is the colored body part visible
    %
    % postMotionDelay: delay after end of motion (seconds)

    staticBugPostMotion = 1; % TODO: check with Diana

    % Travelled distances are expressed with respect to distanceUnit.

    % The side length of an equilateral triangle (a) and its height (h) are
    % related by h = a sin(60)
    %
    % Source: http://mathworld.wolfram.com/EquilateralTriangle.html

    bugSideLength = bugHeight / sind(60);

    distanceUnit = round(bugSideLength); % TODO: check with Diana: side or height?

    if condition == 1

        % Cs (static bug, cryptic all the time)

        isBodyVisible = @(varargin) false;

        postMotionDelay = staticBugPostMotion;

        [bugLeft, bugRight] = getMotionLimits(x1, x2, 0);

    elseif condition == 2

        % Fs (static bug, flash-coloration after detection)

        isBodyVisible = @(t, inMotion, motionTriggered) motionTriggered;

        postMotionDelay = staticBugPostMotion;

        [bugLeft, bugRight] = getMotionLimits(x1, x2, 0);

    elseif condition == 3

        % C-6 (moving bug, cryptic)

        distance = 6;

        isBodyVisible = @(varargin) false;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * distanceUnit);

    elseif condition == 4

        % C-12 (moving bug, cryptic)

        distance = 12;

        isBodyVisible = @(varargin) false;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * distanceUnit);

    elseif condition == 5

        % F1-6 (moving bug, distance 6, flash colored all the way)

        distance = 6;

        isBodyVisible = @(t, inMotion, motionTriggered) inMotion;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * distanceUnit);

    elseif condition == 6

        % F1-12 (moving bug, distance 12, flash colored all the way)

        distance = 12;

        isBodyVisible = @(t, inMotion, motionTriggered) inMotion;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * distanceUnit);

    elseif condition == 7

        % F2-6 (moving bug, distance 6, flash colored for 4 distance units)

        distance = 6;

        bodyDistance = (distance - 2) * distanceUnit;

        bodyVisibleDuration = bodyDistance / bugSpeed;

        isBodyVisible = @(t, inMotion, motionTriggered) ...
            inMotion && (t < bodyVisibleDuration);

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * distanceUnit);

    elseif condition == 8

        % F2-12 (moving bug, distance 12, flash colored for 10 distance
        % units)

        distance = 12;

        bodyDistance = (distance - 2) * distanceUnit;

        bodyVisibleDuration = bodyDistance / bugSpeed;

        isBodyVisible = @(t, inMotion, motionTriggered) ...
            inMotion && (t < bodyVisibleDuration);

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * distanceUnit);

    elseif condition == 9

        % D1 (moving bug, moves until outside screen, cryptic all the way)

        isBodyVisible = @(varargin) false;

        postMotionDelay = 0;

        bugLeft = randi([x1 x2]);

        bugRight = sW + bugHeight; % end position is off screen

    elseif condition == 10

        % D2 (moving bug, moves until outside screen, flash colored all the
        % way)

        isBodyVisible = @(t, inMotion, motionTriggered) inMotion;

        postMotionDelay = 0;

        bugLeft = randi([x1 x2]);

        bugRight = sW + bugHeight; % end position is off screen

    else

        error('unrecognized condition');

    end

    %% Render

    % See note in section 'Limit functions' below on naming conventions,
    % i.e. distinction between bugLeft, bugRight and bugStart

    bugStart = ifelse(bugDir, bugLeft, sW - bugLeft);

    motionDistance = abs(bugRight - bugLeft);

    [exitCode, triggerTime, clickPoints, bugPosPoints] = ...
        runFlashColoration(struct( ...
            'wing', nan, ...
            'onStart', onStart, ...
            'bugBody', [1 0 0], ...
            'bugSpeed', bugSpeed, ...
            'bugAngle', ifelse(bugDir, 0, 180), ...
            'onTrigger', onTrigger, ...
            'bodyLateral', 0.5, ...
            'bugInitialPos', [bugStart bugY], ...
            'isBodyVisible', isBodyVisible, ...
            'motionDistance', motionDistance, ...
            'postMotionDelay', postMotionDelay ...
        ));

end

%% Limit functions

% These are helper functions to select bug start and end positions
% (along the horizontal). x1 < x2 by definition meaning x1 is left and
% x2 is right. Elsewhere in the code these are referred to as bugLeft
% and bugRight correspondingly.

% Note that, when the bug is moving leftwards, the start position is
% bugRight. I've used the name 'bugStart' to refer to whichever of
% bugLeft/bugRight happens to be the starting position.

function [x1, x2] = getMotionLimitsBothInside(mn, mx, d)

% Return two values [x1, x2] in the range [mn, mx] subject to the following
% constraints:
%
% 1. x1 and x2 are both in [mn, mx]
% 2. x2 - x1 = d

x1_max = mx - d; % max value for x1 such that (x1 + d <= mx)

x1 = randi([mn x1_max]);

x2 = x1 + d;

end

function [x1, x2] = getMotionLimits(mn, mx, d)

% Return two values [x1, x2] where only x1 is in the range [mn, mx],
% subject to the following constraint:
%
% 1. x2 - x1 = d

x1 = randi([mn mx]);

x2 = x1 + d;

end

%% Deprecated

function exitCode = runMockBug()

bugDir = randi([0 1]); % 0 for leftwards, 1 for rightwards

% bugDir = 1;

bugAngle = ifelse(bugDir, 180, 0);

% bugAngle = 180;

sW = 1920; sH = 1200;

M = 480; % margin (px)

clc

% (randomly) select bug position

% bugX = randi([M sW-M]);

if isequal(bugDir, 0)

    bugX = randi([M sW/2]);

else

    bugX = randi([sW/2 sW-M]);

end

bugY = randi([M sH-M]);

% bugY = 600;

% (randomly) select bug initial displacement

maxDisp = ifelse(bugDir, bugX, sW - bugX) % maximum initial displacement (px)

minDisp = 500; % mininum initial displacement (px)

initDisplacement = randi([minDisp maxDisp])

exitCode = runFlashColoration(struct( ...
    'bugAngle', bugAngle, ...
    'initDisplacement', initDisplacement, ...
    'bugFinalPosition', [bugX bugY] ...
    ));

if exitCode; return; end

waitKey('Space');

end

function waitKey(key)

% Wait until key is pressed.

while (1)

    drawnow

    [~, ~, keyCode ] = KbCheck;

    if (keyCode(KbName(key)))

        break;

    end

end

end

function waitClick()

% First, wait until any pressed buttons are released.

buttons = 1;

while any(buttons)

    [~, ~, buttons] = GetMouse();

end

% Now wait until any button is pressed.

buttons = 0;

while ~any(buttons)

    [~, ~, buttons] = GetMouse();

end

end


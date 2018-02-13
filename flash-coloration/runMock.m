function runMock()

createWindow();

recordGaze = 0;

if recordGaze

    openEyelink();

    file = startEyelinkRecording();

    obj1 = onCleanup(@closeEyelink);

end

runCondition();

% while 1

%     exitCode = runMockBug();

%     if exitCode; break; end

% end

% if exitCode == 2; sca; end

end

function exitCode = runCondition()

    [sW, sH] = getResolution();

    bugHeight = 100; % px (tip to base)

    bugDir = randi([0 1]); % 0 for leftwards, 1 for rightwards

    bugY = sH/2; % bug y position (px)

    bugSpeed = 500; % px/sec

    margin = bugHeight;

    x1 = margin; x2 = sW - margin; % lower/upper limits of bug end position (px)

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

    condition = 10;

    staticBugPostMotion = 1; % TODO: check with Diana

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
            getMotionLimitsBothInside(x1, x2, distance * bugHeight);

    elseif condition == 4

        % C-12 (moving bug, cryptic)

        distance = 12;

        isBodyVisible = @(varargin) false;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * bugHeight);

    elseif condition == 5

        % F1-6 (moving bug, distance 6, flash colored all the way)

        distance = 6;

        isBodyVisible = @(t, inMotion, motionTriggered) inMotion;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * bugHeight);

    elseif condition == 6

        % F1-12 (moving bug, distance 12, flash colored all the way)

        distance = 12;

        isBodyVisible = @(t, inMotion, motionTriggered) inMotion;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * bugHeight);

    elseif condition == 7

        % F2-6 (moving bug, distance 6, flash colored for 4 distance units)

        distance = 6;

        bodyDistance = (distance - 2) * bugHeight;

        bodyVisibleDuration = bodyDistance / bugSpeed;

        isBodyVisible = @(t, inMotion, motionTriggered) ...
            inMotion && (t < bodyVisibleDuration);

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * bugHeight);

    elseif condition == 8

        % F2-12 (moving bug, distance 12, flash colored for 10 distance
        % units)

        distance = 12;

        bodyDistance = (distance - 2) * bugHeight;

        bodyVisibleDuration = bodyDistance / bugSpeed;

        isBodyVisible = @(t, inMotion, motionTriggered) ...
            inMotion && (t < bodyVisibleDuration);

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimitsBothInside(x1, x2, distance * bugHeight);

    elseif condition == 9

        % D1 (moving bug, moves until outside screen, cryptic all the way)

        distance = (sW + bugHeight) / bugHeight;

        isBodyVisible = @(varargin) false;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimits(x1, x2, distance * bugHeight);

    elseif condition == 10

        % D2 (moving bug, moves until outside screen, flash colored all the
        % way)

        distance = (sW + bugHeight) / bugHeight;

        isBodyVisible = @(t, inMotion, motionTriggered) inMotion;

        postMotionDelay = 0;

        [bugLeft, bugRight] = ...
            getMotionLimits(x1, x2, distance * bugHeight);

    else

        error('unrecognized condition');

    end

    %% Render

    bugStart = ifelse(bugDir, bugLeft, sW - bugLeft);

    motionDistance = abs(bugRight - bugLeft);

    exitCode = runFlashColoration(struct( ...
        'bugAngle', ifelse(bugDir, 0, 180), ...
        'motionDistance', motionDistance, ...
        'bugInitialPos', [bugStart bugY], ...
        'bodyLateral', 0.5, ...
        'wing', nan, ...
        'bugSpeed', bugSpeed, ...
        'isBodyVisible', isBodyVisible, ...
        'postMotionDelay', postMotionDelay, ...
        'bugBody', [1 0 0] ...
        ));

end

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


function exitCode = runFlashColoration(args)

% parameters

bugHeight = 100; % pixels

bugDimension = bugHeight * 2; % bug texture size (px)

bodyLateral = 2/3; % relative size of bug body part (1 = equilateral)

wingLateral = 1; % relative size of bug wing part (1 = equilateral)

wing = [1 0 0]; % nan (same as bug), scalar (lum) or RGB triplet
% wing = nan;
bugAngle = randi(360); % bug orientation angle in degrees (0 = leftwards)

initDisplacement = randi([400 700]); % initial bug displacement from final position (px)

bugSpeed = 500; % bug speed (px/sec)

bugFinalPosition = [randi([100 400]) randi([200 1000])]; % final position of bug *center*

videoFile = ''; % leave empty to disable recording

recordingFrameRate = 60; % fps

postMotionDelay = 0; % seconds

preMotionDelay = 0; % seconds

% bugBody:
%
% nan         : 1/f pattern
% scalar      : luminance value [0, 1]
% vector      : RGB triplet
% 'background': cut from background at final position

bugBody = nan;

% motionTrigger
%
% 'auto' : motion starts automatically
% 'buff' : motion starts when cursor enters buffer area

motionTrigger = 'buff';

bufferRadius = 100; % pixels

%%

if nargin

    unpackStruct(args);

end

%% quick checks

iseven = @(x) mod(x, 2) == 0;

assert(iseven(bugDimension));

%% create window

KbName('UnifyKeyNames');

createWindow();

[sW, sH] = getResolution();

window = getWindow();

%% generate patterns

backPattern = genNaturalPattern(struct('makePlot', 0, 'W', sW, 'H', sH));

backPattern = transp(backPattern);

if isequal(bugBody, 'background')

    xBackPat = bugFinalPosition(1) + (1:bugDimension) - bugDimension/2;
    yBackPat = bugFinalPosition(2) + (1:bugDimension) - bugDimension/2;

    bugBodyContent = backPattern(yBackPat, xBackPat);

else

    bugBodyContent = bugBody;

end

bugBodyPattern = genFlashColorationBug(struct( ...
    'bugHeight', bugHeight, ...
    'id', nan, ...
    'bugLateral', bodyLateral, ...
    'bugBodyContent', bugBodyContent, ...
    'd', bugDimension, ...
    'bugAngle', bugAngle));

% wingHeightCorrection is used to subtract 1 from wing pattern height;
% this avoids an off-by-one rendering issue where conspicuous wing pattern
% overflows bug pattern. This correction is applied when wing content is
% not the same as bug pattern.

wingSameBugPattern = isnan(wing);

wingHeightCorrection = ifelse(wingSameBugPattern, 0, 1);

bugWingPattern = genFlashColorationBug(struct( ...
    'bugHeight', bugHeight - wingHeightCorrection, ...
    'id', nan, ...
    'bugLateral', wingLateral, ...
    'bugBodyContent', ifelse(wingSameBugPattern, bugBodyContent, wing), ...
    'd', bugDimension, ...
    'bugAngle', bugAngle));

%% render

[h, w, ~] = size(bugBodyPattern);

makeTexture = @(pat) Screen('MakeTexture', window, pat * 255);

bug_txt = makeTexture(bugBodyPattern);
back_txt = makeTexture(backPattern);
wing_txt = makeTexture(bugWingPattern);

vx = bugSpeed * cosd(bugAngle); % velocity x component (px/sec)
vy = bugSpeed * sind(bugAngle); % velocity y component (px/sec)

dx = initDisplacement * cosd(bugAngle); % init disp in x direction (px)
dy = initDisplacement * sind(bugAngle); % init disp in y direction (px)

assert((bugFinalPosition(1) + dx) > 0);
assert((bugFinalPosition(2) + dy) > 0);

assert((bugFinalPosition(1) + dx) < sW);
assert((bugFinalPosition(2) + dy) < sH);

duration = initDisplacement / bugSpeed; % movement duration (seconds)

recording = recordStimulus(videoFile);

endRecording = @() recordStimulus(recording);

obj1 = onCleanup(endRecording);

t = 0;

% initial motionEnabled is false, unless motionTrigger equals 'auto'

motionEnabled = motionTrigger == 'auto';

while 1

    if motionEnabled

        frame = frame + 1;

        tReal = GetSecs() - t0;

        tFrames = frame / recordingFrameRate;

        t = ifelse(isempty(recording), tReal, tFrames);

        t = max(t - preMotionDelay, 0);

    else

        % check trigger

        if isequal(motionTrigger, 'auto')

            t0 = GetSecs();

            frame = 0;

            motionEnabled = 1;

        elseif isequal(motionTrigger, 'buff')

            [mx, my] = GetMouse(window);

            bugInitialPosition = bugFinalPosition + [dx dy];

            mouseDiff = [mx my] - bugInitialPosition;

            mouseDist = sqrt(sum(mouseDiff .^ 2));

            if mouseDist < bufferRadius

                t0 = GetSecs();

                frame = 0;

                motionEnabled = 1;

            end

        end


    end

    % calculate relative displacement from final position

    xr = ifelse(t < duration, dx - vx * t, 0);
    yr = ifelse(t < duration, dy - vy * t, 0);

    inMotion = (t > 0) && (t < duration);

    xr = round(xr);
    yr = round(yr);

    % calculate bug coordinate box

    bugRect = [0 0 w h];

    bugPos = bugRect + bugFinalPosition([1 2 1 2]) + ...
        [xr yr xr yr] - [1 1 1 1] * bugDimension/2;

    % draw textures

    Screen('FillRect', window, 255);

    Screen('DrawTexture', window, back_txt);

    if inMotion

        Screen('DrawTexture', window, wing_txt, bugRect, bugPos, 0);

    end

    Screen('DrawTexture', window, bug_txt, bugRect, bugPos, 0);

    Screen('Flip', window);

    recording = recordStimulus(recording);

    % checking for key presses

    [~, ~, keyCode ] = KbCheck;

    if (keyCode(KbName('Escape')))

        exitCode = 1;

        return

    end

    if (keyCode(KbName('End')))

        exitCode = 2;

        return

    end

    if t > (duration + postMotionDelay)

        exitCode = 0;

        return

    end

end

exitCode = 0;

end

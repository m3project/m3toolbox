function runMock()

createWindow();

recordGaze = 0;

if recordGaze

    openEyelink();

    file = startEyelinkRecording();

    obj1 = onCleanup(@closeEyelink);

end

while 1

    exitCode = runMockBug();

    if exitCode; break; end

end

if exitCode == 2; sca; end

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

waitClick();

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


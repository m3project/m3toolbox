function runSimpleHorizontalSwirl

%% stimulus parameters

delay1 = 1; % (seconds) time between the end of alignment stimulus and the onset of horizontal bug motion

motionDuration = 3; % (seconds) duration of horizontal motion

delay2 = 0; % (seconds) time between end of horizontal bug motion and start of alignment stimulus

bugY = 0.5; % vertical bug position (0 for top, 1 for bottom of screen);

bugWidth = 20; % in units of 10px

bugHeight = 6; % in unis of 10px

bugSpeed = 500; % px/sec

bugJitter = 5; % px/frame

Gamma = 1;

%% code

expt = struct;

expt.timeLimit = motionDuration;

expt.bugY = bugY;

expt.bugWidth = bugWidth;

expt.bugHeight = bugHeight;

expt.speed = bugSpeed;

expt.jitter = bugJitter;

cleanObj = onCleanup(@() closeWindow());

createWindow(Gamma);

while 1
    
    expt.dir = power(-1, rand>0.5);
    
    clearWindow([1 1 1] * 150);
    
    pause(delay1);
    
    runSimpleHoritzontal(expt);
    
    pause(delay2);
    
    runAnimation2();
    
end

end


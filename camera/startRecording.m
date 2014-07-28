function startRecording(cam1)

cam1.FrameGrabInterval = 1;

totalFrames = 1e5;

cam1.FramesPerTrigger = totalFrames;

delay(0.25);

start(cam1)

delay(0.25);

trigger(cam1);

end

function delay(seconds)

h = tic;

while toc(h)<seconds
    
    drawnow;
    
end

end
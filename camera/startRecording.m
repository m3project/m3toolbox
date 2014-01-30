function startRecording(cam1)

cam1.FrameGrabInterval = 1;

totalFrames = 1e5;

cam1.FramesPerTrigger = totalFrames;

start(cam1)

trigger(cam1);

end
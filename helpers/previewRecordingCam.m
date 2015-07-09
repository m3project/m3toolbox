function previewRecordingCam()

cam1 = initCam();

cleanup = @() deallocCam(cam1);

obj1 = onCleanup(cleanup);

preview(cam1);

disp('press any key when done');

pause();

end
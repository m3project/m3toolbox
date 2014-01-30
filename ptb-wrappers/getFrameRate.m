function frameRate = getFrameRate()

window = getWindow();

frameRate = Screen('FrameRate', window);

end
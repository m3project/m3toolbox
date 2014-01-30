% returns dimensions of screen
function [width height] = getResolution()

window = getWindow();

reso = Screen('Resolution', window);

width = reso.width;

height = reso.height;

end
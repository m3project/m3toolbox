% returns dimensions of screen
function [width, height] = getResolution()

%window = getWindow();

constants = getConstants;

window = constants.SCREEN_ID;

reso = Screen('Resolution', window);

width = reso.width;

height = reso.height;

end
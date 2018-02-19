function showMessage(text, size)

if nargin < 2

    text = 'Hello there people!';

    text = double(text);

    size = 160;

end

Screen('Preference', 'TextRenderer', 1);

createWindow();

window = getWindow();

oldSize = Screen('TextSize', window, size);

oldFont = Screen('TextFont', window, 'Dingbats');

% calculate positions

bounds = Screen('TextBounds', window, text);

% draw

tW = bounds(3);
tH = bounds(4);

[sW, sH] = getResolution();

tx = (sW - tW)/2;
ty = (sH - tH)/2;

color = 0.5;

Screen(window, 'FillRect' , color, [0 0 sW sH] );

Screen('DrawText', window, text, tx, ty);

Screen('Flip', window);

% restore previous settings

Screen('TextSize', window, oldSize);

Screen('TextFont', window, oldFont);

end
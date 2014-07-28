function draw3D

closeWindow();

createWindow3DAnaglyph();

[sW, sH] = getResolution();

%%
window = getWindow();

rect = [sW sH sW sH] / 2 + [-1 -1 1 1] * 50;

shift = [1 0 1 0] * 150;

Screen('SelectStereoDrawBuffer', window, 0);

Screen(window, 'FillRect', [1 1 1], rect + shift);

Screen('SelectStereoDrawBuffer', window, 1);

Screen(window, 'FillRect', [1 1 1], rect - shift);

Screen(window, 'Flip');

end
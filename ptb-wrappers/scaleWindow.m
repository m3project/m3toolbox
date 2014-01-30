% scales PTB window by a factor r around point center

function scaleWindow(center, rx, ry)

if nargin<3
    ry = rx;
end

window = getWindow();

Screen(window, 'glTranslate', center(1), center(2));

Screen(window, 'glScale', rx, ry);

Screen(window, 'glTranslate', -center(1), -center(2));

end
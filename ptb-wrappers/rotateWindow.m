% uses OpenGL to rotate window by an angle (degrees) around a certain
% point (center)
function rotateWindow(center, angle)

window = getWindow();

Screen(window, 'glTranslate', center(1), center(2));

Screen(window, 'glRotate', angle, 0, 0, -1);

Screen(window, 'glTranslate', -center(1), -center(2));

end
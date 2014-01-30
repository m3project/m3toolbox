% uses OpenGL to translate window by (x,y)
function translateWindow(x, y)

window = getWindow();

Screen(window, 'glTranslate', x, y);

end
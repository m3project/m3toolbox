% resets any openGL scale or rotate transformations
function resetWindow()

window = getWindow();

Screen(window, 'glLoadIdentity');

end
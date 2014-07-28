function clearWindow()

w = getWindow();

[sW, sH] = getResolution();

Screen(w, 'FillRect' , [1 1 1] * 0, [0 0 sW sH] );

%Screen(w, 'FillRect' , [0 0 0], [600 700 900 900] );

Screen(w, 'Flip');

end
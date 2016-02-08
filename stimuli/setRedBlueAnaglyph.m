% changes the left and right channels of a anaglyph 3D window to red/blue
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 16/12/2015

function setRedBlueAnaglyph()

window = getWindow();

SetAnaglyphStereoParameters('LeftGains', window, [1 0 0]);

SetAnaglyphStereoParameters('RightGains', window, [0 0 1]);

end
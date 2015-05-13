% converts px to degrees
%
% screenReso: resolution of monitor in px/cm
% viewD: viewing distance (between observer and monitor) in cm
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/5/2015

function deg = px2deg(px, screenReso, viewD)

cppx = 1 ./ px;

cpd = cppx2cpd(cppx, screenReso, viewD);

deg = 1 ./ cpd;

end
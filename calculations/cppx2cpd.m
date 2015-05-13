% converts cycles per px (cppx) to cycles per degree (cpd)
%
% screenReso: resolution of monitor in px/cm
% viewD: viewing distance (between observer and monitor) in cm
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/5/2015

function cppx = cppx2cpd(cppx, screenReso, viewD)

periodPX = 1 ./ cppx;

periodCM = periodPX / screenReso;

periodDegrees = 2 * atand(periodCM / 2 / viewD);

cppx = 1 ./ periodDegrees;

end
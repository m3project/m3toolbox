% converts degrees to px
%
% screenReso: resolution of monitor in px/cm
% viewD: viewing distance (between observer and monitor) in cm
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/5/2015

function px = deg2px(deg, screenReso, viewD)

cpd = 1 ./ deg;

cppx = cpd2cppx(cpd, screenReso, viewD);

px = 1 ./ cppx;

end
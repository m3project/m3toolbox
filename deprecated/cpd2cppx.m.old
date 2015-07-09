% converts cycles per degree (cpd) to cycles per px (cppx)
%
% screenReso: resolution of monitor in px/cm
% viewD: viewing distance (between observer and monitor) in cm
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/5/2015

function cppx = cpd2cppx(cpd, screenReso, viewD)

if nargin < 1
    
    cpd = logspace(-1.2, -1, 10);
    
    screenReso = 40;
    
    viewD = 4;
    
end

periodDegrees = 1 ./ cpd;

periodCM = 2 * tand(periodDegrees/2) * viewD;

periodPX = periodCM * screenReso;

cppx = 1 ./ periodPX;

end
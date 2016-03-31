% calculates the visual deg corresponding to each px on a monitor
% given monitor resolution and viewing distance  
%
% can be used to calculate angle subtended by a number of pixels by taking
% range(degs)
%
% scrWidthPx : screen width in px
% screenReso: resolution of monitor in px/cm
% viewD: viewing distance (between observer and monitor) in cm
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/5/2015

function [degs, px] = px2deg(scrWidthPx, screenReso, viewD)

isOdd = mod(scrWidthPx, 2) > 0;

if isOdd

    k = 1:floor(scrWidthPx/2);

    px = [-k(end:-1:1) 0 k];
    
else

    k = (1:scrWidthPx/2) - 0.5;

    px = [-k(end:-1:1) k];

end

cm = px / screenReso;

degs = atand(cm / viewD);

end

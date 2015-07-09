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

function degs = px2deg(scrWidthPx, screenReso, viewD)

if mod(scrWidthPx, 2) > 0
    
    error('scrWidthPx must be an integer multiple of 2');
    
end

k = (1:scrWidthPx/2) - 0.5;

px = [-k(end:-1:1) k];

cm = px / screenReso;

degs = atand(cm / viewD);

end

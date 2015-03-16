% calDisp
%
% calculates disparity given the viewing distance (viewD), simulated
% distance (simD) and inter-ocular distance (IOD)
%
% simD  : distance between viewer and simulated object
% viewD : distance between viewer and screen
% IOD   : distance between viewer eyes
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/03/2015

function disparity = calDisp(simD, viewD, IOD)

if simD < viewD
    
    % object in front of screen

    disparity = (viewD - simD) .* IOD ./ simD;
    
else
    
    % object behind screen
    
    disparity = IOD .* (simD - viewD) ./ simD;
    
end

end
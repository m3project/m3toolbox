% calDisp
%
% calculates disparity given the viewing distance (viewD), simulated
% distance (simD) and inter-ocular distance (IOD)
%
% simD  : distance between viewer and simulated object
% viewD : distance between viewer and screen
% IOD   : distance between viewer eyes
%
% note that the output of this function is signed disparity (i.e. positive
% and negative outputs indicates crossed and uncrossed conditions
% respectively)
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/03/2015

function disparity = calDisp(simD, viewD, IOD)

if simD < viewD
    
    % object in front of screen

    disparity = (viewD - simD) .* IOD ./ simD;
    
else
    
    % object behind screen
    
    disparity = -IOD .* (simD - viewD) ./ simD;
    
end

end
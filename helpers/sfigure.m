% same as figure except that it doesn't move focus away from the current
% window whent the figure is already created
%
% also doesn't bring up the figure window if it's minimized
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/8/2015

function h = sfigure(h)

if nargin > 0
    
    if ishandle(h)
        
        set(0, 'CurrentFigure', h);
        
    else        
        
        figure(h);
        
    end
    
else
    
    h = figure();
    
end

end
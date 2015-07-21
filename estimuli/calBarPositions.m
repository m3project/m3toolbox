% calculates the px positions (xstart, xend) of a number of verical bars
% across the screen
%
% the coordinates are calculated such that each bar subtends the same
% visual angle as the others
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 10/7/2015

function bars = calBarPositions(scrW, screenReso, viewD, m, bars)

makePlot = 0;

if nargin == 0
    
    scrW = 1000; % screen width (px)
    
    m = 200; % horizontal margin (px)
    
    screenReso = 37; % px/cm
    
    viewD = 7; % cm
    
    bars = 1;
    
    makePlot = 1;
    
end

W = scrW - 2 * m; % take out left and right margins

A = 2 * atand(W / screenReso / viewD / 2);

edges = bars + 1;

edgePosDegs = linspace(-A/2, A/2, edges)';

edgePosPx = tand(edgePosDegs) * viewD * screenReso;

xM = scrW / 2;

bars = ceil([edgePosPx(1:end-1) edgePosPx(2:end)] + xM);

if makePlot
    
    clf
    
    for i=1:size(bars, 1)
        
        x1 = bars(i, 1);
        x2 = bars(i, 2);
        
        x = x1;
        w = x2-x1;
        y = 0;
        h = 10;
        
        rectangle('Position', [x y w h], 'LineWidth', 2);
        
    end
    
    axis([1 scrW 0 10]);
    
end

end
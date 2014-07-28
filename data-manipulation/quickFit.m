% fits a straight line to (x, y)
%
% set useLog = 1 to fit log(x), log(y)
%
% set makePlot = 1 to plot on current figure
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 5/6/2014
%
function quickFit(x, y, useLog, makePlot)

if useLog
    
    x = log10(x);
    
    y = log10(y);
    
end

P = polyfit(x, y, 1);

yfit = P(1) * x + P(2);

if useLog
    
    x = power(10, x);
    
    yfit = power(10, yfit);
    
end

if makePlot
    
    plot(x, yfit,'-');

end

end
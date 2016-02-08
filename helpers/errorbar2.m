function h2 = errorbar2(x, y, l, u, varargin)

h2 = plot(x,y,varargin{:});

h = ~ishold;

if h, hold on, end

errorbar(x, y, -l, u);

if h, hold off, end

end
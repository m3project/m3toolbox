function h2 = errorbar2(x, y, l, u, varargin)

h2 = plot(x,y,varargin{:});

h = ~ishold;

if h
    hold on;
end

for i=1:length(x)
   
    plot([1 1]*x(i), y(i) + [-l(i) u(i)]);
    
end

if h
    hold off
end

end
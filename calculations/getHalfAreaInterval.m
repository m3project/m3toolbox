function [x0, x1] = getHalfAreaInterval(x, y)

makePlot = nargin == 0;

if nargin==0
    
    x = sort(rand(100, 1) * 10);
    
    y = sinc(x-5);
    
end

z = cumtrapz(x, abs(y));

n = 1:length(x);

[n0, n1] = meshgrid(n, n);

areas = (z(n1) - z(n0)) / z(end);

intSize = n1-n0; % interval sizes

cost = abs(areas-0.5); % cost function

costTol = 0.01; % cost tolerance

k = find(cost < costTol);

[~, ind] = min(intSize(k));

k2 = k(ind);

xs = x([n0(k2) n1(k2)]);

x0 = xs(1); x1 = xs(2);

if makePlot
    
    clf;
    
    subplot(2, 1, 1);
    
    mn = min(x); mx = max(x);
    
    imagesc(x, x, cost, [-1 1] * costTol); colormap(gray);
    
    hold on;
    
    plot(xs(1), xs(2), 'ro');
    
    axis equal;
    
    axis([mn mx mn mx]);
    
    subplot(2, 1, 2);
    
    plot(x, y);
    
    a = axis;
    
    hold on;
    
    plot([1 1] * xs(1), [-1 1] * 1e5, 'r');
    
    plot([1 1] * xs(2), [-1 1] * 1e5, 'r');
    
    axis(a);
    
    drawnow
    
end

end
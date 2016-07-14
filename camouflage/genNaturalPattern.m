function pattern = genNaturalPattern(expt)

W = 512; % width (px)

H = W; % height (px)

makePlot = 1;

if nargin>0
    
    makePlot = 0;
    
    unpackStruct(expt);
    
end

%%

[~, fx, fy] = jfft2(1:W, 1:H, rand(W, H));

[x, y] = meshgrid(fx, fy);

mag = @(x, y) sqrt(x.^2 + y.^2);

spec = 0.05 ./ (1e-10 + mag(x, y));

rnoise = rand(size(spec));

ph = angle(fft2(rnoise));

spec = spec .* exp(1i * ph);

s = ifft2(fftshift(spec));

pattern = abs(s);

pattern = scaleBugLum(pattern);

if makePlot
    
    subplot(2, 1, 1);   

    k=pattern(:); [min(k) mean(k) max(k)]
    
    imagesc(pattern', [0 1]);    
        
    subplot(2, 1, 2);
    
    imagesc(fx, fy, (abs(spec)), [0 1]);
    
    for i=1:2
        
        subplot(2, 1, i);
        
        colormap(gray);
        
        axis equal tight xy; colorbar;
        
    end
    
%     pattern = [];
    
end

end

function pattern = scaleBugLum(pattern)

% change mean to 0.5

pattern = pattern / mean(pattern(:)) * 0.5;

% scale min and max so that all luminance levels are in [0, 1]

k1 = abs(max(pattern(:)) - 0.5);
k2 = abs(min(pattern(:)) - 0.5);

k3 = max(k1, k2);

pattern = 0.5 + (pattern - 0.5)/k3/2;

end
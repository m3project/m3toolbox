function pattern = gen2DPattern(expt)

W = 512; % width (px)

H = 512; % height (px)

Fx = 0.005; % cycle/px

Sigx = 0.005; % cycle/px

makePlot = 1;

if nargin>0
    
    makePlot = 0;
    
    unpackStruct(expt);
    
end

%%

N = max(W, H);

xv = 1:N;
yv = 1:N;

expoFunc = @(x, xc, sigma) (x-xc).^2 / (2 * sigma^2);

[x, y] = meshgrid(xv, yv);

r = sqrt((x - (N/2+1)).^2 + (y - (N/2+1)).^2);

rc = Fx * N;

expo = expoFunc(r, rc, Sigx * N);

spec = exp(-expo);

rnoise = rand(size(spec));

ph = fftshift(angle(fft2(rnoise)));

spec = spec .* exp(1i * ph);

s = ifft2(fftshift(spec));

pattern = real(s);

pattern = pattern(1:W, 1:H);

if makePlot
    
    imagesc(pattern');
    
    colormap(gray);
    
    axis equal tight
    
    colorbar
    
end

end
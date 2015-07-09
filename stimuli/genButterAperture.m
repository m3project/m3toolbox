function y = genButterAperture(W, bandwidth, n)

% this is based on one of Ignacio's papers, it defines bandwidth as the
% distance between the 0.5 gain points

x = 1:W/2;

k = 1 ./ (1+(sqrt(x.^2)/(bandwidth/2)).^(2*n));

y = k([end:-1:1 1:end]);

end

function y = genButterApertureB(W, bandwidth, n) %#ok

% and old implementation by me, defines bandwidth as the distance between
% the 3dB points

% butterworth-like aperture

% wc : cutoff-value

% n : order

x = 1:W/2;

mybutter = @(x, wc, n) sqrt(1./(1+(x./wc).^(2*n)));

k = mybutter(x, bandwidth/2, n);

y = k([end:-1:1 1:end]);

end
% runGratingAperture
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 26/6/2015

function runGratingAperture(args)

% parameters

% Ignacio and I worked out how many degrees a screen of 1600px would
% subtend, we used this formula:

% range(px2deg(1600,40,7))/5 = 141.4 degrees

% dividing this by 5 segments, we got a deg step size of 28.28

apertureDeg = 28.28*1;

viewD = 7; % cm

sf = 40; % px/cm

butterOrder = 10;

makePlot = 0;

temporalFreq = 8; %#ok % Hz

spatialFreq = 1/200; %#ok % cppx

duration = 5; % seconds

dir = 1; % direction

flipAperture = 0;

contrast = 1;

Gamma = [];

if nargin>0
    
    unpackStruct(args);
    
end

%% body

aperturePx = tand(apertureDeg/2) * viewD * 2 * sf;

[W, ~] = getResolution();

apertureStrip = genButterAperture(W, aperturePx, butterOrder);

if flipAperture
    
    apertureStrip = 1 - apertureStrip;
    
end

grating = genGrating(packWorkspace('W', 'temporalFreq', 'spatialFreq', 'dir'));

frames = size(grating, 1);

aperture = repmat(apertureStrip, [frames 1]);

ys = 0.5 + 0.5 * grating .* aperture * contrast;

%% plots

if makePlot
    
    clf;
    
    subplot(2, 1, 1);
    
    hold on; plot(apertureStrip); grid on; 
    
%     axis([0 W -10 0]); plot([-1 1]*1e5, [-3 -3], '-r');
    
%     xlabel('px'); ylabel('gain (dB)');
    
    title('aperture');
    
    subplot(2, 1, 2);
    
    imagesc(ys, [0 1]); colormap(gray); xlabel('px'); ylabel('frames');
    
    title('pattern');
    
    drawnow
    
%     return
    
end

%% render

backPattern = reshape(ys', [1 W frames]);

runCamoPattern(struct('backPattern', backPattern, 'tileMode', 0, ...
    'escapeEnabled', 0, 'duration', duration, 'Gamma', Gamma));

end


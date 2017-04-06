% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 7/7/2015

function runGratingWarped(args)

% calculations:

% we need to render two gratings with spatial periods equal to those of
% Ignacio's 0.04 and 0.2 cpds *at the center of the screen*

% I've worked out the periods of Ignacio's frequencies (by running his
% script and inspecting the generated gratings) and found the following

% 0.04 cpd -> 266.6 px
% 0.20 cpd ->  55.2 px

% now I calculate the angle (alpha) subtended by a single px at the centre
% of the screen

alpha = range(px2deg(2,40,7))/2; % Ignacio is happy with this

% using alpha I calculate the deg spatial periods of Ignacio's 0.04 and 0.2
% cpds as follows

degs = [266.6 55.2] * alpha;

freqs = 1./degs;

% right, so now when I use freqs(1) and freqs(2) to generate the warped
% gratings I will get px periods that are almost equal to Ignacio's 0.04
% and 0.2 cpds *at the screen center*

%% parameters

duration = 5; % change to 5 for actual experiment

makePlot = 0;

rms = 0.14*0; %#ok

signalFreq = freqs(2); %#ok

freqRange = freqs(1) .* [1 1]; %#ok % cpd

temporalFreq = 8; %#ok % Hz

contrast = 0.5;

escapeEnabled = 1;

apertureDeg = 28.28 * 3;

flipAperture = 0;

useAperture = 0;

butterOrder = 10;

viewD = 7; % viewing distance (cm)

screenReso = 40; % monitor resolution (px/cm)

videoFile = '';

dir = 1; %#ok

if nargin>0
    
    unpackStruct(args);
    
end

%% body

signalAmp = contrast; %#ok

ys = genWarpedMaskedSignal(packWorkspace( ...
    'duration', 'makePlot', 'rms', 'signalFreq', ...
    'freqRange', 'signalAmp', 'dir', 'viewD', 'screenReso', 'temporalFreq'));

% apply aperture

if useAperture
    
    aperturePx = tand(apertureDeg/2) * viewD * 2 * screenReso;
    
    [W, ~] = getResolution();
   
    apertureStrip = genButterAperture(W, aperturePx, butterOrder);
    
    if flipAperture
        
        apertureStrip = 1 - apertureStrip;
        
    end
    
    frames = size(ys, 1);
    
    aperture = repmat(apertureStrip, [frames 1]);    
    
    ys = ys .* aperture;
    
end

if max(abs(ys(:)))>1
    
    error('luminance levels out of range');
    
end

if ~makePlot
    
    frames = size(ys, 1);
    
    [scrWidthPx, ~] = getResolution();

    ys = reshape(ys', [1 scrWidthPx frames]);
    
    ys = 0.5 + ys * 0.5;
    
    runCamoPattern(struct('backPattern', ys, 'tileMode', 0, ...
        'duration', duration, 'escapeEnabled', escapeEnabled, ...
        'videoFile', videoFile));
    
end

end
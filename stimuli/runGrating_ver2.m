function runGrating_ver2(args)

% parameters

sf = 1/100; % cppx

tf = 8; % Hz

duration = 5; % seconds

dir = 1; % direction

contrast = 1;

escapeEnabled = 1;

gratingFunc = @cos;

if nargin
    
    unpackStruct(args);
    
end

%% body

[sW, ~] = getResolution();

fps = getFrameRate();

grating = genGrating(struct('W', sW, 'temporalFreq', tf, ...
    'spatialFreq', sf, 'dir', dir, 'fps', fps, ...
    'gratingFunc', gratingFunc));

ys = 0.5 + 0.5 * grating * contrast;

frames = size(grating, 1);

backPattern = reshape(ys', [1 sW frames]);

runCamoPattern(struct('backPattern', backPattern, 'tileMode', 0, ...
    'escapeEnabled', escapeEnabled, 'duration', duration));


end
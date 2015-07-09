function ys = genGrating(args)

% parameters

W = 1600;

fps = 60;

duration = 5; % seconds

spatialFreq = 0.01; % cppx

temporalFreq = 8; % Hz

dir = 1; % direction

if nargin>0
    
    unpackStruct(args);
    
end

%% body

frames = duration * fps;

pxv = 1:W;

tv = (1:frames)/fps;

[px, t] = meshgrid(pxv, tv);

ys = cos(2*pi*(px*spatialFreq + t*temporalFreq*dir));

end
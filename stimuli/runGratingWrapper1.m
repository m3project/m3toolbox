function [dump] = runGratingWrapper1(expt)

d = 7; % distance to monitor (cm)

W = 1920;

Wcm = 48;

sf = W/Wcm; % monitor scaling factor (px/cm)

spatialFreq_cyc_deg = 0.042; % spatial frequency (cyc/deg)

if nargin>0
    
    unpackStruct(expt);         % load overridden parameter values
    
end

spatialPeriod_deg_cyc = 1/spatialFreq_cyc_deg; % deg/cyc

spatialPeriod_cm = 2 * d * tand(spatialPeriod_deg_cyc / 2);

spatialPeriod_px = sf * spatialPeriod_cm;

%expt.spatialFreq = 1/spatialPeriod_px;

factor2 = 1/ ( 2 * atand(Wcm/2/d));

expt.spatialFreq = (spatialFreq_cyc_deg / factor2) / 1920;

expt.temporalFreq = 8;

dump = runGrating(expt);

end
function testRunCamo

% generate patterns

Fx = 0.05; % cycle/px

Sigx = 0.01; % cycle/px

backPattern = gen3DPattern(struct('Fx', Fx, 'Sigx', Sigx));

bugPattern = gen2DPattern(struct('Fx', Fx, 'Sigx', Sigx, 'W', 100, 'H', 30));

%% adjust luminance levels

baseLum = 0.5;

contrast = 1;

[minLum, maxLum] = calLumLevels(baseLum, contrast);

backPattern = scaleLumLevels(backPattern, minLum, maxLum);

avgBackContrast = getAverageContrast(backPattern);

[minLum, maxLum] = calLumLevels(baseLum, avgBackContrast);

bugPattern = scaleLumLevels(bugPattern, minLum, maxLum);

%% render

expt = struct('backPattern', backPattern, 'bugPattern', bugPattern);

runCamo(expt);

end

function avgContrast = getAverageContrast(backPattern)

n = size(backPattern, 3);

contrasts = nan(n, 1);

for i=1:n
    
    k = backPattern(:, :, i);
    
    contrasts(i, 1) = range(k(:));
    
end

avgContrast = mean(contrasts);

end
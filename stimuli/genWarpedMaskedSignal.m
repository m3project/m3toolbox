function ys = genWarpedMaskedSignal(args)

% parameters

rms = 0.1;

signalFreq = 0.2; % cpd

signalAmp = 0.4; % signal amplitude

freqRange = 0.04 * [1/2 2]; % cpd

temporalFreq = 8; % Hz

deg = linspace(-150, 150, 1e4);

viewD = 7; % viewing distance in cm

screenReso = 40; % monitor resolution (px/cm)

dir = power(-1, rand>0.5);

makePlot = 1;

fps = 60;

duration = 5; % seconds

doChecks = 0;

[scrWidthPx, ~] = getResolution();

if nargin>0
    
    unpackStruct(args);
    
end

%% body

ts = 0:1/fps:duration; % time vector

degs = px2deg(scrWidthPx, screenReso, viewD);

n = length(degs);

m = length(ts);

ys = nan(m, n);

for i=1:m
    
    t = ts(i);
    
    signal = sin(2*pi*(signalFreq*degs + temporalFreq * t * dir)) * signalAmp;
    
    noise = genNoise(degs, freqRange(1), freqRange(2), rms);
    
    y = signal + noise;
    
    ys(i, :) = y;
    
    if makePlot
        
        subplot(3, 1, 1);
        
        plot(degs, y);
        
        hold on;
        
        plot([-1 1]*1e5, [1 1], '-r');
        
        plot([-1 1]*1e5, [-1 -1], '-r');
        
        hold off;
        
        xlabel('deg');
        
        ylim([-1 1]*1.2);
        
        xlim([-1 1]*max(degs));
        
        grid on;
        
        subplot(3, 1, 2);
        
        px = -scrWidthPx/2:scrWidthPx/2;
        
        imagesc(px, 1, y, [-1 1]); colormap(gray); axis tight;
        
        xlabel('px');
        
        subplot(3, 1, 3);
        
        y2 = genNoise(deg, freqRange(1), freqRange(2), rms);
        
        [FT, freq] = jfft(deg, y2);
        
        if doChecks
            
            % some checks for energy and rms calculations
            
            disp('Noise energy and RMS checks:'); %#ok
            
            % first, total energy in space and frequency domains must be
            % equal according to Parseval's theorem
            
            energy_space = (sum(abs(y2).^2) * diff(deg(1:2)));
            
            energy_freq = (sum(abs(FT).^2) * diff(freq(1:2)));
            
            fprintf('Energy in space = %1.3f\n', energy_space);
            
            fprintf('Energy in freq  = %1.3f\n', energy_freq);
            
            % second, checks for rms calculations (the below must print out
            % equal numbers within numerical calculation accuracy)
            
            rms_2 = sqrt(energy_space / range(deg));
            
            fprintf('RMS (specified)      = %1.3f\n', rms);
            
            fprintf('RMS (from energy)    = %1.3f\n', rms_2);
            
            % third, convert the signal y2 (a contrast signal) into a
            % luminance signal and then use a special formula to calculate
            % contrast rms of a luminance signal
            
            lum = 0.5 + y2 * 0.5; % mean of 0.5, range is +/- 0.5
            
            rms_3 = std(lum) / mean(lum);
            
            fprintf('RMS (from luminance) = %1.3f\n', rms_3);
            
            return
            
        end
        
        plot(freq, abs(FT));
        
        xlim([-1 1]);
        
        hold on;
        
        plot([1 1] * signalFreq, [0 10], 'r');
        
        plot([1 1] * -signalFreq, [0 10], 'r');
        
        ylim([0 5]);
        
        xlabel('freq (cpd)');
        
        grid on;
        
        hold off
        
        drawnow        
        
        KbName('UnifyKeyNames');
        
        [~, ~, keyCode ] = KbCheck;
        
        if keyCode(KbName('Escape'))
            
            return
            
        end
        
    end
    
end

end

function y = genNoise(deg, freq1, freq2, rms)

df = 1/range(deg);

freqs = freq1:df:freq2;

phasesSpatial = 2*pi*rand(size(freqs));

y = deg * 0;

for i=1:length(freqs)
    
    y = y + sin(2*pi*deg*freqs(i) + phasesSpatial(i));
    
end

% scale signal according to desired rms value

currentRms = sqrt(trapz(deg, y.^2)/range(deg));

y = y * rms / currentRms;

end

% function rms = getRMS(spectrum)
% 
% deg = spectrum.deg;
% 
% y = genNoise(spectrum, deg);
% 
% rms = sqrt(trapz(deg, y.^2)/range(deg));
% 
% end

% function rmsC = getRMSc(spectrum)
%
% rmsC = std(y)/mean(y); % use this for RMS contrast (not RMS luminance)
%
% end

% function spectrum = setRMS(spectrum, rms)
%
% currentRMS = getRMS(spectrum);
%
% spectrum.a = spectrum.a * rms / currentRMS;
%
% end
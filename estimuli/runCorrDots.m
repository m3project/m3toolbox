function runCorrDots()

%% Initialization

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[W, H] = getResolution();

%% variables

disparity = 5;

npoints = 100;

radius = 500;

boundaryAlpha = 0;

dotRadius = 20;

corr = 0; % -1 = fully anti-correlated, 0 = uncorrelated, 1 = fully correlated

%% plots

fbox = createFlickerBox(150, 150);

fbox.period = 1;

fbox.pattern = 0.5 + 0.5 * tan((1:100)/100*2*pi);

while 1
    
    dotDistance = 0.5 + rand(npoints, 1) * radius;
    
    dotAngle = rand(npoints, 1) * 2 * pi;
    
    colV = randi(2, [npoints 1])-1; % color vector
    
    for channel = [0 1]
        
        s = power(-1, channel); % disparity sign
        
        sdisp = s * disparity;
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        rect = [1 0 1 0] * W/2 + [0 1 0 1] * H/2 ...
            + [-1 -1 1 1] * radius + [1 0 1 0] * sdisp/2;
        
        Screen('FillOval', window, [0 0 0 boundaryAlpha], rect);
        
        dotX = W/2 + sdisp/2 + dotDistance .* cos(dotAngle);
        
        dotY = H/2 + dotDistance .* sin(dotAngle);
        
        rects = [dotX dotY dotX dotY] + ones(npoints, 1) * [-1 -1 1 1] * dotRadius;
        
        if channel==1
            
            xcorr = (corr+1)/2;
            
            k = 1:npoints*(1-xcorr);
            
            colV(k, :) = 1 - colV(k, :);
            
        end
        
        colMat = colV * [1 1 1];
        
        Screen('FillOval', window, colMat', rects');
        
        fbox = drawFlickerBox(window, fbox, channel);
        
    end
    
    Screen(window, 'Flip');
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if (keyCode(KbName('Escape')))
        
        break;
        
    end
    
end

end
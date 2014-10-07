function exitCode = runPol_3D(As)
%% Initialization

if nargin < 1

%     As = [1 0.5 0.25 0.5 1];
    
    error('Please specify brightness values');

end

KbName('UnifyKeyNames');

closeWindow();

Gamma = 2; % for Ronny's 3D monitor (AOC D2367PH)

createWindow3D(Gamma);

preview = 0;

boxPosition = [100 100]; % left and top coordinates

boxSize = [150 150]; % width and height

[sW, sH] = getResolution();

rect = [boxPosition boxPosition+boxSize];

As = [0 As 0]; % make last element by default black

%% parameters

tOn = 0.5;

tOff = 1;

T = tOn + tOff;

channel = 0; % 0 or 1

%% functions 0

b = @(t) (t>0) & (t<tOn);

b = @(t) double(b(t));

%% functions

if preview
    
    figure(gcf);
    
    t = 0:1e-3:20;
    
    b = @(t) b(mod(t, T));
    
    plot(t, b(t));
    
    xlabel('Time (sec)'); ylabel('Brightness');
    
    return

end

%% loop variables

flickSize = 50;

flickerRect = [0 sH-flickSize flickSize sH];

%% rendering loop:

window = getWindow();

startTime = GetSecs();

k = length(As);

while 1
    
    tnow = GetSecs();
    
    [~, ~, keyCode] = KbCheck;
    
    if keyCode(KbName('Escape'))
        
        exitCode = 0;
        
        break;
        
    end
    
    if keyCode(KbName('END'))
        
        exitCode = 1;
        
        break;
        
    end
    
    if keyCode(KbName('Space'))
        
        startTime = tnow;
        
        k = 1;
        
    end
    
    if keyCode(KbName('b')) && channel == 0
        
        channel = 1;
        
        disp('switched to blue channel');
        
    end
    
    if keyCode(KbName('g')) && channel == 1
        
        channel = 0;
        
        disp('switched to green channel');
        
    end
    
    t = tnow - startTime;
    
    if t>T
        
        startTime = tnow;
        
        if k<length(As)
            
            k = k + 1;
            
        end
        
    end

    flicker = t<tOn && k<length(As) && k>1;
    
    Screen('SelectStereoDrawBuffer', window, 1 - channel);
    
    Screen(window, 'FillRect', [1 1 1] * 0, []);
    
    Screen(window, 'FillRect', [1 1 1] * 0, rect);
    
    Screen('FillRect', window, [1 1 1] * 0, flickerRect);
    
    Screen('SelectStereoDrawBuffer', window, channel);
    
    Screen(window, 'FillRect', [1 1 1] * 0, []);
    
    Screen(window, 'FillRect', [1 1 1] * b(t) * As(k) * 255, rect);
    
    Screen('FillRect', window, [1 1 1] * flicker, flickerRect);
    
    Screen(window, 'Flip');
    
end

closeWindow();

end

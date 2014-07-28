function dump = runColors(expt)
%% Initialization

KbName('UnifyKeyNames');

createWindow3DAnaglyph();

preview = 0;

%% parameters

tOn = 5;

tOff = 1;

freq = 10; % hz

channel = 1; % 0 or 1

%% functions

T = tOn + tOff;

sin2 = @(x) (1+ sin(x))/2;

b0 = @(t) sin(2*pi*min(t/tOn/2, 0.5)) .* sin2(2*pi*t*freq);

b = @(t) b0(mod(t, T));

if preview
    
    figure(gcf);
    
    t = 0:1e-3:20;
    
    plot(t, b(t));
    
    xlabel('Time (sec)'); ylabel('Brightness');
    
    return

end

%% rendering loop:

window = getWindow();

startTime = GetSecs();

while 1
    
    t = GetSecs() - startTime();
    
    Screen('SelectStereoDrawBuffer', window, 1 - channel);
    
    Screen(window, 'FillRect', [1 1 1] * 0, []);
    
    Screen('SelectStereoDrawBuffer', window, channel);
    
    Screen(window, 'FillRect', [1 1 1] * b(t), []);
    
    Screen('Flip', window);    
    
   
end


end

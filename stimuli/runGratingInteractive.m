function runGratingInteractive()

% parameters

sf1 = 0.8; % cpd

sf2 = 0.0; % cpd

% sf2 = 0;

tf = 8; % Hz

deltaPhase = 0.5;

viewD = 100; % viewing distance in cm

screenReso = 40; % monitor resolution (px/cm)

dir = (-1) ^ (rand>0.5)

escapeEnabled = 1;

A1 = 1;

A2 = 1;

%% calculations

[sW, sH] = getResolution();

degs = px2deg(sW, screenReso, viewD);

%% body

KbName('UnifyKeyNames')

% window = getWindow();
% 
% if isempty(window)
    
    Gamma = 2.0;  % this is for the CSF (hp p1130 monitor) - I measured this with Diana on the 17nd of Nov 2015
    
% createWindow(Gamma);
    
    window = getWindow();

% end

fps = getFrameRate();

t = 0;

% degs = degs + 35;

while 1
    
    sig1 = A1 * sin(2*pi*(degs*sf1 - dir * t*tf));
    
    sig2 = A2 * sin(2*pi*(degs*sf2 - dir * t*tf + deltaPhase));
    
    sig = (sig1 + sig2)/2;
    
    xLum = 255 * (0.5 + sig * 0.5);
    
    tex = Screen(window, 'MakeTexture', xLum);
    
    plot(sig); 
    
    ylim([-2 2]);
    
    drawnow
    
    
    
    Screen(window, 'DrawTexture', tex, [], [0 0 sW sH]);    
    
    Screen(window, 'Flip');
    
    Screen('close', tex);
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
%     if (keyCode(KbName('PageUp')))
        
        t = t + 1/fps;
        
%     end
    
    if (keyCode(KbName('PageDown')))
        
        t = t - 1/fps;
        
    end
    
    if (keyCode(KbName('Escape'))) && escapeEnabled
        
        break;
        
    end
    
end

end
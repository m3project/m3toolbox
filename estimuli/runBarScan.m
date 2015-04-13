function exitCode = runBarScan(varargin)
%% Initialization

exitCode = 0;

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[sW, sH] = getResolution();

%% print keyboard shortcuts

shortcuts = {
    'Left Arrow',               'Scan from left', ...
    'Right Arrow',             'Scan from right', ...
    'g',                'Switch to green channel', ...
    'b',                'Switch to blue channel', ...
    'Escape',           'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% parameters

barHeight = 160; % px

barWidth = 10; % px

speed = 5; % px/sec

%% code

channel = 0;

fbox = createFlickerBox(100,70);

fbox.pattern = [0 1] * 255;

% fbox.simulate = 1;

scrReso = 40;

topMargin = 7 * scrReso;

bottomMargin = 10 * scrReso;

yrange = topMargin:barHeight:sH-bottomMargin;

xrange = 0:speed:sW;

for j=0:1
    
    Screen('SelectStereoDrawBuffer', window, j);
    
    Screen('FillRect', window, [1 1 1] * 255);
    
end

Screen(window, 'flip');

ys = [];

xs = [];

channel = 0;

while 1
    
    [~, ~, keyCode ] = KbCheck;
    
    if keyCode(KbName('Escape'))
        
        exitCode = 0;
        
        break;
        
    end
    
    if keyCode(KbName('END'))
        
        exitCode = 1;
        
        break;
        
    end
    
    numsPressed = intersect(find(keyCode), ('1':'9') + 0);
    
    if keyCode(KbName('Alt'))
        
        if isempty(numsPressed)
            
            % allows continuous holding down of Ctrl
            % by resetting the isKeyDown flag
            
            keyIsDown = 0;
            
        else
            
            exitCode = 100 + min(numsPressed) - '0'; % special exit code to switch stimuli
            
            return;
            
        end
        
    end
    
    if (keyCode(KbName('b')))
        
        channel = 0;
        
        p = 0.5 + 0.5 * sin((0:0.025:0.5)*2*pi);
        
        fbox = drawDiodePattern(window, fbox, p);
        
    end
    
    if (keyCode(KbName('g')))
        
        channel = 1;
        
        p = 0.5 - 0.5 * sin((0:0.025:0.5)*2*pi);
        
        fbox = drawDiodePattern(window, fbox, p);
        
    end
    
    if (keyCode(KbName('RightArrow')))
        
        ys = yrange;
        
        xs = xrange;
        
    end
    
    if (keyCode(KbName('LeftArrow')))
        
        ys = yrange;
        
        xs = xrange(end:-1:1);
        
        fbox = drawDiodePattern(window, fbox, [ones(1, 2) ones(1, 4)*0.25 zeros(1, 10)]);
        
    end
    
    % rendering
    
    ind1 = 0;
    
    for y=ys
        
        ind1 = ind1 + 1;
        
        levels = [0.05 0.1 0.2 0.5 1];
        
        fbox.pattern = [0 1] *  levels(ind1);
        
        for x=xs
            
            rect = [x y x+barWidth y+barHeight];
            
            for j=0:1
                
                Screen('SelectStereoDrawBuffer', window, j);
                
                Screen('FillRect', window, [1 1 1] * 255);
                
                drawFlickerBox(window, fbox);
                
            end
            
            Screen('SelectStereoDrawBuffer', window, channel);
            
            Screen('FillRect', window, [1 1 1] * 0, rect);
            
            fbox = drawFlickerBox(window, fbox);
            
            Screen(window, 'flip');
            
        end
        
    end
    
    ys = [];
    
    xs = [];
    
end

closeWindow();

end

function fbox = drawDiodePattern(window, fbox, pattern)

fbox.pattern = pattern;

fbox.internal.i = 0;

for i=1:length(fbox.pattern)
    
    fbox = drawFlickerBox(window, fbox);
    
    Screen(window, 'flip');
    
end

end
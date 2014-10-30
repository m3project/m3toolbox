function exitCode = runTargetwithMenuAnaglyph(logEvent, keyPress)

if nargin<1
    
    logEvent = @(str) str; % dummy function
    
end

if nargin<2
    
    keyPress = @(keyCode) 1; % dummy function
    
end

logEvent('runTargetwithMenuAnaglyph');

%% flicker brightness levels

FlickerBrightness_BlueOnly = 0.25;

FlickerBrightness_GreenOnly = 1;

FlickerBrightness_ZeroDisp = 0.12;

FlickerBrightness_MaxDisp = 0.05;

FlickerBrightness_MinDisp = 0.02;

%% Initialization

AssertOpenGL;

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

w = getWindow();

[sW, sH] = getResolution();

%sH = sH/2; % for 3D

moving = 0;

%% constants

disp_max = 20;

disp_min = -20;

showMenu = 0;

%% load random motion sequence from file

load('r1.mat'); % variable name is r1 (1e5 x 2 matrix)

ind = 1; % r1 indexer

%% Menu

menu.table = {            
    'Disparity',        [disp_min 0 disp_max],     0,          '%d pixels';
    'Radius',           10:150,         50,        '%d pixels';
    'Background Color', 0:0.02:1,       1,          '%1.2f units';
    'Ovality',          0.1:0.1:1.5, 1, '%1.1f units';
    'Step Size',        0:1:15,         5,         '%d pixels';   
    'Channels',         {'Blue Only', 'Green Only', 'Both'}, 'Both', '%s';
    'B-BOX X Shift',    -200:200,       37,          '%d pixels';
    'B-BOX Y Shift',    -200:200,       0,          '%d pixels';
    'B-BOX Width',      5:5:sW,         100,        '%d pixels';
    'B-BOX Height',     5:5:sH,         50,        '%d pixels';
    'B-BOX Visible',    {'No', 'Yes'},  'No',      '%s';
    'Flicker Color (!)',    0:0.1:1, 1, '%1.2f units';
    };

menu = drawMenu(menu);

menu.visible = showMenu;

%% Stimulus Settings

x0 = 0.5 * sW; % bug x position

y0 = 0.5 * sH; % bug y position

x = x0;

y = y0;

bX = sW/2; % bounding box x position

bY = sH/2; % bounding box y position

%% print keyboard shortcuts

shortcuts = {
    'p',                        'Set disparity to positive', ... 
    'n',                        'Set disparity to negative', ... 
    '0',                        'Set disparity to zero', ... 
    'k',                        'enable both channels', ... 
    'b',                        'enable blue channel only', ... 
    'g',                        'enable green channel only', ... 
    'Space',                    'Start/stop bug motion', ...
    'Escape or End',            'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% Drawing loop

flickSize = 100;

flickerRect = [0 sH-flickSize/2 flickSize sH];

flicker = 0;

map1 = java.util.Hashtable;
map1.put('Blue Only', 1);
map1.put('Green Only', -1);
map1.put('Both', 0);

old_fc = -1;

frameTimes = nan(500, 1);

frameCounter = 1;

oldKeyIsDown = 1;

while 1
    
    frameStart = GetSecs();
    
    r = menu.get('Radius');
    
    backColor = menu.get('Background Color');
    
    stepSize = menu.get('Step Size');
    
    d = menu.get('Disparity');
    
    bXS = menu.get('B-BOX X Shift');
    
    bYS = menu.get('B-BOX Y Shift');
    
    bW = menu.get('B-BOX Width');
    
    bH = menu.get('B-BOX Height');
    
    o = menu.get('Ovality');
    
    %fc = menu.get('Flicker Color');
    
    % selecting fc to encode parameters
    
    channels = menu.get('Channels');
    
    if strcmp(channels, 'Blue Only')
        
        fc = FlickerBrightness_BlueOnly;
        
    elseif strcmp(channels, 'Green Only')
        
        fc = FlickerBrightness_GreenOnly;
        
    else
        
        if d == 0
            
            fc = FlickerBrightness_ZeroDisp;
            
        elseif d == disp_max
            
            fc = FlickerBrightness_MaxDisp;
            
        elseif d == disp_min
            
            fc = FlickerBrightness_MinDisp;
            
        else
            
            error('incorrect encoding')
            
        end
        
    end
    
    if ~isequal(fc, old_fc)
        
        menu.table{12, 3} = fc;
        
        old_fc = fc;
        
    end
    
    %
    
    bVisible = strcmp(menu.get('B-BOX Visible'), 'Yes');
    
    sel_channel = map1.get(menu.get('Channels'));
    
    boundBox = [bX bY bX bY] + [-bW -bH +bW +bH]/2 + [bXS bYS bXS bYS];
    
    rect0 = [x y; x y] + [-1 -1; 1 1] .* [o 1; o 1] * r/2;
    
    rect1 = rect0 + [1 0; 1 0] * d/2;
    
    rect2 = rect0 - [1 0; 1 0] * d/2;
    
    Screen('SelectStereoDrawBuffer', w, 1);
    
    Screen('FillRect', w, backColor);
    
    menu = drawMenu(menu);
    
    if bVisible
        
        Screen('FrameRect', w, [0 0 0], boundBox);
        
    end
    
    Screen('FillRect', w, [1 1 1] * (1-flicker&moving)*fc, flickerRect);
    
    if ismember(sel_channel, [-1 0])
        
        Screen('FillOval', w, 0, rect1');
        
    end
    
    Screen('SelectStereoDrawBuffer', w, 0);
    
    Screen('FillRect', w, backColor);
    
    menu = drawMenu(menu);
    
    if bVisible
        
        Screen('FrameRect', w, [0 0 0], boundBox);
        
    end
    
    Screen('FillRect', w, [1 1 1] * (1-flicker&&moving)*fc, flickerRect);
    
    if ismember(sel_channel, [+1 0])
        
        Screen('FillOval', w, 0, rect2');
        
    end
    
    %menu = drawMenu(menu);
    
    Screen('DrawingFinished', w);   
    
    Screen('Flip', w);
    
    flicker = 1 - flicker;
    
    if moving
        
        x = x + power(-1, r1(ind, 1)) * stepSize;

        y = y + power(-1, r1(ind, 2)) * stepSize;
        
        ind = ind + 1;

        x = max(x, boundBox(1));

        y = max(y, boundBox(2));

        x = min(x, boundBox(3));

        y = min(y, boundBox(4));
    
    end
    
    [keyIsDown, ~, keyCode] = KbCheck;
    
    if keyIsDown && ~oldKeyIsDown
        
        keyPress(keyCode);
        
        if keyCode(KbName('ESCAPE'))
            
          exitCode = 0;
            
          break;
          
        end
        
        if keyCode(KbName('END'))
            
            exitCode = 1;
            
            break;
            
        end
        
        if keyCode(KbName('SPACE'))
            
            moving = 1 - moving;
            
            ind = 1;
            
            x = x0;

            y = y0;
            
            if moving
                
                logEvent('started moving');
                
            else
                
                logEvent('stopped moving');
                
            end
            
        end
        
        if keyCode(KbName('p'))
            
            menu.table{1, 3} = disp_max;
            
            logEvent('set disparity to positive');
            
        end
        
        if keyCode(KbName('n'))
            
            menu.table{1, 3} = disp_min;
            
            logEvent('set disparity to negative');
            
        end
        
        if keyCode(KbName('b'))
            
            menu.table{6, 3} = 'Blue Only';
            
            logEvent('enabled blue channel only');
            
        end
        
        if keyCode(KbName('g'))
            
            menu.table{6, 3} = 'Green Only';
            
            logEvent('enabled green channel only');
            
        end     
        
        if keyCode(KbName('k'))
            
            menu.table{6, 3} = 'Both';
            
            logEvent('enabled both channels');
            
        end          
        
        if keyCode('0')
            
            menu.table{1, 3} = 0;
            
            logEvent('set disparity to 0');
            
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

        menu.updateget = 1;
        
        menu = drawMenu(menu);
        
    end
    
    oldKeyIsDown = keyIsDown;
    
    frameEnd = GetSecs();
    
    frameDuration = frameEnd - frameStart;
    
    frameTimes(frameCounter) = frameDuration;

    frameCounter = mod(frameCounter, 500)+1   ;
    
end

%hist(frameTimes);

ft = frameTimes(~isnan(frameTimes));

if any(ft-mean(ft)>1e-3)
    
    warning('Dropped frames detected!')
    
end

closeWindow();

end

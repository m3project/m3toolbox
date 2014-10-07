function exitCode = runTargetwithMenu
%% Initialization

AssertOpenGL;

KbName('UnifyKeyNames');

Gamma = 2; % for Ronny's 3D monitor (AOC D2367PH)

createWindow3D(Gamma);

w = getWindow();

[sW, sH] = getResolution();

sH = sH/2; % for 3D

moving = 0;

%% constants

disp_max = 10;

disp_min = -10;

%% Menu

menu.table = {            
    'Disparity',        [disp_min 0 disp_max],     0,          '%d pixels';
    'Radius',           10:150,         50,        '%d pixels';
    'Background Color', 0:0.02:1,       1,          '%1.2f units';
    'Ovality',          0.1:0.1:1.5, 1, '%1.1f units';
    'Step Size',        0:1:15,         5,         '%d pixels';   
    'Channels',         {'Left Only', 'Right Only', 'Both'}, 'Both', '%s';
    'B-BOX X Shift',    -200:200,       0,          '%d pixels';
    'B-BOX Y Shift',    -200:200,       -60,          '%d pixels';
    'B-BOX Width',      5:5:sW,         400,        '%d pixels';
    'B-BOX Height',     5:5:sH,         95,        '%d pixels';
    'B-BOX Visible',    {'No', 'Yes'},  'No',      '%s';
    'Flicker Color (!)',    0:0.1:1, 1, '%1.2f units';
    };

menu = drawMenu(menu);

menu.visible = 0;

%% Stimulus Settings

x = 0.5 * sW; % bug x position

y = 0.5 * sH; % bug y position

bX = sW/2; % bounding box x position

bY = sH/2; % bounding box y position

%% Drawing loop

oldPressed = 0;

flickSize = 50;

flickerRect = [0 sH-flickSize/2 flickSize sH];

flicker = 0;

map1 = java.util.Hashtable;
map1.put('Left Only', -1);
map1.put('Right Only', 1);
map1.put('Both', 0);

old_fc = -1;

while 1
    
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
    
    if strcmp(channels, 'Left Only')
        
        fc = 0.9;
        
    elseif strcmp(channels, 'Right Only')
        
        fc = 0.7;
        
    else
        
        if d == 0
            
            fc = 0.5;
            
        elseif d == disp_max
            
            fc = 0.3;
            
        elseif d == disp_min
            
            fc = 0.1;
            
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
    
    rect0 = [x y; x y] + [-1 -1/2; 1 1/2] .* [o 1; o 1] * r/2;
    
    rect1 = rect0 - [1 0; 1 0] * d/2;
    
    rect2 = rect0 + [1 0; 1 0] * d/2;
    
    Screen('SelectStereoDrawBuffer', w, 1);
    
    Screen('FillRect', w, backColor);
    
    if bVisible
        
        Screen('FrameRect', w, [0 0 0], boundBox);
        
    end
    
    Screen('FillRect', w, [1 1 1] * (1-flicker&moving)*fc, flickerRect);
    
    if ismember(sel_channel, [-1 0])
        
        Screen('FillOval', w, 0, rect1');
        
    end
    
    
    menu = drawMenu(menu);
    
    Screen('SelectStereoDrawBuffer', w, 0);
    
    Screen('FillRect', w, backColor);
    
    if bVisible
        
        Screen('FrameRect', w, [0 0 0], boundBox);
        
    end
    
    Screen('FillRect', w, [1 1 1] * (1-flicker&&moving)*fc, flickerRect);
    
    if ismember(sel_channel, [+1 0])
        
        Screen('FillOval', w, 0, rect2');
        
    end
    
    menu = drawMenu(menu);
    
    Screen('DrawingFinished', w);   
    
    Screen('Flip', w);
    
    flicker = 1 - flicker;
    
    if moving

        x = x + power(-1, randi(2)) * stepSize;

        y = y + power(-1, randi(2)) * stepSize;

        x = max(x, boundBox(1));

        y = max(y, boundBox(2));

        x = min(x, boundBox(3));

        y = min(y, boundBox(4));
    
    end
    
    [pressed, ~, keycode] = KbCheck;
    
    if pressed && ~oldPressed
        
        if keycode(KbName('ESCAPE'))
            
          exitCode = 0;
            
          break;
          
        end
        
        if keycode(KbName('END'))
            
            exitCode = 1;
            
            break;
            
        end
        
        if keycode(KbName('SPACE'))
            
            moving = 1 - moving;
            
        end
        
        if keycode(KbName('p'))
            
            menu.table{1, 3} = 10;
            
        end
        
        if keycode(KbName('n'))
            
            menu.table{1, 3} = -10;
            
        end
        
        if keycode(KbName('l'))
            
            menu.table{6, 3} = 'Left Only';
            
        end
        
        if keycode(KbName('r'))
            
            menu.table{6, 3} = 'Right Only';
            
        end     
        
        if keycode(KbName('b'))
            
            menu.table{6, 3} = 'Both';
            
        end          
        
        if keycode('0')
            
            menu.table{1, 3} = 0;
            
        end
        
        menu.updateget = 1;
        
        menu = drawMenu(menu);
        
    end
    
    oldPressed = pressed;
    
end
function exitCode = runGratingwithMenu()
%% options

patchSize = 100; % pixels

dstr = datestr(now,'yy-mm-dd-hhMM');

file = sprintf('runGratingwithMenu_log_%s.txt', dstr);

logFile = fullfile('V:\readlab\Ronny\', file);

logFlushPeriod = 60; % seconds

motionDuration = 5; % seconds

%% initialization

KbName('UnifyKeyNames'); 

Gamma = 2.127; % for DELL U2413

createWindow(Gamma);

window = getWindow();

[W, H] = getResolution();

%% menu

menu.table = {  
    
    'Spatial Period', 10:10:1000, 170, '%d px/cycle';
    
    'Motion', {'Off', 'On'}, 'Off', '%s';
    
    'Speed', 0:10:1500, 1200, '%d pixels/sec';
    
    'Direction', {'Left', 'Right'}, 'Right', '%s';
    
    'Orientation', {'Horitzontal', 'Vertical'}, 'Horitzontal', '%s';
    
    'Jitter', 0:1.8:36, 0, '%1.2f degrees';

    'Type', {'Sine', 'Square'}, 'Sine', '%s'
    
    };

menu = drawMenu(menu);

menu.visible = 0;

oldMenu = menu;

%% logging options

fid = 1; % default: output to command window
 
if exist('logFile', 'var')

    fid = fopen(logFile, 'A'); % open file in append mode

    if fid == -1

        error('Cannot open log file for writing');

    end

end

%% rendering stimulus

% parameters:

contrast = 1; % [0, 1]

% end of parameters

[id0, ~] = CreateProceduralSineGrating  (window, H, H, [0.5 0.5 0.5 0], [], 0.5); % [, radius=inf][, contrastPreMultiplicator=1])
[id1, ~] = CreateProceduralSquareGrating(window, H, H, [0.5 0.5 0.5 0], [], 0.5); % [, radius=inf][, contrastPreMultiplicator=1])

IDs = [id0 id1];

% creating workspace dump

startTime = GetSecs();

% luts

map1 = createMap({'Left', 'Right'}, {-1 1});

map2 = createMap({'Horitzontal', 'Vertical'}, {0 1});

map3 = createMap({'Square', 'Sine'}, {1 0});

map4 = createMap({'On', 'Off'}, {1 0});

map7 = createMap({1, 0}, {'On', 'Off'});

% patch luts

map5 = createMap({'Left', 'Right'}, {1 2});

map6 = createMap({'Horitzontal', 'Vertical'}, {1 2});

directionAmplitudes = [5, 10; 20, 100]; % brightness levels for directions

% flicker box

patchRect = [0 H-patchSize patchSize H];

patchState = 0;

% some loop vars

phase_offset = 0;

old_ndir = 1;

old_speed = 0;

phase = 0;

i = 0;

t = 0;

spaceKeyCoolDown = 0;

lastFlushTime = 0;

patchFreq = 1;

fprintf(fid, 'Stimulus runGratingwithMenu started at %s : \n\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS.FFF'));

while 1
    
    % print any changes in menu
    
    if ~isequal(menu.table, oldMenu.table)
        
        fprintf(fid, 'Change at %s : \n\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS.FFF'));
        
        printMenu(menu, oldMenu, fid);
        
        fprintf(fid, '\n');
        
        oldMenu = menu;
        
    end
    
    % flushing to file
    
    if (fid ~= 1) &&(t-lastFlushTime > logFlushPeriod)

        fclose(fid);
        
        fid = fopen(logFile, 'A'); % open file in append mode
        
        lastFlushTime = t;
        
        disp('flushing')

    end    
   
    % updating t and i
    
    t = GetSecs() - startTime;
    
    i = i + 1;

    % pulling params from menu
    
    spatialPeriod = menu.get('Spatial Period');
    
    spatialFreq = 1/spatialPeriod;
    
    speed = menu.get('Speed');
    
    jitter = menu.get('Jitter');
    
    dir = map1.get(menu.get('Direction'));
    
    orientation = map2.get(menu.get('Orientation'));
    
    Angle = orientation * 90;
    
    temporalFreq = speed * spatialFreq;
    
    gratingid = map3.get(menu.get('Type'));
    
    motionEna = map4.get(menu.get('Motion'));    
    
    % drawing patch
    
    ind1 = map5.get(menu.get('Direction'));
    
    ind2 = map6.get(menu.get('Orientation'));
    
    patchColor = directionAmplitudes(ind1, ind2);
    
    patchEna = motionEna;
    
    if mod(i, patchFreq) == 0
        
        patchState = 1 - patchState;
        
    end
    
    Screen('FillRect', window, [1 1 1] * patchState * patchColor * patchEna, patchRect);        
    
    % calculating phase
    
    nDir = dir * motionEna;
    
    new_phase = -nDir * t * 360 * temporalFreq + (jitter * -nDir * (rand(1)));
    
    if nDir ~= old_ndir || old_speed ~= speed
        
        % if a change in direction or speed is detected, must counteract
        % sudden phase shift by setting phase_offset appropriately
        
        phase_offset = phase - new_phase;
        
        old_ndir = nDir;
        
        old_speed = speed;
        
    end
    
    new_phase = new_phase + phase_offset;
    
    phase = new_phase;
    
    % drawing
    
    Screen('DrawTexture', window, IDs(gratingid+1), [], [W/2-H/2 0 W/2+H/2 H], Angle, [], [], [], [], [], [phase, spatialFreq, contrast, 0]);
    
    menu = drawMenu(menu);
    
    Screen(window, 'Flip');
    
    [~, ~, keyCode ] = KbCheck;
    
    if keyCode(KbName('SPACE')) && (t-spaceKeyCoolDown>0.25)
        
        newMotionEna = map7.get(1 - motionEna);
        
        menu = updateMenu(menu, 'Motion', newMotionEna);
        
        spaceKeyCoolDown = t;
        
    end
    
    if t-spaceKeyCoolDown>motionDuration
        
        newMotionEna = map7.get(0);
        
        menu = updateMenu(menu, 'Motion', newMotionEna);
        
        spaceKeyCoolDown = t;
        
    end
    
    if keyCode(KbName('8'))
        
        menu = updateMenu(menu, 'Orientation', 'Vertical');
        
        menu = updateMenu(menu, 'Direction', 'Left');
        
    end  
    
    if keyCode(KbName('2'))
        
        menu = updateMenu(menu, 'Orientation', 'Vertical');
        
        menu = updateMenu(menu, 'Direction', 'Right');
        
    end  
    
    if keyCode(KbName('4'))
        
        menu = updateMenu(menu, 'Orientation', 'Horitzontal');
        
        menu = updateMenu(menu, 'Direction', 'Left');
        
    end  
    
    if keyCode(KbName('6'))
        
        menu = updateMenu(menu, 'Orientation', 'Horitzontal');
        
        menu = updateMenu(menu, 'Direction', 'Right');
        
    end    
    
    if keyCode(KbName('Escape'))
        
        exitCode = 0;
        
        break;
        
    end
    
    if keyCode(KbName('END'))

        exitCode = 1;

        break;

    end
    
end

if fid ~= -1

    fclose(fid);
    
end
%closeWindow();

end
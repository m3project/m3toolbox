function menu = drawMenu(menu)

SelColor = 255; % 255 for 2D, 1 for 3D 

KbName('UnifyKeyNames');

holdThresold = 0.5; % seconds

if nargin < 1
    
    menu.table = {
        'Disparity',   1:10,       5,      '%d units';
        'Size',        1:40,       20,     '%d pixels';
        'Velocity',    1:0.1:40,   38,     '%1.1f cm/sec';
        'Bug Shape',   {'Fly', 'Stick', 'Beetle'}, 'Fly', '%s';
        'Menu Position', {'Bottom-left', 'Bottom-right', 'Top-right', 'Top-left', 'Center'}, 'Top-left', '%s';
        };
    
end

if ~isfield(menu, 'initialized')
    
    menu = initMenu(menu);
    
end

% checking for key presses

[~, ~, keyCode ] = KbCheck;

if any(keyCode)
    
    if isempty(menu.holdStartTime)
        
        menu.holdStartTime = GetSecs();
        
    end
    
else
    
    menu.holdStartTime = [];
    
end

if ~isfield(menu, 'oldKeyCode')
    
    menu.oldKeyCode = zeros(size(keyCode));
    
end

isDown = @(key) keyCode(KbName(key));

isJustPressed = @(key) keyCode(KbName(key)) && ~menu.oldKeyCode(KbName(key));

isHold = ~isempty(menu.holdStartTime) && (GetSecs() - menu.holdStartTime > holdThresold);

if isJustPressed('m')
    
    menu.visible = 1 - menu.visible;
    
end

if isJustPressed('DownArrow')
    
    menu.selected = min(menu.selected+1, length(menu.table));
    
end

if isJustPressed('UpArrow')
    
    menu.selected = max(menu.selected-1, 1);
    
end

direction = 0;

if menu.visible
    
    if ~isHold && isJustPressed('RightArrow')
        
        direction = 1;
        
    end
    
    if isHold && isDown('RightArrow')
        
        direction = 1;
        
    end
    
    if ~isHold && isJustPressed('LeftArrow')
        
        direction = -1;
        
    end
    
    if isHold && isDown('LeftArrow')
        
        direction = -1;
        
    end
    
    if isJustPressed('Home')
        
        direction = -inf;
        
    end
    
    if isJustPressed('End')
        
        direction = +inf;
        
    end
    
end

selptype = isnumeric(menu.table{menu.selected, 2});

if direction
    
    vals = menu.table{menu.selected, 2};
    
    selVal = menu.table{menu.selected, 3};
    
    if selptype
        
        k = find(selVal == vals);
        
    else
        
        k = find(strcmp(selVal, vals));
        
    end
    
    newK = k + direction;
    
    newK = max(newK, 1);
    
    newK = min(newK, length(vals));
    
    if isempty(k)
        
        error('the value of the parameter you just tried to change is not included in its value range');
        
    end
    
%     if newK>0 && newK<=length(vals)
        
        if selptype
            
            newV = vals(newK);
            
        else
            
            newV = vals{newK};
            
        end
        
        menu.table{menu.selected, 3} = newV;
        
%     end
    
end

menu.oldKeyCode = keyCode;

if isfield(menu, 'updateget')
    
    menu = rmfield(menu, 'updateget');
    
    menu = updateGetFunction(menu);
    
end

if ~menu.visible
    
    return
    
end

% initialization

w = getWindow();

Screen('TextFont', w, 'Arial');

Screen('TextSize', w, 14);

% drawing

yd = 30;

entries = size(menu.table, 1);

x1 = 250;

menu.W = x1 + 280;

menu.H = yd * (entries);

pad = 10;

frameRect = [0 0 menu.W menu.H] + [0 0 1 1]*2*pad;

menu = setPosition(menu, frameRect, 'Top-left');

menuRect = [menu.x menu.y menu.x menu.y] + frameRect;

Screen(w, 'FillRect' , [1 1 1] * 255, menuRect);

ysel = menu.y + (menu.selected-1) * yd + pad;

%selRect = [menu.x ysel menu.x+menu.W+2*pad ysel+yd*0.8];

%Screen(w, 'FillRect' , [0 0 0 0.1] * 1, selRect);

for i=1:entries
    
    col = [(i==menu.selected) 0 0] * SelColor ;
    
    pname = upper(menu.table{i, 1});
    
    pvals = menu.table{i, 2};
    
    pval = menu.table{i, 3};
    
    fstr = menu.table{i, 4};
    
    pstr = sprintf(fstr, pval);
    
    yi = menu.y + (i-1) * yd + pad;
    
    xi = menu.x + pad;
    
    Screen(w, 'DrawText', pname, xi, yi, col);
    
    Screen(w, 'DrawText', ':', xi + x1 - 20, yi);
    
    ptype = isnumeric(pvals);
    
    if ptype
        
        progress = (pval - min(pvals)) / (max(pvals) - min(pvals));
        
        drawProgressBar(w, xi + x1, yi, 150, progress, col);
        
        Screen(w, 'DrawText', pstr, xi + x1 + 150 + 15, yi);
        
    else
        
        Screen(w, 'DrawText', upper(pstr), xi + x1, yi);
        
    end
    
end

menu = updateGetFunction(menu);

end

function drawProgressBar(w, x, y, width, progress, col)

% progress is in [0, 1]

h = 40;

Screen(w, 'FrameRect', col, [x y x+width y+h/2], 4);

Screen(w, 'FillRect', col, [x y x+width*progress y+h/2], 4);

end

function menu = initMenu(menu)

menu.initialized = 1;

menu.visible = 1;

menu.selected = 1;

menu.holdStartTime = [];

menu = updateGetFunction(menu);

end

function menu = updateGetFunction(menu)

map = java.util.Hashtable;

for i=1:size(menu.table, 1)
    
    map.put(menu.table{i, 1}, menu.table{i, 3});
    
end

menu.get = @(key) map.get(key);

end

function menu = setPosition(menu, frameRect, position)

[sW, sH] = getResolution();

frameW = frameRect(3) - frameRect(1);

frameH = frameRect(4) - frameRect(2);

margin = 20;

table1 = java.util.Hashtable;

table1.put('Bottom-right', [sW - frameW - margin, sH - frameH - margin]);

table1.put('Bottom-left', [margin, sH - frameH - margin]);

table1.put('Top-left', [margin, margin]);

table1.put('Top-right', [sW - frameW - margin, margin]);

table1.put('Center', [(sW-frameW)/2, (sH-frameH)/2]);

xy = table1.get(position);

menu.x = xy(1);

menu.y = xy(2);

end
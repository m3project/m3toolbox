function testAnaglyph

Gamma = 2.127; % for DELL U2413

LeftGains = [0 0.66 0];

% LeftGains = [1 0 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

Screen(window, 'TextFont', 'Arial');

Screen(window, 'TextSize', 24);

[sW, sH] = getResolution();

d = 250;

for lum = [0 1]
    
    for channel = [0 1]
        
        pos = [sW sH]/2 + [d 0] * power(-1, 1-channel) + [0 -200] + [0 400] * lum;
        
        Screen('SelectStereoDrawBuffer', window, channel);
        
        Screen(window, 'DrawDots', pos, 60, [1 1 1]*255 * lum, [], 1);
        
        str = sprintf('Channel %i (lum = %d)', channel, lum);
        
        Screen('DrawText', window, str, pos(1) - 120, pos(2) - 100, [1 1 1] * lum); % [,x] [,y] [,color] [,backgroundColor] [,yPositionIsBaseline] [,swapTextDirection]);
        
    end
    
end

Screen(window, 'flip');

end
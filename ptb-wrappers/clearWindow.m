function clearWindow(color, stereo)

if nargin < 1
    
    color = [0 0 0];
    
end

if nargin < 2
    
    stereo = 0;
    
end

w = getWindow();

[sW, sH] = getResolution();

if stereo
    
    for channel = [0 1]
        
        Screen('SelectStereoDrawBuffer', w, channel);
        
        Screen(w, 'FillRect' , color, [0 0 sW sH] );        
        
    end
    
    Screen(w, 'Flip');
    
else
    
    Screen(w, 'FillRect' , color, [0 0 sW sH] );
    
    Screen(w, 'Flip');
    
end

end
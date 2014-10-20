function stepWindow()

w = getWindow();

[sW, sH] = getResolution();

for b = 0:0.1:1

    clc
    
    b
    
    Screen('SelectStereoDrawBuffer', w, 1);
    
    Screen(w, 'FillRect' , [1 1 1] * 1 * b*0, [0 0 sW sH] );
    
    Screen('SelectStereoDrawBuffer', w, 0);
    
    Screen(w, 'FillRect' , [1 1 1] * 1 * b , [0 0 sW sH] );
    
    Screen(w, 'Flip');
    
    pause
    
end

end
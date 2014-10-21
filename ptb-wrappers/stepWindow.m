function stepWindow()

createWindow(1);

w = getWindow();

for b = 0:0.1:1 

    clc
    
    b
    
%     Screen('SelectStereoDrawBuffer', w, 1);
    
%     Screen(w, 'FillRect' , [1 1 1] * 1 * b*0, [] );
    
%     Screen('SelectStereoDrawBuffer', w, 0);
    
    Screen(w, 'FillRect' , [1 1 1] * 255 * b , [] );
    
    Screen(w, 'Flip');
    
    pause
    
end

closeWindow();

end
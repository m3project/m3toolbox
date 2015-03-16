% drawFlickerBox
%
% draws a patch on the bottom left corner of a PTB window. The patch
% luminance changes according to a specified pattern.
%
% when noadvance is set to 1, the current rendering does not advance the
% counter i to the next frame. This is useful when the patch needs to be
% drawn in multiple channels (in which case only the last drawing
% operations should advance the frame counter)
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/03/2015

function fbox = drawFlickerBox(window, fbox, advanceFrame)

if nargin<3
    
    advanceFrame = 1;
    
end

b = fbox.pattern(fbox.internal.i + 1);

if fbox.visible
 
    Screen('FillRect', window, [1 1 1] * b, fbox.internal.rect);
    
end

if advanceFrame
    
    fbox.internal.frames = mod(fbox.internal.frames + 1, fbox.period);
    
    if fbox.internal.frames==0
        
        fbox.internal.i = mod(fbox.internal.i + 1, length(fbox.pattern));
        
    end
    
end

end
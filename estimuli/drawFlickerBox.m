% drawFlickerBox
%
% draws a patch on the bottom left corner of a PTB window. The patch
% luminance changes according to a specified pattern.
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/03/2015

function fbox = drawFlickerBox(window, fbox)

b = fbox.pattern(fbox.internal.i + 1);

if fbox.visible
    
    Screen('FillRect', window, [1 1 1] * b, fbox.internal.rect);
    
end

if fbox.simulate
    
    fbox.internal.simtrace = [fbox.internal.simtrace(2:end); b];
    
    inds = ceil(0.5:0.5:length(fbox.internal.simtrace));
    
    plot(fbox.internal.simtrace(inds));
    
    grid on;
    
%     if max(fbox.internal.simtrace)>1
%         
%         ylim([0 255]);
%         
%     else
        
        ylim([0 1]);
    
%     end
    
    drawnow
    
end

fbox.internal.frames = mod(fbox.internal.frames + 1, fbox.period);

if fbox.internal.frames==0
    
    fbox.internal.i = mod(fbox.internal.i + 1, length(fbox.pattern));
    
end

end
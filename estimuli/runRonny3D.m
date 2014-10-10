function runRonny3D()

funcs = {@runTargetwithMenuAnaglyph, @runSwirlAnaglyph, @runDotsAnaglyph_ephys};

closeWindow();

while 1
    
    for i=1:length(funcs)
        
        clc
        
        exitCode = funcs{i}();
        
        closeWindow();
        
        if exitCode == 0
                   
            return;
            
        end
        
        pause(0.2);
        
    end
    
end

end
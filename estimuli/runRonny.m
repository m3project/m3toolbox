function runRonny()

funcs = {@runDiscLoom, @runGratingwithMenu, @runTargetwithMenu};

while 1
    
    for i=1:length(funcs)
        
        exitCode = funcs{i}();
        
        closeWindow();
        
        if exitCode == 0
                   
            return;
            
        end
        
        pause(0.2);
        
    end
    
end

end
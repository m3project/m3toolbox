function people()

file = fullfile(M3, 'in.use');

if exist(file, 'file')
    
    load(file, '-mat');
    
    disp('Signed-in users:')
    
    for i=1:length(users)
    
        disp(users(i))
    
    end
    
    return    
  
end

disp('Nobody is signed in.');

end
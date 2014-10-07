function people()

file = fullfile(getM3Path, 'in.use');


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
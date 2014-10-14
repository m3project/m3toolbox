function signin()

file = fullfile(M3, 'in.use');

[~, username] = system('whoami');

[~, host] = system('hostname');

username = strrep(username, char(10), '');

host = strrep(host, char(10), '');

newuser = sprintf('%s on %s', username, host);

if exist(file, 'file')
    
    load(file, '-mat');
    
    if any(strcmp(users, newuser))
        
        % user already checked out toolbox
        
        error('You are already signed in');
        
    else
        
        n = length(users);
        
        users{n+1} = newuser;
        
        
    end
    
else
    
    users{1} = newuser;
    
end

save(file, 'users', '-mat');

disp('Signed in successfully');

end
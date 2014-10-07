function signout()

file = fullfile(getM3Path, 'in.use');

[~, username] = system('whoami');

[~, host] = system('hostname');

username = strrep(username, char(10), '');

host = strrep(host, char(10), '');

newuser = sprintf('%s on %s', username, host);

if exist(file, 'file')
    
    load(file, '-mat');
    
    k = strcmp(users, newuser);
    
    if any(k)
        
        users = users(~k);
        
        if isempty(users)
            
            delete(file);
            
        else
            
            save(file, 'users', '-mat');
            
        end
        
        disp('Signed out successfully');
        
        return
        
    end
    
end

error('You are not signed in')


end
% fool-proof save (fpsave)
%
% fpsave performs the same function as save but will never halt execution
% due a failure (on either its part or the user's). In case something goes
% wrong (e.g. file cannot be written to) fpsave will attempt to improvise
% (e.g. by saving data somewhere else) so as to allow caller function to
% resume execution. If a catastrophic failure occurs and the caller
% function cannot be resumed, fpsave will pause execution (by calling the
% function keyboard) thus allowing the user to access caller function
% workspaces and manually export any important intermediary data/results
%
% fpsave's three laws:
%
% 1. fpsave must not cause loss of workspace data or overwrite existing files
% 2. fpsave must not interrupt execution except where this would conflict with (1)
% 3. fpsave must behave identical to save except where this would conflict with (1) or (2)
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 18/6/2015

function fpsave(varargin)

filePath = ''; varNames = '';

if nargin>0
    
    filePath = varargin{1};
    
end

if nargin>1
    
    varNames = sprintf(' %s ', varargin{2:end});
    
end

% attempt to call save in parent context and handle any issues

while 1
    
    try
        
        assert(~exist(filePath, 'file')); % throw exception if file exists
        
        cmd = sprintf('save ''%s'' %s', filePath, varNames);
        
        evalin('caller', cmd);
        
        break;
        
    catch err
        
        try % to catch errors within the catch block
            
            isErr = @(str) isequal(err.identifier, str);
            
            if isErr('MATLAB:assertion:failed')
                
                % assertion (filePath should not be an existing file) failed
                
                [pathstr, ~, ~] = fileparts(filePath);
                
                filePath = getNonExistingFileName(pathstr);
                
                continue; % retry save
                
            elseif isErr('MATLAB:save:varNotFound')
                
                % looks like user tried to save one or more non-existing
                % variables, try to get around this by saving the entire parent
                % workspace
                
                warning('variable(s) not found');
                
                varNames = '';
                
                continue; % retry save
                
            elseif isErr('MATLAB:save:noParentDir')
                
                % cannot save to this directory, try switching to the user's
                % home directory
                
                [pathstr, name, ext] = fileparts(filePath);
                
                if isequal(pathstr, getUserHomeFolder)
                    
                    % seems we've tried this already so we now know it doesn't
                    % work
                    
                    % do nothing and let execution proceed to keyboard
                    
                else
                    
                    warning('could not save to directory %s', pathstr);
                    
                    filePath = fullfile(getUserHomeFolder, strcat(name, ext));
                    
                    continue; % retry save
                    
                end
                
            elseif isErr('MATLAB:save:filenameIsADirectory')
                
                % supplied filename is a directory (user forgot to include
                % filename?)
                
                warning('filename not specified');
                
                filePath = getNonExistingFileName(filePath);
                
                continue; % retry save
                
            end
            
        catch err2
            
            % some error was caught within the exception handling code
            
            warning('internal error: %s', err2.message)
            
            % proceed to keyboard
            
        end
        
        % could not get around this error
        
        warning('catastrophic error, don''t know what to do')
        
        keyboard
        
    end
    
end

end

function filePath = getNonExistingFileName(parentDir)

prefix = 'fpsave';

datePart = datestr(now, 'yyyy-mm-dd-hhMM-ss.FFF');

fileName = sprintf('%s-%s', prefix, datePart);

filePath = fullfile(parentDir, strcat(fileName, '.mat'));

end

function homeFolder = getUserHomeFolder()

import java.lang.*;

homeFolder = char(System.getProperty('user.home'));

end
function waitDialog(duration)

if ~nargin; duration = 5; end

h = waitbar(0, 'Please wait...');

f1 = @(varargin) close(h);

obj1 = onCleanup(f1);

t0 = GetSecs();

t = 0;

while t < duration
    
    t = GetSecs() - t0;
    
%     msg = sprintf('Starting in %1.1f seconds ...', duration - t);

    waitbar(t / duration);
    
%     set(h, 'text', msg);
    
    drawnow
    
end

end
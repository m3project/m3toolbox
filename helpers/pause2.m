% pauses for `duration` seconds
%
% when an interrupt function `intfunc` is supplied, this function is
% evaluted on each iteration and pause2 is aborted when the function
% returns 1
%
% this function may be less accurate than the built-in pause but on top of
% supporting customized interruptions it is also context independent (as
% opposed to pause which can be disabled altogether using `pause off')
%
% returns 0 if the function terminated after the specified delay or 1 if it
% terminated due to an interruption
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/04/2015

function result = pause2(duration, intfunc)

if nargin<2
    
    intfunc = @() 0;
    
end

result = 0;

startTime = GetSecs();

while 1
   
    if GetSecs - startTime > duration
        
        break;
        
    end
    
    if intfunc()
        
        result = 1;
        
    end
    
end

end
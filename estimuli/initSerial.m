function obj = initSerial()

deallocOld(); % dealloc any old devices

obj = serial(getPortName());

set(obj, 'BaudRate', getBaudRate());

fopen(obj);

end

function port = getPortName()

pc = getenv('computername');

if isequal(pc, 'READLAB14')
    
    % workaround for testing on Ghaith's computer
    
    port = 'COM1';
    
    return
    
end    

port = 'COM6';

end

function rate = getBaudRate()

rate = 9600;

end

function deallocOld()

objs = instrfind('Port', getPortName());

arrayfun(@deallocSerial, objs);

end
function setupPool(workers)

if nargin == 0
    
    workers = getProcessorCount - 2;
    
end

currentPool = matlabpool('size');

if workers == currentPool
    
    warning('pool with same number of workers already opened, command ignored');
    
    return
    
elseif currentPool > 0
    
    warning('will close existing pool first');
    
    matlabpool('close');
    
end

myCluster = parcluster('local');

myCluster.NumWorkers = workers;

matlabpool(myCluster);

end
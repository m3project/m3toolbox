function setupPool(workers)

if nargin == 0
    
    workers = getProcessorCount - 2;
    
end

myCluster = parcluster('local');

myCluster.NumWorkers = workers;

matlabpool(myCluster);

end
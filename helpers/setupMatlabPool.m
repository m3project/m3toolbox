function setupMatlabPool(workers)

if nargin == 0
    
    workers = 8;
    
end

myCluster = parcluster('local');

myCluster.NumWorkers = workers;

matlabpool(myCluster);

end
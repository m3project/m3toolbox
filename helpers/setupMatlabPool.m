function setupMatlabPool

myCluster = parcluster('local');

myCluster.NumWorkers = 4;

matlabpool(myCluster);

end
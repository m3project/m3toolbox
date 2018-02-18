function paramSet = createRandTrialBlocks(n, varargin)

paramSet = [];

for i=1:n

    paramSet = [paramSet; createRandTrial(varargin{:})]; %#ok

end


end
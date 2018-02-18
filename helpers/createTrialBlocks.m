function paramSet = createTrialBlocks(n, varargin)

paramSet = [];

for i=1:n

    paramSet = [paramSet; createTrial(varargin{:})]; %#ok

end

end
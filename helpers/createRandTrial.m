function paramSet = createRandTrial(varargin)

paramSet = createTrial(varargin{:});

k = size(paramSet, 1);

r = randperm(k);

paramSet = paramSet(r, :);

end
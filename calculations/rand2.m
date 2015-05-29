% simple variation of rand, behaves identically to rand except that
% returned random numbers are in the range [-1, 1]

function y = rand2(varargin)

y = 2 * rand(varargin{:}) - 1;

end
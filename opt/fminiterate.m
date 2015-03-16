% a heuristic optimization  algorithm
%
% starts with a bound [lower, upper] that is assumed to contained
% a minimum of function fun. `points` points are evaluated and the minimum
% of these computed (min). The range [lower, upper] is then scaled by a
% factor of s (must be less than 1) and shifted such that (lower+upper)/2
% equals min. This process is repeated `iters` times.
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 14/1/2015

function [sol, fval] = fminiterate(fun, lower, upper, points, s, iters)

if nargin<4
    
    points = 10;
    
    s = 0.25;
    
    iters = 8;
    
end

if (s>=1)
    
    error('s must be less than 1');
    
end

if (points<2)
    
    error('minimum 2 points');
    
end

if (upper<=lower)
    
    error('upper must be larger than lower');
    
end

for i=1:iters
    
    range = upper - lower;
    
    step = range/(points-1);
    
    vals = lower:step:upper;
    
    y = fun(vals);
    
    [err, k] = min(y);
    
    range = range * s;
    
    lower = max(lower, vals(k) - range/2);
    
    upper = min(upper, vals(k) + range/2);
    
end

sol = vals(k);

fval = err;

end
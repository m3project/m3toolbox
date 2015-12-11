% fits a psychometric function using likelihood
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 28/7/2015

function [func, threshold, sigma] = fitPsychometric(contrast, m, n)

wrapper = @(params) psychometric(contrast, params(1), params(2));

optFunction = @(x) -getFitError(wrapper, x, n, m);

options = optimset('MaxFunEvals', 1e3, 'MaxIter', 1e3);

best = fminsearch(optFunction, [0.1 1], options);

% best = fmincon(optFunction, [0.5 0.5], [], [], [], [], [1e-3 0], [1e3 1e3], [], options);

threshold = best(1);

sigma = best(2);

func = @(contrast) psychometric(contrast, threshold, sigma);

end

function y = psychometric(contrast, threshold, sigma)

if threshold<0
    
    y = inf * ones(size(contrast));
    
%     error('negative threshold');
    
else
    
    y = 0.5 * (1+erf(log(contrast./threshold)/sqrt(2)/sigma));
    
end

end


function e = getFitError(func, params, n, m)

p = func(params);

tol = 1e-15;

k = (p<tol) + (p>1-tol);

k2 = 1-sign(k);

k3 = find(k2);

n = n(k3);
m = m(k3);
p = p(k3);

e = sum( m .* log(p) + (n-m) .* log(1-p) );

if sum( k ) > 0
    
    e = e - 1e2 * sum(k);
    
end

end
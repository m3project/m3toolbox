% this is a rework of fminiterate that optimizes for multiple variables
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 18/8/2015
%
% output:
%
% sol       : best point
% fval      : value of error function at best point
% initfval  : error function values for each iteration
% nevals    : number of points evaluated

function [sol, fval, initfval, nevals] = fminiterate_multi(fun, lower, upper, points, s, iters, lockedVals)

if nargin<4

    points = 10;
    
    s = 0.25;
    
    iters = 8;
    
end

if length(points) == 1
    
    k = ones(size(lower));
    
    points = points * k;
    
    s = s * k;
    
    iters = iters * k;
    
end    

if nargin<7
    
    lockedVals = [];
    
end

nevals = 0;

nLocked = length(lockedVals);

nVars = length(lower);

j = nLocked + 1;

ppoints = points(j);

ps = s(j);

piters = iters(j);

if (ps>=1)
    
    error('s must be less than 1');
    
end

if (ppoints<2)
    
    error('minimum 2 points');
    
end

if (upper<=lower)
    
    error('upper must be larger than lower');
    
end

L = lower(j);
U = upper(j);

initfval = nan(1, piters);

prevMinPointVal = inf;

for i=1:piters
    
    pp = linspace_quick(L, U, ppoints)';
    
    if isempty(lockedVals)
        
        V = [];
        
    else
    
        V = ones(ppoints, 1) * lockedVals;
    
    end
    
    % re-order for shallow evaluation heuristic
    
    mP = round(ppoints/2);
    
    cornerPoints = [1 mP  ppoints];
    
    newInds = [cornerPoints 2:mP-1 mP+1:ppoints-1];
    
    pp = pp(newInds, :);  
    
    vals = [V pp];  
    
    if nLocked < nVars - 1
        
        fun2 = @(x) inner_wrapper(fun, lower, upper, points, s, iters, ...
            lockedVals, x);
        
        [y, sols, noProgress2, subNEvals] = arrayfun2_lazy(fun2, pp);
        
    else
        
        [y, sols, noProgress2, subNEvals] = arrayfun3_lazy(fun, vals);       
    
    end
    
    nevals = nevals + subNEvals;
    
    [err, k] = min(y);
    
    noProgress = prevMinPointVal - err < 1e-4;
    
    prevMinPointVal = err;    
    
    if noProgress || noProgress2
        
        break;
        
    end
    
    initfval(i) = err;
        
    rang = (U - L) * ps;
    
    L = max(L, vals(k, j) - rang/2);
    
    U = min(U, vals(k, j) + rang/2);
    
end

sol = [vals(k, j) sols(k, :)];

fval = err;

end

function y = linspace_quick(a, b, points)

step = (b-a) / (points-1);

y = a:step:b;

end

function [err, sol, subNEvals] = inner_wrapper(fun, lower, upper, points, s, iters, lockedVals, LV)

lockedVals_new = [lockedVals LV];

[sol, err, ~, subNEvals] = fminiterate_multi(fun, lower, upper, points, s, iters, lockedVals_new);

end

function [y, sols, noProgress, nevals] = arrayfun2_lazy(fun, vals)

% this is a variation of arrayfun2 that aborts search
% when first three points have similar cost

tol = 1e-4; noProgress = 0;

n = size(vals, 1);

y = nan(n, 1);

nevals = 0;

for i=1:n
    
    [y(i), sols(i, :), subNEvals] = fun(vals(i, :)); %#ok
    
    nevals = nevals + subNEvals;
    
    if i == 3
        
        if range(y(1:3)) < tol
            
            y = ones(n, 1) * y(1);
            
            sols = repmat(sols(1, :), [n 1]);
            
            noProgress = 1;
            
            return;
            
        end
        
    end
    
end

end

function [y, sols, noProgress, subNEvals] = arrayfun3_lazy(fun, vals)

% this is a variation of arrayfun3 that aborts search
% when first three points have similar cost

tol = 1e-4; noProgress = 0;

n = size(vals, 1);

y = nan(n, 1);

sols = zeros(n, 0); % dummy

subNEvals = n;

for i=1:n
    
    y(i) = fun(vals(i, :));
    
    if i == 3
        
        if range(y(1:3)) < tol
            
            y = ones(n, 1) * y(1);
            
            noProgress = 1;
            
            subNEvals = 3;
            
            return;
            
        end
        
    end    
    
end

end

function [y, sols, noProgress] = arrayfun2(fun, vals)

noProgress = 0;

n = size(vals, 1);

y = nan(n, 1);

for i=1:n
    
    [A, B] = fun(vals(i, :));
    
    y(i) = A;
        
    sols(i, :) = B; %#ok
    
end

end

function [y, noProgress] = arrayfun3(fun, vals)

noProgress = 0;

n = size(vals, 1);

y = nan(n, 1);

for i=1:n
    
    y(i) = fun(vals(i, :));
    
end

end
function [best0, fval0] = fminiterate2(fun, lower0, upper0, npoints, s, niters)

if nargin == 0
    
    clc
    
    fun = @errfun1;
    
    s = 0.25;
    
    npoints = 5;
    
    niters = 3;
    
    lower0 = [1 7 4];
    
    upper0 = [2 8 5];
    
elseif nargin<4
    
    npoints = 10;
    
    s = 0.25;
    
    niters = 8;
    
end

lower = lower0;

upper = upper0;

nvars = length(lower0);

points = zeros(nvars, npoints);

pointVals = zeros(nvars, npoints);

best = zeros(nvars, nvars);

fval = ones(nvars, 1) * inf;

inds = zeros(nvars, 1);

iters = zeros(nvars, 1); iters(1) = niters + 1;

var = 1;

x = zeros(nvars, 1);

% c1 = 0;

% c2 = 0;

prevMinPointVal = ones(nvars, 1) * inf;

while iters(1)>0
    
    if inds(var) == 0
        
        % populate
        
        points(var, :) = linspace_quick(lower(var), upper(var), npoints);
        
%         pointVals(var, :) = nan(1, npoints);
        
        iters(var) = iters(var) - 1;
        
    end
    
    inds(var) = inds(var) + 1;
    
    if inds(var) > npoints
        
        % either refine current variable or ascend
        
        [minPointVal, ind] = min(pointVals(var, :));
        
        if minPointVal < fval(var)
            
            fval(var) = minPointVal;
            
            best(var, 1) = points(var, ind);
            
            if var<nvars
                
                best(var, 2:end) = best(var+1, 1:end-1);
                
            end
            
        end
        
%         r = range_quick(pointVals(var, :));
        
%         m = mean_quick(pointVals(var, :));

% noProgress = r < m;

        noProgress = minPointVal > prevMinPointVal(var) * 0.99;
        
        prevMinPointVal(var) = minPointVal;
        
        if noProgress
            
            something = 1;
            
        end
        
        if iters(var) == 0 || noProgress;
            
            % ascend
            
            prevMinPointVal(var) = inf;
            
            if var>1
                
                pointVals(var-1, inds(var-1)) = minPointVal;
                
                var = var - 1;
                
            end
            
            continue
            
        else
            
            % refine
            
            rang = upper(var) - lower(var);
            
            p = points(var, ind);
            
            rang = rang * s;
            
            lower(var) = max(lower(var), p - rang/2);
            
            upper(var) = min(upper(var), p + rang/2);
            
            inds(var) = 0;
            
            continue
            
        end
        
    end
    
    x(var) = points(var, inds(var));
    
    if var<nvars
        
        % descend
        
        var = var + 1;
        
        lower(var) = lower0(var);
        
        upper(var) = upper0(var);
        
        iters(var) = niters;
        
        inds(var) = 0;
        
        continue;
        
    end
    
    % evaluate
    
    for i=1:npoints
    
        x(var) = points(var, i);
        
        fv = fun(x);
        
        pointVals(var, i) = fv;
    
    end
    
    inds(var) = npoints;
    
end

% [best fval]

best0 = best(1, :);

fval0 = fval(1);

end

function y = errfun1(x)

a = 1.4;
b = 7.1;
c = 4.6;

y = (x(1)-a).^2 + (x(2)-b).^2 + (x(3)-c).^2;

end


function y = linspace_quick(a, b, points)

step = (b-a) / (points-1);

y = a:step:b;

end

function y = mean_quick(x)

y = sum(x) / length(x);

end

function y = range_quick(x)

mn = inf;
mx = -inf;

for i=1:length(x)
    if x(i)<mn
        mn = x(i);
    end
    if x(i)>mx
        mx = x(i);
    end
end

y = mx-mn;

end
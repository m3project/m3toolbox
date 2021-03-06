function data = quickPivot(paramSet, resultSet, funcs)

if nargin < 3
    
    funcs = {@sum @mean @std @length};
    
end

A = [paramSet resultSet];

groups = splitGroupsUnequal(A, 1);

n = length(groups);

k = length(funcs);

data = zeros(n, k);

for i=1:n
    
    g = groups{i};
    
    data(i, 1) = g(1);
    
    for j=1:k
        
        fun = funcs{j};
    
        data(i, j+1) = fun(g(:,2));
    
    end
    
end

end
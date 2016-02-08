function [G, ids] = splitGroupsUnequal(paramSet, key)

ids = unique(paramSet(:, key), 'rows');

for i=1:length(ids)
    
    k = bsxfun(@eq, paramSet(:, key), ids(i, :));
    
    k = all(k, 2);
   
    block = paramSet(k, :);
    
    G{i} = block;
    
end

end

function [G, ids] = splitGroupsUnequal_old(paramSet, key)

ids = unique(paramSet(:, key));

for i=1:length(ids)
    
    k = paramSet(:, key) == ids(i);
   
    block = paramSet(k, :);
    
    G{i} = block;
    
end

end
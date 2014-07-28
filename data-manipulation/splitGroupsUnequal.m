function [G, ids] = splitGroupsUnequal(paramSet, key)

ids = unique(paramSet(:, key));

for i=1:length(ids)
    
    k = paramSet(:, key) == ids(i);
   
    block = paramSet(k, :);
    
    G{i} = block;
    
end

end
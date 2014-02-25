% splits paramSet into a 3D matrix according to values of the column key
%
function G = splitGroups(paramSet, key)

[r, c] = size(paramSet);

% sort the paramSet by column key

[~, k] = sort(paramSet(:, key));

paramSetS = paramSet(k, :);

% Restructure the sorted paramSetS into a 3d matrix (G):
%
% Each "slice" in the matrix G(:, :, k) will contain the paramSet
% subset for a unique key value.

ids = unique(paramSetS(:, key));

groupRows = r / numel(ids);

if mod(groupRows, 1) ~= 0 % sanity check
   
    error('The matrix paramSet cannot be split into equally-sized groups. This is probably because data was loaded from experiment folders with different sampling spaces.')
    
end

G = reshape(paramSetS', c, groupRows, numel(ids));

G = permute(G, [2 1 3]);

end
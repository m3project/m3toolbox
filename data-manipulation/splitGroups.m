% splits paramSet into a 3D matrix according to values of the column key
%
function [G, ids] = splitGroups(paramSet, key)

[r, c] = size(paramSet);

% sort the paramSet by column key

[~, k] = sortrows(paramSet(:, key));

paramSetS = paramSet(k, :);

% Restructure the sorted paramSetS into a 3d matrix (G):
%
% Each "slice" in the matrix G(:, :, k) will contain the paramSet
% subset for a unique key value.

ids = unique(paramSetS(:, key), 'rows');

groupRows = r / size(ids, 1);

if mod(groupRows, 1) ~= 0 % sanity check
   
    error('The matrix paramSet cannot be split into equally-sized groups. This is probably because data was loaded from experiment folders with different sampling spaces.')
    
end

G = reshape(paramSetS.', c, groupRows, size(ids, 1));

G = permute(G, [2 1 3]);

end
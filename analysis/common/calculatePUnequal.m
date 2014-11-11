% This function splits the data collected by a mantis DX, grating or
% similar experiments according to a specified parameter (e.g. block size,
% stimulus contrast etc.) and then plots these values against another
% parameter.
%
% The inputs are:
%
% combinedSet: (a column-concatenation of paramSet,
% resultSet and an additional column indicating whether the mantis moved
% [1] in that trial or not [0]).
%
% key1: the column index corresponding to the group parameter
% in combinedSet
%
% key2: the column index corresponding to the "plot-against" parameter
% in combinedSet (e.g. contrast)
%
% The outputs are:
%
% data: a 3D matrix containing values of P (column 1), the minor dimension
% specified by key2 (column 2), lower bound on P (column 3) and higher
% bound on P (column 4). The values are produced for the different groups
% specified by the grouping variable.
%
% majorVar: a vector containing the value of the grouping variable for each
% 2D slice in Ps.
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 18/11/2013
%
function [data, majorVar] = calculatePUnequal(combinedSet, key1, key2)

if nargin <3
    key1 = 4; % major dimension (grouping variable)
    key2 = 2; % minor dimension (x)
end

G = splitGroupsUnequal(combinedSet, key1);

groups = length(G);

for i=1:groups
    
    Gi = G{i};
    
    S = splitGroupsUnequal(Gi, key2);
    
    sl = length(S);
    
    m = zeros(sl, 1);
    
    r = zeros(sl, 1);
    
    x = zeros(sl, 1);
    
    for k=1:sl
        
        d = S{k}(:, end);
        
        m(k) = sum(d);
        
        r(k) = length(d);
        
        x(k) = S{k}(1, key2);
        
    end
    
    %m = squeeze(sum(S(:, end, :)));
    
    P = m ./ r;
    
    [L, H] = BinoConf_Score(m, r);    
    
    %x = squeeze(S(1, key2, :));
    
    data{i} = [x P L H m r];
    
    majorVar(i) = Gi(1, key1);
    
end

%majorVar = squeeze(G(1, key1, :));

end
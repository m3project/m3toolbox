% this function splits a matrix A into groups (each having a unique row of
% the values in columns groupCols) and then applies groupFun to each group
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 22/7/2015

function varargout = fold(A, groupCols, groupFun)

if nargin == 0
   
    A = createRandTrialBlocks(3, 1:5, [0 1], 10:12);
    
    groupCols = [1 2];
    
    groupFun = @(As) mean(A(:,3));
    
end

n = size(A, 1);

groups = unique(A(:, groupCols), 'rows');

if nargout, y = []; end

for i=1:size(groups, 1)
    
    g = groups(i, :);
    
    k = all(A(:, groupCols) == (ones(n, 1) * g), 2);
    
    B = A(k, :);
    
    if nargout
        
        nf = nargin(groupFun);
        
        if nf == 1
    
            y(end+1, :) = [g groupFun(B)]; %#ok
            
        elseif nf == 2
            
            y(end+1, :) = [g groupFun(B, i)]; %#ok
            
        else
            
            error('groupFun has an incorrect number of input arguments');
            
        end
        
    else
        
        groupFun(B);
        
    end
    
end

if nargout, varargout{1} = y; end

end
function conds = plotGratingPsychometrics(paramSet, resultSet, condCols, contrastCol, plotFunc)

if nargin < 5
    
    plotFunc = @(~, x, y, L, U) errorbar(x, y, L, U);
    
end

trials = size(paramSet, 1);

conds = unique(paramSet(:, condCols), 'rows');

n = size(conds, 1);

for i=1:n
    
    cond = conds(i, :);

    k = paramSet(:, condCols) == (ones(trials, 1) * cond);
    
    if length(condCols) > 1
        
        k = all(k, 2);
        
    end
    
    subParamSet = paramSet(k, :);
    
    subResultSet = resultSet(k, :);
    
    C = [subParamSet subResultSet];
    
    [G, ids] = splitGroupsUnequal(C, contrastCol);
    
    [rate, U, L] = cellfun(@processContrastGroup, G);
    
    plotFunc(i, ids, rate, L, U);    
   
end

end

function [rate, U, L] = processContrastGroup(G)

correct = sum(G(:, end) == G(:, end-1));

trials = size(G, 1);

[L, U] = BinoConf_ScoreB(correct, trials);

rate = correct/trials;

end
function testVideoClassification()

dir = 'D:\mantisVideoCapture';

list = getDirList(dir, {}, {'xF'});

n = size(list, 1);

paramSet = [];

directions = [];

pmisses = [];

for i=1:n
    
    subdir = fullfile(dir, list{i, :});
    
    fprintf('Processing : %35s ... ', list{i, :});
    
    [A, B, C] = getMantisDirectionDir(subdir);
    
    [accuracy, ~, missRatio] = calAccuracy(A, B, C);
    
    fprintf(' (correct = %1.0f%%, potential miss = %1.0f%%)\n', accuracy*100, missRatio*100);
    
    paramSet = [paramSet; A];
    
    directions = [directions; B];
    
    pmisses = [pmisses; C];
    
end

[accuracy, count, missRatio] = calAccuracy(paramSet, directions, pmisses)

end

function [a, count, missRatio] = calAccuracy(paramSet, directions, pmisses)

k = ~isnan(directions);

correct = paramSet(k) == -directions(k);

correct_or_miss = max(correct, pmisses(k));

a = sum(correct_or_miss) /sum(k);

count = sum(k);

missRatio = sum(pmisses(k)) / sum(k);

end
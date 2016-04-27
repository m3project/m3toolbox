function analyzeStaircaseChannels

dir1 = 'x:\readlab\Ghaith\m3\data\mantisMaskingStaircase';

% dir1 = 'D:\staircase VAR1';

[paramSet, resultSet] = loadDirData(dir1, {'VAR1'}, {'delme', 'BAD1'}, 0);

condKeys = (paramSet(:, 1)-1) * 6 + paramSet(:, 2) * 2 + paramSet(:, 3);

A = [condKeys resultSet];

g = splitGroupsUnequal(A, 1);

m = nan(20, 10);

for i=1:length(g)
   
    k = g{i};
    
    r = size(k, 1);
    
    m(1:r, i) = k(:, 2);
    
end

keyboard

end
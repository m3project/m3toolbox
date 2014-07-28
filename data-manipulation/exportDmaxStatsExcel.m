function exportDmaxStatsExcel()

dataDir = 'V:\readlab\Ghaith\m3\data\mantisDX';

[paramSet, resultSet] = loadDirData(dataDir, {'F'}, {'xF'});

[paramSet, resultSet] = filterExcludeDmaxSubPixel(paramSet, resultSet);

%excelFile = 'd:\dmax_stats.xlsx';

[file, path] = uiputfile('*.xlsx', 'Save File', 'Dmax Statistics');

if isempty(file)
    
    return;
    
end

excelFile = fullfile(path, file);

for key = [1 2]; % 1 for blockSize, 2 for stepSize
    
    keyNames = {'Block Size', 'Step Size'};
    
    table = {keyNames{key}, 'Trials', 'Moved Correct', 'Moved Incorrect', 'Did not Move', 'Moved Left', 'Moved Right'};
    
    A = [paramSet resultSet];
    
    A(:,2) = A(:, 1) .* A(:, 2) / 100; % convert step size from % to absolute value
    
    vals = unique(A(:, key));
    
    for i=1:length(vals)
        
        k = A(:, key) == vals(i);
        
        a = A(k, :);
        
        blockSize = a(:, 1);
        
        stepSize = a(:, 2);
        
        trials = size(a, 1);
        
        movedCorrect = sum(a(:, 3) == a(:, 4));
        
        movedIncorrect = sum(a(:, 3) == -a(:, 4));
        
        didNotMove = sum(a(:, 4) == 0);
        
        movedLeft = sum(a(:, 4) == -1);
        
        movedRight = sum(a(:, 4) == 1);
        
        table(i+1, :) = {a(1, key), trials, movedCorrect, movedIncorrect, didNotMove, movedLeft, movedRight};
        
    end
    
    xlswrite(excelFile, table, key)
    
end

end
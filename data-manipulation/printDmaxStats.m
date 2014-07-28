function printDmaxStats(paramSet, resultSet)

A = paramSet(:, 3);
B = resultSet;

table = {
    {'Total Trials', '%i', size(A, 1)}
    {'Looked Left', '%i', sum(B == -1)}
    {'Looked Right', '%i', sum(B == 1)}
    {'Did not move', '%i', sum(B == 0)}
    {'Looked correct', '%i', sum(B == A)}
    {'Looked incorrect', '%i', sum(B == -A)}
    };

n = length(table);

for i=1:n
    
    item = table{i};
   
    fprintf('%-20s : ', item{1});
    
    fprintf(item{2}, item{3});
    
    fprintf('\n');
    
end

end
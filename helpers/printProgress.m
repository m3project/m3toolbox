function printProgress(str, i, n)

if isempty(str)
    
    str = 'Processing %d of %d';
    
end

if i>1

    oldMsg = sprintf(str, i-1, n);
    
    fprintf(repmat('\b', 1, length(oldMsg)));
    
end

fprintf(str, i, n);
  
if i==n
    
    fprintf('\n');

end
    
end
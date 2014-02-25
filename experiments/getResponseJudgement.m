function response = getResponseJudgement()

c = 'x';

while (length(c) ~= 1 || ismember(c, ['s' 'a' 'b' 'n']) ~= 1)
    
    c = input('Strike (s), Approach (a), Both (b) or None (n)? ', 's');
    
end

if c == 'b'
    
    response = [1 1];
    
elseif c == 'a';
    
    response = [1 0];
    
elseif c == 's'
    
    response = [0 1];
    
else
    
    response = [0 0];
    
end


end
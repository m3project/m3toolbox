function result = getNumber(prompt, validfunc)

if nargin < 1
    
    prompt = 'enter number: ';
    
end

if nargin < 2
    
    validfunc = @(str) validfunc_internal(str);
    
end

str = 'x';

while ~validfunc(str)

    str = input(prompt, 's');

end

result = str2double(str);

end

function valid = validfunc_internal(str)

    valid = ~isnan(str2double(str));

end
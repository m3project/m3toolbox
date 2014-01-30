% This function create a lookup table (as an anonymous function).
%
function lut = createLUT(keys, vals)

lut = @(key) vals( ismember(keys, key, 'rows'), : );

end
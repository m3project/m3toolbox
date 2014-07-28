% filter out errorenous data points with sub-pixel steps:
function [paramSet, resultSet] = filterExcludeDmaxSubPixel(paramSet, resultSet)

k = mod(paramSet(:,1) .* paramSet(:,2) /100,1) == 0;

paramSet = paramSet(k, :);

resultSet = resultSet(k, :);

end
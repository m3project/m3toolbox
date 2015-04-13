% this function calculates the min and max luminance levels
% given a luminance average and a contrast
%
% contrast is defined as (A-B)/(A+B) where A, B are the max and min
% luminance levels respectively
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 24/03/2015

function [B, A] = calLumLevels(avgLum, contrast)

delta = contrast * 2 * avgLum;

A = delta/2 + avgLum;

B = A - delta;

y = [B A];

end
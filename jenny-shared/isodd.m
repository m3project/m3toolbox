function output=isodd(n)
% Tests whether the input is odd.
% Returns 1 if it is an odd integer (real or imaginary), 0 if it is an even integer or not an integer at all.
%
%  Example:
% isodd([2 1.5 3 4 9 -7 -5 3*i 0.3 pi])
% ans =
%     0     0     1     0     1     1     1     1     0     0
% 
% Jenny Read 28/02/2003

% First fill the array with 0 or 1 dependeing on whether it is an integer
output = (round(n)==n);
% Now work out whether it's odd or even
output = output .* (round(n/2)~=n/2);

function y=shiftx(image,shift)
% function y=shiftx(image,shift)
% function to shift an image to the right (or left if shift is negative)
% I wrap it around so what goes off the right comes back on the left.
%
% Example
% shiftx([1:10],3)
% ans =     8     9    10     1     2     3     4     5     6     7
% shiftx([1:10],-3)
% ans =    4     5     6     7     8     9    10     1     2     3
%
% Jenny Read, 8/31/03

if fix(shift)~=shift
    disp('shift must be an integer')
    return
end
[row,col]=size(image);
shift = mod(shift,col); 
y=zeros(row,col);
if shift>0
    y(:,1:shift) = image(:,col-shift+1:col);
    y(:,shift+1:col) = image(:,1:col-shift);
elseif shift<0
    shift = abs(shift);
    y(:,1:col-shift) = image(:,shift+1:col);
    y(:,col-shift+1:col) = image(:,1:shift);
elseif shift==0
    y=image;
end


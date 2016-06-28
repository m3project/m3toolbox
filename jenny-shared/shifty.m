function y=shifty(image,shift)
% function y=shifty(image,shift)
% function to shift an image up (or down if shift is negative)
% I wrap it around so what goes off the top comes back on the bottom
%
% Cf shiftx.m 
%
% Jenny Read, 8/31/03
if fix(shift)~=shift
    disp('shift must be an integer')
    return
end
[row,col]=size(image);
shift = mod(shift,row); 
y=zeros(row,col);
if shift>0
    y(1:shift,:) = image(row-shift+1:row,:);
    y(shift+1:row,:) = image(1:row-shift,:);
elseif shift<0
    shift = abs(shift);
    y(1:row-shift,:) = image(shift+1:row,:);
    y(row-shift+1:row,:) = image(1:shift,:);
elseif shift==0
    y=image;
end


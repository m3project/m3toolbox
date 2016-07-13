function takeScreenshot(sW, sH)

if nargin < 2

    [sW, sH] = getResolution();
    
end

window = getWindow();

imageArray = Screen(window, 'GetImage');

[h, w, ~] = size(imageArray);

left = floor((w - sW)/2) + 1;

top = floor((h - sH)/2) + 1;

imageArray = imageArray(top:top+sH-1, left:left+sW-1, :);

fName = strcat(tempname, '.png');

imwrite(imageArray, fName, 'png');

winopen(fName);

end
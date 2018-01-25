function varargout = genFlashColorationBug(args)

% Generate a flash coloration bug image with an alpha channel, suitable for
% creating a PTB texture.

% The bug shape is situated such that texture rotation causes bug tip to
% rotate along the circumference of a circle.

if nargin > 0

    unpackStruct(args);

else

    bugHeight = 400; % bug length along travel axis (pixels)

    id = 1; % unique bug texture id (nan if none)

    bugLateral = 0.5; % relative lateral size of body

    % bugLateral:
    %  1: bug is equilateral triangle
    % <1: bug is narrower
    % >1: bug is wider

    bugBodyContent = nan;

    % bugBodyContent:
    % nan   : 1/f pattern
    % scalar: luminance value [0, 1]
    % vector: RGB triplet

    d = 600; % pattern dimension (px)

    bugAngle = 0; % degrees

end

isPreview = nargout == 0;

% determine bug base width, based on bugHeight and bugLateral

bugBaseWidth = 2 * bugHeight * tand(30) * bugLateral;

[p1, p2, p3] = getBugPoints(bugHeight, bugBaseWidth);

[p1, p2, p3] = rotateBugPoints(p1, p2, p3, bugAngle);

% determine texture image dimensions

assert(mod(d, 2) == 0); % must be even (required by genNaturalPattern);

% create pattern and mask

if ~isnan(id);

    rng(id);

end

if isnan(bugBodyContent)

    pat = genNaturalPattern(struct('makePlot', 0, 'W', d, 'H', d));

elseif length(bugBodyContent) == 1

    pat = ones(d, d) * bugBodyContent;

elseif all(size(bugBodyContent) > 1) % is bugBodyContent a matrix?

    pat = bugBodyContent;

elseif length(bugBodyContent) == 3

    rch = ones(d, d) * bugBodyContent(1);
    gch = ones(d, d) * bugBodyContent(2);
    bch = ones(d, d) * bugBodyContent(3);

    pat = cat(3, rch, gch, bch);

end

mask = createBugMask(p1, p2, p3, d);

% concatenate pat and mask to create texture-ready 3D matrix

bug = cat(3, pat, mask);

% preview or return bug as output

if isPreview

    clf;

    drawBug(bug);

else

    varargout{1} = bug;

end

end

function [r, theta] = car2pol(x, y)

% Convert points from Cartesian to polar coordinates.

r = sqrt(x.^2 + y.^2);

theta = atan2d(y, x);

end

function [x, y] = pol2car(r, theta)

% Convert points from polar to Cartesian coordinates.

x = r .* cosd(theta);
y = r .* sind(theta);

end

function [p1, p2, p3] = rotateBugPoints(p1, p2, p3, alpha)

x = [p1(1) p2(1) p3(1)];
y = [p1(2) p2(2) p3(2)];

cx = mean(x);
cy = mean(y);

x = x - cx;
y = y - cy;

% convert to polar coordinates

[r, theta] = car2pol(x, y);

theta = theta + alpha;

[x, y] = pol2car(r, theta);

p1 = [x(1) y(1)];
p2 = [x(2) y(2)];
p3 = [x(3) y(3)];

end

function drawBug(bug)

if size(bug, 3) == 2

    pat = bug(:, :, 1);
    mask = bug(:, :, 2);
    patm = pat .* (mask > 0.5);

else

    mask = bug(:, :, 4);

    rch = bug(:, :, 1) .* (mask > 0.5);
    gch = bug(:, :, 2) .* (mask > 0.5);
    bch = bug(:, :, 3) .* (mask > 0.5);

    patm = cat(3, rch, gch, bch);

end

imagesc(patm); axis equal tight;

caxis([0 1]);

colormap gray;

end

function mask = createBugMask(p1, p2, p3, d)

x = [p1(1) p2(1) p3(1)];
y = [p1(2) p2(2) p3(2)];

y = y + d/2;
x = x + d/2;

mask = double(poly2mask(x, y, d, d));

end

function mask = smoothMask(mask)

gaussianFilter = fspecial('gaussian', 10, 5);

mask = imfilter(mask, gaussianFilter);

end

function drawBugPoints(p1, p2, p3)

% Draw bug.

pp = @(p) plot(p(1), p(2), 'o');

pl = @(pa, pb) plot([pa(1) pb(1)], [pa(2) pb(2)], '-');

cla; hold on; axis xy equal; box on, grid on;

pp(p1);
pp(p2);
pp(p3);

pl(p1, p2);
pl(p1, p3);
pl(p2, p3);

end

function [p1, p2, p3] = getEquilaterialBugPoints(side)

% Generate (equilateral) bug point coordinates.

H = side;
B = 2 * H * tand(30);

[p1, p2, p3] = getBugPoints(H, B);

end

function [p1, p2, p3] = getBugPoints(H, B)

% Generate bug point coordinates.

% H is height (distance from tip to base, along major/travel axis) and B is
% base width (along minor axis, orthogonal to travel axis).

p1 = [0 0];
p2 = p1 + [H +B/2];
p3 = p1 + [H -B/2];

end

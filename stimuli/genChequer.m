% generates chequerboard-like pattern
%
% W         : pattern width (px)
% H         : pattern height (px)
% blockSize : chequer size (px)
% random    : 0 = regular pattern (default), 1 = random pattern
% lum0      : luminance level of 0 blocks (default = 0)
% lum1      : luminance level of 1 blocks (default = 1)
% equalize  : if 1 then 0 and 1 blocks have equal counts
% rshift    : if 1 then a random grid offset will be introduced
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 4/6/2015

function chequer = genChequer(args)

% parameters

W = 100;

H = 100;

blockSize = 10;

random = 0;

lum0 = 0;

lum1 = 1;

equalize01 = 1; %#ok

rshift = 0;

if nargin>0
    
    unpackStruct(args);
    
end

%% body

blocks = ceil([W H] / blockSize) + [1 1];

if random
    
    if equalize01 %#ok
        
        pattern = randEqualize(blocks);
        
    else
        
        pattern = rand(blocks) > 0.5;
        
    end    
    
else
    
    [x, y] = meshgrid(1:blocks(2), 1:blocks(1));
    
    pattern = mod(x+y, 2);
    
end

k0 = pattern == 0;
k1 = pattern == 1;

pattern = k0 * lum0 + k1 * lum1;

chequer = imresize(pattern, blockSize, 'nearest');

xs = rshift * randi([1 blockSize]);
ys = rshift * randi([1 blockSize]);

chequer = chequer((1:W) + xs, (1:H) + ys);

chequer = chequer';

end

function pattern = randEqualize(blocks)

n = prod(blocks);

vec = (1:n) > n/2;

k = randperm(n);

pattern = reshape(vec(k), blocks);

end
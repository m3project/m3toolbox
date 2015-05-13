function m = scaleLumLevels(m, minL, maxL)

k = m(:);

lev1 = min(k);
lev2 = max(k);

r = lev2 - lev1;

if r==0
    
    % zero range
    
    m = ones(size(m)) * minL;
    
else
    
    % non-zero range
    
    m = (m - lev1)/r * (maxL-minL) + minL;
    
end

end
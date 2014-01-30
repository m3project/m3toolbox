% Returns list of resolutions (in pixels) that would render the stimulus
% in full screen on the current monitor
function ms = getMs()

%{
[w h] = getResolution();

mx = max([w h]);

ms = [];

for i=1:mx
   
    if sum(mod([w h],i)) == 0
        ms = [ms i];
    end
    
end
%}


getFactors = @(N) find((rem(N, 1:N)==0) .* (1:N));

[w h] = getResolution();

f1 = getFactors(w);
f2 = getFactors(h);

ms = intersect(f1, f2);


end
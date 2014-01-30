function paramSet = createTrial(varargin)

paramCount = nargin; % number of experiment parameters

paramValCount = zeros(paramCount, 1); % number of values in each param vector

params = varargin;

for i=1:paramCount
    
    p = params{i};
    
    [rows, cols] = size(p);
    
    if cols > 1 % check if param is vector
        
        if rows == 1
            params{i} = p'; % p must be a row-vector so transpose
        else           
            error('input %s must be a vector', inputname(i));            
        end
        
    end
    
    paramValCount(i) = length(p);    

end

if paramCount == 1
    
    paramSet = params{1};
    
else
    
    p = params{1};
    
    l = length(p);
    
    set = createTrial(params{2:end});
    
    setRep = repmat(set, l, 1);
    
    r = size(set, 1);
    
    k = idivide(uint32(0:l*r-1), r)+1;
    
    colP = p(k');
    
    paramSet = [colP setRep];
    
end

end
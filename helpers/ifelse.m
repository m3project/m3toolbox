% trivial implementation of a ternary statement
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 7/7/2015

function result = ifelse(cond, trueExpr, falseExpr)

    if cond
        
        result = trueExpr;
        
    else
        
        result = falseExpr;
        
    end

end
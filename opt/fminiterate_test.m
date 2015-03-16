x = 1:1000;

y = @(x) (x-375).^2;

[sol, fval] = fminiterate(y, 1, 1e3)
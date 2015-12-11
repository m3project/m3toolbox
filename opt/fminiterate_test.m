% x = 1:1000;

% y = @(x) (x-375).^2;

% [sol, fval] = fminiterate(y, 1, 1e3, 3, 0.25, 3)

y2 = @(x) (x(1)-375).^2 + (x(2) - 125).^2;

[sol, fval] = fminiterate_multi(y2, [1 1], [1e3 1e3], [3 5], [0.25 0.25], [3 3])
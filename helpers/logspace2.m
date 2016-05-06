% what logspace() should have been

function y = logspace2(a, b, n)

c = b/a;

y = a * power(c, linspace(0, 1, n));

end
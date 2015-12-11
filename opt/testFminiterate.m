function testFminiterate()

[best0, fval0] = fminiterate2(@errfun1, [1 1 1], [10 10 10], 8, 0.25, 9)

[best0, fval0] = fminiterate_multi(@errfun1, [1 1 1], [10 10 10], 8, 0.25, 9)

end


function y = errfun1(x)

a = 1.3;
b = 7.4;
c = 4.6;

y = (x(1)-a).^2 + (x(2)-b).^2 + (x(3)-c).^2;

end
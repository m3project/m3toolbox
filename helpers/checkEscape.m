% quick function to return 1 whenever escape is pressed
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 18/1/2016

function y = checkEscape()

[~, ~, keyCode ] = KbCheck;

y = (keyCode(KbName('Escape')));

end
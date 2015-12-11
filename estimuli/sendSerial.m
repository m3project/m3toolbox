function sendSerial(obj, str)

fprintf(obj, str);

fprintf('sendSerial: %s\n', str);

fprintf(obj, '$'); % terminator

end
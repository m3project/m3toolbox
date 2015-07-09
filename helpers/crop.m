function y = crop(x, low, high)

y = max(min(x, high), low);

end
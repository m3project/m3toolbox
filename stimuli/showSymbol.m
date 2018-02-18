function showSymbol(symbol)

    map1 = createMap({'tick', 'cross'}, {'\x2713', '\x2715'});

    code = map1.get(symbol);

    assert(~isempty(code), 'invalid symbol');

    text = double(sprintf(code));

    showMessage(text, 160);

end
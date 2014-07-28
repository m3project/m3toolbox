function menu = updateMenu(menu, fieldname, newvalue)

k = find(strcmp(menu.table(:, 1), fieldname));

if isempty(k)
    
    error('cannot find specified field in menu');
    
end

menu.table{k, 3} = newvalue;

% now set the updateget flag high and call drawMenu to update the luts

menu.updateget = 1;

menu = drawMenu(menu);

end
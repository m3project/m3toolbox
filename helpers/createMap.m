function map1 = createMap(keys, vals)

map1 = java.util.Hashtable;

for i=1:length(keys)
    
    map1.put(keys{i}, vals{i});
    
end

end
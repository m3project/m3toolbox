% Prints the contents of a menu structure to a given fid (1 by default)
%
% Can also compare against another supplied menu structure
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 16/6/2014
%
% See also drawMenu, updateMenu

function printMenu(menu, oldMenu, fid)

if nargin<2
    
    oldMenu = menu;
    
end

if nargin<3

    fid = 1;

end

n = size(menu.table, 1);

for i=1:n
    
    oldrowi = oldMenu.table(i, :);
    
    rowi = menu.table(i, :);
    
    changedField = ~isequal(rowi{3}, oldrowi{3});
    
    if changedField
        
       rowi{1} = sprintf('** %s **', rowi{1});
    
    end
    
    fprintf(fid, '%20s : ', rowi{1});
    
    fprintf(fid, rowi{4}, rowi{3});
    
    fprintf(fid, '\n');    
    
end

end
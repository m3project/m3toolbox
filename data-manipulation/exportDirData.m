function exportDirData(srcDir, include, exclude, dstDir, handler)

copyhandler = @defaulthandler;

if nargin>4
    
    copyhandler = handler;
    
end

list = getDirList(srcDir, include, exclude);

n = size(list, 1);

fprintf('This is a list of the directories which will be copied:\n\n');

for i=1:n
    
    subdir = list{i};
    
    srcSubDir{i} = fullfile(srcDir, subdir);
    dstSubDir{i} = fullfile(dstDir, subdir);
    
    fprintf('%s -> %s\n', srcSubDir{i}, dstSubDir{i});
    
    if exist(dstSubDir{i}, 'dir')
        
        error('The destination directory ''%s'' already exists', subdir);
        
    end
    
end

fprintf('\n');

p = '';

while isempty(p) ||  length(p) ~= 1 || ~ismember(p, ['y' 'n'])
    
     p = input('Do you wish to proceed (y/n)? ', 's');
     
end

if p == 'n'
    
    return;
    
end

for i=1:n
    
    fprintf('Copying %s ...\n', list{i});

    copyhandler(srcSubDir{i}, dstSubDir{i});
    
end


end

function defaultcopyhandler(srcDir, dstDir)

copyfile(srcDir, dstDir, 'f');

end
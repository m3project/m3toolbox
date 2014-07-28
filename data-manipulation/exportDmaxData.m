function exportDmaxData

% settings

srcDir = 'V:\readlab\Ghaith\m3\data\mantisDX\';

dstDir = 'd:\Dmax Data\';

dataSubDir = 'Experiment Data';

SourceSubDir = 'Source Code';

sourceZippedFile = 'toolbox.zip';

% first, create the data and source sub-directories

mkdir(fullfile(dstDir, dataSubDir));

mkdir(fullfile(dstDir, SourceSubDir));

% export data

dataDir = fullfile(dstDir, dataSubDir);

include = {'F'};

exclude = {'xF'};

exportDirData(srcDir, include, exclude, dataDir, @dmaxCopyHandler);

% export code

toolboxDir = 'V:\readlab\Ghaith\m3\toolbox';

sourceZippedPath = fullfile(dstDir, SourceSubDir, sourceZippedFile);

disp('Zipping toolbox source code ...');

zip(sourceZippedPath, toolboxDir);

% print completion message

disp('Data files and source code were exported successfully.');

end

function dmaxCopyHandler(srcDir, dstDir)

pFile = 'params.mat';
rFile = 'results.mat';
%dFile = 'dumps.mat';

srcPFile = fullfile(srcDir, pFile);
srcRFile = fullfile(srcDir, rFile);
%srcDFile = fullfile(srcDir, dFile);

dstPFile = fullfile(dstDir, pFile);
dstRFile = fullfile(dstDir, rFile);
%dstDFile = fullfile(dstDir, dFile);

load(srcPFile);

load(srcRFile);

if ~exist('paramSet', 'var') || ~exist('resultSet', 'var')
    
    error('error loading parametSet and resultSet');
    
end

[paramSet, resultSet] = filterExcludeDmaxSubPixel(paramSet, resultSet);

paramSet(:, 2) =   paramSet(:, 2) / 100 .* paramSet(:, 1);

mkdir(dstDir);

save(dstPFile, 'paramSet');

save(dstRFile, 'resultSet');

% if exist(srcDFile, 'file')
%     
%     copyfile(srcDFile, dstDFile);
%     
% end

end
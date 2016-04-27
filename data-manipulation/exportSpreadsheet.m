function exportSpreadsheet(dir1, colNames, incFilter, excFilter, ...
    spreadsheetFile, pFun)

if nargin < 2
    
    dir1 = 'x:\readlab\Ghaith\m3\data\mantisTrackFrequency';
    
    colNames = {'bugFreq', 'bugType', 'bugSize', 'Saccades', 'Peering', 'Strikes'};
    
end

if nargin < 4
    
    incFilter = {};
    
    excFilter = {'delme'};
    
end

if nargin < 5
    
    spreadsheetFile = [tempname '.xlsx'];
    
end

if nargin < 6
   
    % data preprocessing function
    
    pFun = @(x) x;
    
end

% input sanity checks

if ~exist(dir1, 'dir'), error('dir1 must be a directory'); end

if ~iscell(colNames), error('colNames must be a cell array'); end

if ~iscell(incFilter), error('incFilter must be a cell array'); end

if ~iscell(excFilter), error('excFilter must be a cell array'); end

% end of sanity checks

dirList = getDirList(dir1, incFilter, excFilter);

getMantisName = @(exptName) exptName(1:find(exptName == ' ', 1, 'first'));

a = cellfun(getMantisName, dirList, 'Uniform', false);

animals = unique(a);

m = length(animals);

if exist(spreadsheetFile, 'file')

    delete(spreadsheetFile);
    
end

for k=1:m
    
    animalName = animals{k};
    
    includeFilter = [incFilter {animalName}];
    
    [pSet, rSet] = loadDirData(dir1, includeFilter, excFilter, 0, 1);
    
    A = [pSet rSet];
    
    A = pFun(A); % preprocess data
    
    if isempty(A)
        
        continue;
        
    end
    
    ntrials = size(A, 1);
    
    ncols = size(A, 2);
    
    sheet = cell(ntrials+1, ncols);
    
    sheet(2:ntrials+1, :) = num2cell(A);
    
    sheet(1, :) = colNames;
    
    xlswrite(spreadsheetFile, sheet, animals{k});
    
end

deleteDefaultSheets(spreadsheetFile);

winopen(spreadsheetFile);

end

function deleteDefaultSheets(spreadsheetFile)

excelFileName = spreadsheetFile;

sheetName = 'Sheet'; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)
% Open Excel file.
objExcel = actxserver('Excel.Application');
objExcel.Workbooks.Open(excelFileName); % Full path is necessary!
% Delete sheets.
try
      % Throws an error if the sheets do not exist.
      objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;
      objExcel.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;
      objExcel.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;
catch %#ok
      
end
% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
objExcel.delete;

end
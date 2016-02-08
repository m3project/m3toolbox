% this script is broken

function exportRawDataExcel(spreadsheetFile, dir, options)

spreadsheetFile = 'h:\mantis_sliding_bars_VAR1_raw_data.xlsx';

dir1 = 'V:\readlab\Ghaith\m3\data\mantisSlidingBars';

k = getDirList(dir1, {'VAR1'}, {'delme'});

getMantisName = @(exptName) exptName(1:find(exptName == ' ', 1, 'first'));

a = cellfun(getMantisName, k, 'Uniform', false);

animals = unique(a);

% animals = {'S04 ', 'S07 ', 'S09 ', 'S011 ', ...
%     'S15 ', 'SL10 ', 'S01 ', 'SL16 ', 'SL8 ', 'SL7 ', 'SL19 ', 'SL20'};

% animals = {'S04 ', 'S07 ', 'S09 ', 'S011 ', 'S15 ', 'SL10 ', 'S01 ', 'SL16 ', 'SL8 ', 'SL7 ', 'SL19 ', 'SL20'}

m = length(animals);

if exist(spreadsheetFile, 'file')

    delete(spreadsheetFile);
    
end

[pSet, rSet, metaSet] = loadDirData(dir1, {'VAR1'},{}, 0, 1);

A = [metaSet pSet rSet];

nTrials = size(A, 1);

if ~isempty(A)
    
    % structure of A
    % col 1 : background type (0=still, 1=in phase, -1=out of phase)
    % col 2 : back block size [5, 10, 20]
    % col 3 : number of saccades
    % col 4 : number of optomotor responses
    % col 5 : number of tracking responses
    % col 6 : peering (1=yes, 0=no)
    % col 7 : number of strikes
    
    sheet = {};
    
    sheet{1, 1} = 'Background Type (0=still, 1=in phase, -1=out of phase)';
    
    sheet{1, 2} = 'Background Block Size (px)';
    
    sheet{1, 3} = 'Number of Saccades';
    
    sheet{1, 4} = 'Number of Optomotor Responses';
    
    sheet{1, 5} = 'Number of Tracking Responses';
    
    sheet{1, 6} = 'Peering (1=yes, 0=no)';
    
    sheet{1, 7} = 'Number of Strikes';
    
    sheet(2:nTrials+1, 1:7) = num2cell(A(:, 1:7));
    
    xlswrite(spreadsheetFile, sheet);
    
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
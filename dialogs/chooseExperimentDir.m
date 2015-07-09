function [dir, contExpt] = chooseExperimentDir(exptName, exptFolder, defName, addTags, ntrials)

if nargin<2
    
    exptName = 'Mantis Dmax';
    
    exptFolder = 'V:\readlab\Ghaith\m3\data\mantisDX\';
    
end

title = 'Start Experiment';

w = 400;

w2 = 300;

m1 = 25;

n = 1;

names = {'Lisa', 'Nat', 'Vivek', 'Ghaith', 'Will', 'Diana', 'Jimmy', 'Steven'};

defNameInd = 1;

if nargin > 2
   
    k = find(strcmp(names, defName));
    
    if k ~= -1
        
        defNameInd = k;
        
    end
    
end

% setting up fields

prompt(n,:) = {'Subject :', 'subject' ,'(e.g. F21)'};
formats(n, 1).size = w2;
formats(n, 1).margin = [m1 5];
formats(n, 1).unitsloc = 'rightmiddle';

n = n+1;

prompt(n,:) = {'Tags :','tags','(e.g. 6cm sub)'};

formats(n, 1).size = w2;
formats(n, 1).margin = [m1 5];
formats(n, 1).unitsloc = 'rightmiddle';

n = n+1;

prompt(n,:) = {'Block Number :','block','(optional)'};

formats(n, 1).size = w2;
formats(n, 1).margin = [m1 5];
formats(n, 1).unitsloc = 'rightmiddle';

n = n+1;

prompt(n,:) = {'Experimenter :','name',''};
formats(n, 1).type = 'list';
formats(n, 1).style = 'popupmenu';
formats(n, 1).items = names;
formats(n, 1).size = w2;
formats(n, 1).margin = [m1 00];

n = n+1;

prompt(n,:) = {'Experiment :','experiment',''};
formats(n, 1).size = w;
formats(n, 1).margin = [m1 0];
formats(n, 1).enable ='off';

n = n+1;

prompt(n,:) = {'Number of Trials :','ntrials',''};
formats(n, 1).size = w;
formats(n, 1).margin = [m1 0];
formats(n, 1).enable ='off';

n = n + 1;

prompt(n,:) = {'Parent Directory :','topfolder',''};
formats(n, 1).size = w;
formats(n, 1).margin = [m1 0];
formats(n, 1).enable ='off';

n = n+1;

prompt(n,:) = {'Date and Time :','datetime',''};
formats(n, 1).size = w;
formats(n, 1).margin = [m1 0];
formats(n, 1).enable ='off';

n = n+1;

prompt(n, :) = {'Continue previous experiment', 'continue', ''};
formats(n, 1).size = w;
formats(n, 1).margin = [m1 0];
formats(n, 1).enable ='on';
formats(n, 1).type = 'check';
formats(n, 1).style = 'checkbox';

dateStr = datestr(now, 'dd-mm-yyyy HH.MM');

defs = struct([]);
defs(1).experiment = exptName;
defs(1).datetime = dateStr;
defs(1).topfolder = exptFolder;
defs(1).name = defNameInd;
defs(1).ntrials = num2str(ntrials);

options.AlignControls = 'on';
options.FontSize = 10;
options.Sep = 16;

options.CreateFcn = @onDialogCreate;

[answer, cancelled] = inputsdlg(prompt, title, formats, defs, options);

drawnow

contExpt = answer.continue;

if contExpt == 1
    
    dir = uigetdir(exptFolder, 'Select experiment folder');
    
    return
    
end

if cancelled
    
    dir = '';
    
else

    %all_tags = sprintf('%s %s %s', answer.tags, upper(names{answer.name}), answer.block);
    
    tags = {};
    
    if ~isempty(answer.tags)
        
        tags = textscan(answer.tags,'%s');
        
        tags = tags{:};
        
    end
    
    if ~isempty(answer.block)
        
        tags{end+1} = answer.block;
        
    end
    
    if nargin == 4
        
        tags = {tags{:} addTags{:}};
        
    end
    
    tags{end+1} = upper(names{answer.name});
    
    tagStr = sprintf(' (%s)', tags{:});
    
    tagStr = strtrim(tagStr);
    
    dir = sprintf('%s %s %s', answer.subject, dateStr, tagStr);
    
end

end

function onDialogCreate(varargin)

fh = varargin{1};

screenSize = get(0, 'ScreenSize');

pos = get(fh, 'Position');

w = pos(3);

h = pos(4);

sW = screenSize(3);

sH = screenSize(4);

x1 = (sW - w)/2;

y1 = (sH - h)/2;

set(fh, 'Position', [x1 y1 w h]);

end
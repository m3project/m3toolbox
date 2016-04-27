function plotStaircaseMaskingPsychometric

dir1 = 'x:\readlab\Ghaith\m3\data\mantisMaskingStaircase';

% dir1 = 'D:\staircase VAR1';

% dir1 = 'D:\collar';

resultsFile = 'results.mat';

binStep = 0.1;

maxThreshold = 0.5;

%%

list = getDirList(dir1, {'VAR1'}, { ...
%     'NS90 07-05-2015 13.57' ...
%     'NS90 07-05-2015 13.53' ...
         'xN' ...
         'delme' ...
         'BAD1' ...
    }, 1);

n = size(list, 1);

if n == 0
    
    error('no results found')
    
end

Set = [];

clf

subplot(2, 1, 2); cla; hold on; grid on;

xlabel('Staircase Step');

ylabel('Threshold');

thresholds = [];

home;

for i=1:n
    
    item = list{i};
    
    pFile = fullfile(dir1, item, 'params.mat');
    
    pData = load(pFile);
    
    cond = getCondition(pData.paramSet);
    
    if ~isequal(cond, 1)
        
        continue;
        
    end
    
    fprintf('%s\n', item);
    
    f = fullfile(dir1, item, resultsFile);
    
    load(f);
    
    if power(10, resultSet) <= maxThreshold
    
        Set = [Set; history(:, 1:2)];
        
        thresholds = [thresholds; power(10, history(end, 3))];
        
        plot(power(10, history(:, 3))); ylim([0 1])
        
        set(gca, 'yscale', 'log');
    
    end
    
end

x = Set(:, 1);
y = Set(:, 2);

x10 = power(10, x);

x10 = round(x10 / binStep) * binStep;

z = splitGroupsUnequal([x10 y], 1);

plotData = [];

for j=1:length(z)
   
    zj = z{j};
    
    m = sum(zj(:, 2));
    
    n = size(zj, 1);
    
    [L, U] = BinoConf_ScoreB(m, n);
    
    plotData = [plotData; zj(1) m/n L U m n];
    
end

strTitle = sprintf('Mean = %1.2f, \\sigma = %1.2f', mean(thresholds), std(thresholds));

title(strTitle);

subplot(2, 1, 1);

errorbar(plotData(:, 1), plotData(:,2), plotData(:,3), plotData(:,4), '-o');

xlabel('Contrast');



strTitle = sprintf('Response Rate (%d points)', size(Set, 1));

title(strTitle);

axis([0 1 0 1]);

grid on

thresholds

end

function cond = getCondition(paramSet)

condTab = getConditionsTable();

ind = findRow2(condTab(:, 1:3), paramSet);

cond = condTab(ind, 4);

end

function ind = findRow2(m, r)

[~,ind] = ismember(m, r, 'rows');

ind = find(ind);

end

function condTab = getConditionsTable()

% columns:  channel, noise cond (0=none, 1=same, 2=diff),
%           

condTab = [
    1	0	0   1
    1	1	0   2
    1	1	1   3
    1	2	0   4
    1	2	1   5
    2	0	0   6
    2	1	0   7
    2	1	1   8
    2	2	0   9
    2	2	1   10
    ];

end
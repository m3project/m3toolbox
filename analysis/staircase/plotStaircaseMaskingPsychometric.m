function plotStaircaseMaskingPsychometric

dir1 = 'V:\readlab\Ghaith\m3\data\mantisMaskingStaircase';

resultsFile = 'results.mat';

binStep = 0.1;

maxThreshold = 0.8;

%%

list = getDirList(dir1, {'4SECS'}, {'SET_A', '5SECS'}, 1);

n = size(list, 1);

if n == 0
    
    error('no results found')
    
end

set = [];

subplot(2, 1, 2); cla; hold on; grid on;

xlabel('Staircase Step');

ylabel('Threshold');

thresholds = [];

for i=1:n
    
    item = list{i};
    
    f = fullfile(dir1, item, resultsFile);
    
    load(f);
    
    if power(10, resultSet) < maxThreshold
    
        set = [set; history(:, 1:2)];
        
        thresholds = [thresholds; power(10, history(end, 3))];
        
        plot(power(10, history(:, 3))); ylim([0 1])
    
    end
    
end

x = set(:, 1);
y = set(:, 2);

x10 = power(10, x);

x10 = round(x10 / binStep) * binStep;

z = splitGroupsUnequal([x10 y], 1);

plotData = [];

for j=1:length(z)
   
    zj = z{j};
    
    m = sum(zj(:, 2));
    
    n = size(zj, 1);
    
    [L, U] = BinoConf_ScoreB(m, n);
    
    plotData = [plotData; zj(1) m/n L U];
    
end

strTitle = sprintf('Mean = %1.2f, \sigma = %1.2f', mean(thresholds), std(thresholds));

title(strTitle);

subplot(2, 1, 1);

errorbar(plotData(:, 1), plotData(:,2), plotData(:,3), plotData(:,4), '-o');

xlabel('Threshold');

strTitle = sprintf('Response Rate (%d points)', size(set, 1));

title(strTitle);

axis([0 1 0 1]);

grid on

end
% Staircase Function (runStaircase)
% ---------------------------------
%
% Runs a Bayesian staircase given a psychometric function fun and a
% threshold range xrange. Supports multiple conditions
%
% Parameters:
% -----------
%
% fun : a handle to the psychometric in the form fun@(cond, x) where cond
% is the condition and x is the parameter value
%
% steps : number of staircase steps per condition
%
% sigma : used co trade-off estimation precision vs. speed
%
% pfp, pfn: probabilities of false positives and false negatives
% respectively
%
% Returns:
% --------
%
% bestX : best estimates of x for the different conditions
%
% history: a 3D matrix holding staircase step details for each condition
%
% data of condition i are stored in history(:, :, i) in the following
% format:
%
% col 1 : x value passed to fun()
% col 2 : result returned by fun
% col 3 : bestEstimateTheta after step i
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 6/3/2015

function [bestX, history] = runStaircase(fun, nconds, xrange, steps, sigma, pfp, pfn, makePlot)

if nargin < 8
    
    if nargin > 0
    
        error('incorrect number of input parameters');
    
    end
    
    fun = @(cond, x) blackBoxPsychometric(cond, x);
    
    nconds = 5;
    
    xrange = [1 100];
    
    steps = 30; % staircase steps
    
    sigma = 20;
    
    pfp = 0.01; % probability of false positive
    
    pfn = 0.01; % probability of false negative
        
    makePlot = 0;
    
end

priorsLength = 1e3;

xmin = xrange(1);

xmax = xrange(2);

xstep = (xmax - xmin) / (priorsLength - 1);

xvals = (xmin:xstep:xmax)';

priors = ones(priorsLength, nconds);

sequence = createRandTrialBlocks(steps, 1:nconds);

progress = zeros(nconds, 1);

n = size(sequence, 1);

history = nan(steps, 3, nconds);

for j=1:n
    
    cond = sequence(j); % condition of this trial
    
    progress(cond) = progress(cond) + 1;
    
    i = progress(cond);
    
    k = getMeanIndex(priors(:, cond));
    
    x = xvals(k);
    
    result = fun(cond, x);
    
    F = psychometric(x, xvals, sigma);
    
    if result == 0 % not moving
        
        likelihood = (1-F) * (1-pfp) + F * pfn;
        
    elseif result == 1 % moving in correct direction
        
        likelihood = (1-F) * pfp/2 + F * (1 - pfn);
        
    elseif result == 2 % moving in incorrect direction
        
        likelihood = (1-F) * pfp/2;
        
    else
        
        error('incorrect value');
        
    end
    
    posteriori = normV(priors(:, cond) .* likelihood);
    
    priors(:, cond) = posteriori;
    
    [~, k] = max(posteriori);
    
    bestEstimateTheta = xvals(k);
    
    history(i, :, cond) = [x result bestEstimateTheta];
    
    if mod(i, 1) == 0 && makePlot
        
        % plots
        
        figure(cond);
        
        set(cond, 'Name', sprintf('Condition %d', cond));
        
        subplot(3, 2, 1:2);
        
        plot(xvals, F); xlabel('x');
        
        strTitle = sprintf('psychometric (x=%1.2e)', x);
        
        title(strTitle);
        
        subplot(3, 2, 3:4);
        
        plot(xvals, likelihood);
        
        xlabel('\theta'); title('likelihood');
        
        subplot(3, 2, 5);
        
        plot(xvals, posteriori);
        
        xlabel('x'); title('updated priors');
        
        ylim([0 1]);
        
        subplot(3, 2, 6);
        
        plot(1:steps, history(:, 3, cond));
        
        strTitle = sprintf('most-likely x = %1.2f', bestEstimateTheta);
        
        xlabel('trials'); title(strTitle);
        
        axis([1 steps xmin xmax]);
        
        drawnow
        
    end
    
end

bestX = squeeze(history(steps, 3, :));

end

function y = psychometric(x, theta, sigma)

y = 0.5 * (1+erf((x-theta)/sqrt(2)/sigma));

end

function c = blackBoxPsychometric(cond, x)

thetas = 20:10:100;

theta = thetas(cond);

sigma = 10;

perr1 = 0.1;

perr2 = 0.1;

c = 0.5 * (1 + erf((x-theta)/sqrt(2)/sigma)) > 0.5;

if rand<perr1
    
    c = 1-c;
    
elseif rand<perr2
    
    c = 2;
    
end

end

function x = getMeanIndex(priors)

c = cumsum(priors);

m = c(end);

x = find(c > m/2, 1, 'first');

end


function y = normV(x)

y = x / max(x);

end
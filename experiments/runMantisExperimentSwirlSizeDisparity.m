%{

we need to get in touch with Vivek to see what he thinks of the below as
he's been doing similar experiments

suggested protocol:

- no alignment stimulus
- some 60 second delay between trials (to avoid habituation)

also need to ask Vivek how he has coded the results. Looks like he played
the trial videos AFTER the experiment and wrote down the responses.

Vivek approved the above (29th Jan 2015)

%}
function runMantisExperimentSwirlSizeDisparity()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisSwirlSizeDisparity\';

expt.name = 'Mantis Swirl Size Disparity';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Geoffrey';

runExperiment(expt);

end

function paramSet = genParamSet()

% plotParams = 0;

viewD = input('Enter distance between mantis and screen (cm): ');

glassOri=input('Is the green lens on the left eye (1 for yes; 2 for no) ?');

if glassOri == 1
    glassSign = 1;
else
    glassSign = -1;
end
% experiment parameters

simDistances = [2.5 5 10]; % cm

% sizes = [0.5 1 2]; % cm as perceived at a distance of 2.5cm away from mantis
 sizes = [0.5 1]; % cm as perceived at a distance of 2.5cm away from mantis

bugSizeDeg = 2 * atand(sizes/2/2.5);

% paramSet = createRandTrialBlocks(3, simDistances, bugSizeDeg, viewD, glassSign);
 paramSet = createRandTrialBlocks(5, simDistances, bugSizeDeg, viewD, glassSign);
end

function runBeforeTrial(varargin)

%runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

% constants

scrReso = 40; % screen resolution (px/cm)

IOD = 0.4; % mantis inter-ocular distance

viewD = paramSetRow(3);

% rendering

disp('rendering the stimulus');

simDistance = paramSetRow(1);

bugSizeDeg = paramSetRow(2);

bugSizeCm = 2 * viewD * tand(bugSizeDeg/2); % on screen

bugSizePx = round(bugSizeCm * scrReso); % on screen

if simDistance>viewD
    
    d =  -paramSetRow(4) * IOD / simDistance * (simDistance-viewD);
    
else

    d = paramSetRow(4)*(viewD - simDistance) * IOD ./  simDistance; % disparity in cm

end

disparityPx = round(d * scrReso);

expt.bugSizePx = bugSizePx;

expt.disparity = @(t) disparityPx;

runSwirlGeoffrey(expt);

dump = 0;

exitCode = 0;

end

function resultRow = runAfterTrial(varargin)

%resultRow = getTrackingJudgement();

resultRow = 0;

pause(60);

end
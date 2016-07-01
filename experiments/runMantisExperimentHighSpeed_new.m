function runMantisExperimentHighSpeed()

inDebug();

expt = struct;

expt.genParamSetFun = @genParamSet_VAR2;

expt.runBeforeTrialFun = @runBeforeTrial_VAR2;

expt.runTrialFun = @runTrial_VAR2;

expt.runAfterTrialFun = @runAfterTrial_VAR2;

expt.workDir = 'x:\readlab\Ghaith\m3\data\mantisHighSpeed\';

expt.name = 'Mantis High Speed';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Jeff';

runExperiment(expt);

end

%% VAR2

function paramSet = genParamSet_VAR2()

blocks = 1;

glassOri = input('Is the green lens on the left eye (1 for yes; 2 for no) ?');

glassSign = ifelse(glassOri == 1, 1, -1);

% experiment parameters

simDistances = [2.5 3.75 5.625]; % cm - distances used for Sphodromantis
% simDistances = [2.5 3.75 5.625]; % cm - distances used for Rhombodera

%Shpodro1
% sizes = [0.2183 0.3277 0.4925 0.7417]; % cm as perceived at a distance of 2.5 cm away from mantis - sizes used for Sphodromantis
 
%Sphodro2
  sizes = [0.3277 0.4925 0.7417 1.1228]; % cm as perceived at a distance of 2.5 cm away from mantis - alternative sizes used for Sphodromantis

%Rhombo1
 % sizes = [.3935 .5918 .8929 1.3573]; % cm as perceived at a distance of 2.5 cm away from mantis - sizes used for Rhombodera

bugSizeDeg = 2 * atand(sizes/2/2.5);

paramSet = createRandTrialBlocks(blocks, simDistances, bugSizeDeg, glassSign);

end


function resultRow = runBeforeTrial_VAR2(varargin)

viewD = input('Enter distance between mantis and screen (cm): ');

resultRow = viewD;

end

function runTrial_VAR2(paramSetRow)

% rendering

disp('rendering the stimulus');

simDistance = paramSetRow(1);

bugSizeDeg = paramSetRow(2);

expt.viewD = paramSetRow(3);

glassSign = paramSetRow(4);

expt.bugSize = 2 * simDistance * tand(bugSizeDeg/2); % simulated

expt.disparityEnable = glassSign;

expt.virtDm1 = simDistance;

expt.virtDm2 = simDistance;

% testing:

runLoomAnaglyph(expt);

end

function resultRow = runAfterTrial_VAR2(varargin)

%resultRow = getTrackingJudgement();

% because the camera can only record 13 mins continuously,
% we can afford (13*60)/12 = 65 second per trial

% we measured presentation time as 8 seconds

% so, leaving a safety margin, we chose a delay of 50 seconds between
% trials

resultRow = 0;

pause(50);

end

%%

function paramSet = genParamSet()

blocks = 1;

viewD = input('Enter distance between mantis and screen (cm): ');

glassOri = input('Is the green lens on the left eye (1 for yes; 2 for no) ?');

glassSign = ifelse(glassOri == 1, 1, -1);

% experiment parameters

simDistances = [2.5 3.75 5.625]; % cm - distances used for Sphodromantis
% simDistances = [2.5 3.75 5.625]; % cm - distances used for Rhombodera

%Shpodro1
% sizes = [0.2183 0.3277 0.4925 0.7417]; % cm as perceived at a distance of 2.5 cm away from mantis - sizes used for Sphodromantis
 
%Sphodro2
  sizes = [0.3277 0.4925 0.7417 1.1228]; % cm as perceived at a distance of 2.5 cm away from mantis - alternative sizes used for Sphodromantis

%Rhombo1
 % sizes = [.3935 .5918 .8929 1.3573]; % cm as perceived at a distance of 2.5 cm away from mantis - sizes used for Rhombodera

bugSizeDeg = 2 * atand(sizes/2/2.5);

paramSet = createRandTrialBlocks(blocks, simDistances, bugSizeDeg, viewD, glassSign);

end

function runBeforeTrial(varargin)

%runAlignmentStimulus();

end

function runTrial(paramSetRow)

% rendering

disp('rendering the stimulus');

simDistance = paramSetRow(1);

bugSizeDeg = paramSetRow(2);

expt.viewD = paramSetRow(3);

glassSign = paramSetRow(4);

expt.bugSize = 2 * simDistance * tand(bugSizeDeg/2); % simulated

expt.disparityEnable = glassSign;

expt.virtDm1 = simDistance;

expt.virtDm2 = simDistance;

% testing:

runLoomAnaglyph(expt);

end

function resultRow = runAfterTrial(varargin)

%resultRow = getTrackingJudgement();

% because the camera can only record 13 mins continuously,
% we can afford (13*60)/12 = 65 second per trial

% we measured presentation time as 8 seconds

% so, leaving a safety margin, we chose a delay of 50 seconds between
% trials

resultRow = 0;

pause(50);

end
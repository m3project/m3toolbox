function runMantisExperimentTracking()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisTrack\';

expt.name = 'Mantis Track';

expt.recordVideos = 1;

expt.makeBackup = 1;

expt.defName = 'Lisa';

runExperiment(expt);

end

function paramSet = genParamSet()

blocks = 1;

dirs = [-1 1];

speeds = 200:200:1000;

paramSet = createRandTrialBlocks(blocks, dirs, speeds);

end


function runBeforeTrial(~)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus ...');

expt = struct;

expt.dir = paramSetRow(1);

expt.speed = paramSetRow(2);

expt.timeLimit = 1500 / expt.speed;

runSimpleHoritzontal(expt);

exitCode = 0;

dump = [];

end

function resultRow = runAfterTrial(varargin)

resultRow = [getDirectionJudgement() getTrackResponseJudgement()];

end

function response = getTrackResponseJudgement()

c = 'x';

letters = ['n' 't' 's' 'p' 'w'];

while (length(c) ~= 1 || ismember(c, letters) ~= 1)
    
    c = input('None(n), Track(t), Strike (s), Peer (p) or Twitch (w)? ', 's');
    
end

response = strfind(letters, c);

end
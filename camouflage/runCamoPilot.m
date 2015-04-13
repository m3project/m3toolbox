function runCamoPilot

%% params

% background parameters

spatialScale = 0.1; % 0.01 (large) or 0.1 (small)

temporalScale = 0.01; % 0.05 (fast), 0.01 (slow), 0.0001 (static)

backContrast = 0.5; % 0 to 1

% bug parameters

bugSpeed = 500; % px/sec

bugWidth = 100; % px

bugHeight = 30; % px

bugSpatialScale = 0.1; % 0.01 (large) or 0.1 (small)

bugBaseLuminance = 0.5; % 0 (black), 0.5 (grey) to 1 (white)

bugContrast = 0.1;

bugJitter = 5; % px

% experiment parameters

trials = 100;

%% sanity checks

[bugMinLum, bugMaxLum] = calLumLevels(bugBaseLuminance, bugContrast);

y = [bugMinLum, bugMaxLum];

if any(y<0) || any(y>1)
    
    disp('calculated bug lunminance levels:');
    
    y
    
    error('the base luminance and contrast values you chose result in contrast levels that either less than 0 or larger than 1');
    
end

delta = diff(y);

%% generate bug

expt = struct;

expt.W = max(bugWidth, bugHeight);

expt.H = expt.W;

expt.T = 2;

expt.bacSigx = bugSpatialScale;

s = genCamouflageVideo(expt);

bugTexture = abs(s(1:bugWidth, 1:bugHeight, 1));

bugTexture = bugTexture / max(bugTexture(:));

bugTexture = bugMinLum + bugTexture * delta;

%bugTexture = ones(size(bugTexture)) * bugBaseLuminance + delta * bugTexture;

%% code

createWindow(1);

expt = struct;

expt.W = 512;

expt.H = expt.W;

expt.T = 128;

expt.bacSigx = spatialScale;

expt.bacSigT = temporalScale;

%% code 2

expt2 = struct;

expt2.contrast = backContrast;

expt2.bugSpeed = bugSpeed;

expt2.bugTexture = bugTexture;

expt2.bugJitter = bugJitter;

expt2.duration = 3;

%% setup cleanup object

obj = onCleanup(@() onExperimentOver(packWorkspace()));

%% loop

correct = 0;

wrong = 0;

for i=1:trials
    
    fprintf('Trial %i: preparing stimulus, ', i);
    
    s = genCamouflageVideo(expt);
    
    runAnimation2();
    
    expt2.bugDirection = power(-1, rand>0.5);
    
    runCamo(s, expt2);
    
    key = getDirectionJudgement();
    
    if key==expt2.bugDirection
        
        correct = correct + 1;
        
        disp('CORRECT')
        
    else
        
        wrong = wrong + 1;
        
        disp('wrong')
        
    end
    
end

end

function onExperimentOver(expt)

fprintf('end of experiment\n');

fprintf('total trials : %i\n', expt.i);

fprintf('correct direction judgements : %i\n', expt.correct);

fprintf('wrong direction judgements : %i\n', expt.wrong);

% closeWindow();

end
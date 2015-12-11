function runSlidingBars(args)

[sW, sH] = getResolution();

duration = 3/5 * 2 * pi * 50;

n = 22; % number of bars

chequerR = 700; % speed (px/sec)

bugR = 700; % speed (px/sec)

barH = 20;

blockSize = 20;

freqBack = 5/3; % rad/sec

freqBug = 5/3; % rad/sec

keepOut = 80*1; % pixels

bugW = 80; % pixels

bugH = bugW; % pixels

bugPhase = pi/2;

escapeEnabled = 1; %#ok

preTrialDelay = 0;

if nargin>0
    
    unpackStruct(args);
    
end

%% body

chequerArgs = struct('W', sW + 2*chequerR, 'H', barH, 'blockSize', blockSize);

for i=1:n
    
    % as above
    
    textures{i} = genChequer(chequerArgs); %#ok
    
    cy = sH/2 - keepOut/2 - (i) * barH;
    
    phase = pi * i;
    
    motionFunctions{i} = @(t) fun1(-chequerR, cy, chequerR, freqBack, phase, t); %#ok
    
    % so below
    
    textures{i+n} = genChequer(chequerArgs); %#ok
    
    cy = sH/2 + keepOut/2 + (i-1) * barH;

    phase = pi * (i+1);
    
    motionFunctions{i+n} = @(t) fun1(-chequerR, cy, chequerR, freqBack, phase, t); %#ok    

end

% bug texture

textures{2*n+1} = zeros(bugW, bugH); %#ok

motionFunctions{2*n+1} = @(t) fun1(sW/2 - bugW/2, (sH-bugH)/2, bugR, freqBug, bugPhase, t); %#ok 

% runTextureAnimation

args2 = packWorkspace('duration', 'escapeEnabled', 'textures', 'motionFunctions');

% if isempty(Screen('windows'))
%     
%     Gamma = 2.783; % this is for Lisa's Phillips 107b3
%     
%     createWindow(Gamma);
%     
% end

if preTrialDelay > 0
    
    args2.duration = 2/85;
    
    runTextureAnimation(args2);
    
    pause(preTrialDelay);
    
    args2.duration = duration;
    
end

runTextureAnimation(args2);

end

function [x, y] = fun1(cx, cy, r, angVel, phase, t)

y = cy;

x = cx + r * sin(angVel * t + phase);

end
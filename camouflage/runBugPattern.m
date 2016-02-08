%{

notes:

Question 1: are response rates using a chequered background higher than those of a gray background?

Question 2: are response rates higher when the bug pattern has sharper edges?

Parameters that may affect response rates:

- background spatial frequency
- background edge smoothness
- bug spatial frequency
- bug edge smoothness

%}

function runBugPattern(args)

% parameters

% background

baseLum = 0.5;

backBlockSize = 5; % px

backBlockContrast = 1;

% bug:

bugType = 4; % 1 = spatial pattern, 2 = regular block, 4 = random chequer, 5 = black, 6 = gray

Fx = 8/32; %#ok % cycle/px (bugType=1)

Sigx = 0.01; %#ok % cycle/px (bugType=1)

bugBlockSize = 10; %(bugType=2)

bugContrast = 1;

bugSpeed = 500; % px/sec

bugJitter = 0; % (+-) px

dir = power(-1, rand>0.5);

W = 80; % bug width (px)

H = 80; % bug height (px)

% other duration = 15; %#ok % seconds

escapeEnabled = 1; %#ok

initDelay = 1;

bugSeed = []; % bug random seed

backSeed = []; % back random seed

if nargin>0
    
    unpackStruct(args);
    
end

%% generation background

[scrW, scrH] = getResolution();

[mn, mx] = calLumLevels(baseLum, backBlockContrast); % for background

backPattern = genChequer(struct( ...
    'W', scrW, 'H', scrH, 'blockSize', backBlockSize, ...
    'random', 1, 'lum0', mn, 'lum1', mx, 'equalize01', 0, ...
    'rshift', 0, 'rseed', backSeed)); %#ok

%% generate pattern

[mn, mx] = calLumLevels(baseLum, bugContrast); % for bug

if bugType == 1
    
    % spatial pattern bug
    
    % the code below will make repetitive attempts to generate a bug pattern
    % it will stop when the mean luminance of the generated bug is within an
    % acceptable range of a target mean luminance
    
    MAX_RETRIES = 50;
    
    bestBug = 1;
    
    bestBugLumErr = inf;
    
    for i=1:MAX_RETRIES
        
        bugPattern = gen2DPattern(packWorkspace('Fx', 'Sigx', 'W', 'H'));
        
        %bugPattern = sign(bugPattern);
        
        [minLum, maxLum] = calLumLevels(baseLum, bugContrast);
        
        bugPattern = scaleLumLevels(bugPattern, minLum, maxLum);
        
        bugBaseLum = mean(bugPattern(:));
        
        baseLumErr = abs(bugBaseLum - baseLum);
        
        if baseLumErr < bestBugLumErr
            
            bestBug = bugPattern;
            
            bestBugLumErr = baseLumErr;
            
        end
        
    end
    
    bugPattern = bestBug; %#ok
    
elseif bugType == 2
    
    % regular chequered (block-based) bug
    
    bugPattern = genChequer(struct( ...
         'W', W, 'H', H, 'blockSize', bugBlockSize, ...
    'random', 0, 'lum0', mn, 'lum1', mx, 'equalize01', 1, ...
    'rshift', 0)); %#ok
    
elseif bugType == 4
    
    % random chequered bug
    
      bugPattern = genChequer(struct( ...
         'W', W, 'H', H, 'blockSize', bugBlockSize, ...
    'random', 1, 'lum0', mn, 'lum1', mx, 'equalize01', 1, ...
    'rshift', 0, 'rseed', bugSeed)); %#ok
    
elseif bugType == 5
    
    bugPattern = zeros(W, H); %#ok
    
elseif bugType == 6
    
    bugPattern = 0.5 * ones(W, H); %#ok    
    
end

%% render

[sW, sH] = getResolution();

getBugPosition = @(t) getBugPosSwirl_int(t, sW, sH, dir, bugSpeed, bugJitter, initDelay); %#ok

args2 = packWorkspace('bugPattern', 'getBugPosition', 'escapeEnabled', 'duration', 'backPattern');

runCamoPattern(args2);

end

function pos = getBugPosRandWalk(t, sW, sH, bugDirection, bugSpeed, bugJitter)

persistent x;
persistent y;
persistent dx;
persistent dy;
persistent n;

if isempty(x)
    
    x = 0;
    y = 0;
    n = 0;
    
end

if n == 0
    
    dx = 2*(rand()-0.5);
    dy = 2*(rand()-0.5);
    
end

v = 15;

b = 100;

n = mod(n+1,60);

x = x + dx * v;
y = y + dy * v;

if (x>b && dx>0) || (x<-b && dx<0)
    dx = -dx;
end

if (y>b && dy>0) || (y<-b && dy<0)
    dy = -dy;
end

pos = [sW sH]/2 + [x y] + 2*(rand(1,2)-0.5)*bugJitter;

end

function pos = getBugPosSwirl_int(t, sW, sH, bugDirection, bugSpeed, bugJitter, initDelay)

t = max(t-initDelay, 0); % change (t-1) to (t-15) for experiment

dt = 0.02;

% t = round(t/dt)*dt;

radius = 700; % px

% radius = 300 - t * 50;

angVel = bugDirection * bugSpeed / radius; % angular velocity (rad/sec)

angVel = bugSpeed / 300;

angPos = angVel * t;

pos = [sW sH+200]/2 + [cos(angPos) 0*sin(angPos)] * radius + ...
    round(rand2(1, 2) * bugJitter);

if t==0
    
    pos = [-1000 -1000];
    
end

end
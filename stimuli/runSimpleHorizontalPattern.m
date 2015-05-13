function exitCode = runSimpleHorizontalPattern(expt)

createWindow(1.3476);

window = getWindow();

%% parameters

jitter = 5; % pixels

speed = 400; % px/sec

dir = power(-1, rand>0.5);

timeLimit = 3.5; % in seconds (0 to disable)

bugY = 0.75; % y-cord (0 to 1)

bugWidth = 100; % in units of px

bugHeight = 30; % in unis of px

bugFreq = 1/20; % bug spatial frequency in cppx

bugPhase = rand * 2 * pi; % bug spatial phase in rad

bugPatternType = 0; % 0 for sine wave, 1 for square wave

%% loading overrides

if nargin>0
    
    unpackStruct(expt);
    
end

%% create bug texture

x = meshgrid(1:bugWidth, 1:bugHeight);

sin2 = @(x) 0.5 + sin(x)/2;

bugPattern = sin2(x * bugFreq * 2 * pi + bugPhase);

if bugPatternType == 1
    
    bugPattern = bugPattern > 0.5;
    
end

bugTexture = Screen(window, 'MakeTexture', bugPattern * 255);

%% motion functions

[W, H] = getResolution();

X = @(t) dir * (t * speed);

Y = @(t) H * (bugY - 0.5);

XY = @(t) [X(t) Y(t)] + (rand(1, 2)-0.5) * jitter;

%% rendering

exitCode = 0;

startTime = GetSecs();

while 1
    
    t = GetSecs() - startTime;
    
    if (t > timeLimit) && (timeLimit ~= -1)
        
        break;
        
    end
    
    Screen(window, 'FillRect' , [0.5 0.5 0.5] * 255); 
    
    bugPos = XY(t);
    
    bugRect = [W H W H]/2 + [bugPos bugPos] + ...
        + [0 0 bugWidth bugHeight] - ...
        [bugWidth bugHeight bugWidth bugHeight]/2;
    
    Screen(window, 'DrawTexture', bugTexture, [], bugRect);
    
    Screen(window, 'Flip');
    
end

end
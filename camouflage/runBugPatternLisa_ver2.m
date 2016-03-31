% this is the same as runBugPatternLisa.m except that I changed speed units
% to pixel/sec and spatial freq to cycle/px (to match runGrating_ver2)

function runBugPatternLisa_ver2(args)

% parameters

fx = 2/80; % bug spatial frequency (cycle/px)

dir = power(-1, rand>0.5);

W = 80; % bug width (px)

escapeEnabled = 1; %#ok<NASGU>

bugPhase = 0;

tf = 8; % Hz

bugType = 1; % 0 for black, 1 for sinusoidal

if nargin>0
    
    unpackStruct(args);
    
end

%% calculations

speed_px_sec = tf / fx; % px/sec

%% generation background

backPattern = ones(500, 500) * 0.5; %#ok

%% generate pattern

% sinusoidal bug

px = -3*W:3*W;

[X, Y] = meshgrid(px, px);

bugSine = sin(X*2*pi*fx + bugPhase);

acAngle = W/2;

sigmax = acAngle / 2.34;

sigmay = sigmax / 2;

bugEnvelope = exp(-(X.^2)/(2*sigmax^2) - (Y.^2)/(2*sigmay^2));

if bugType
    
    % sine bug

    bugPattern = 0.5 + 0.5 * bugSine .* bugEnvelope; %#ok<NASGU>  
    
else
    
    % black bug
    
    bugPattern = 0.5 - 0.5 * bugEnvelope;
    
end    

%% render

previewPosFunction = 0;

[sW, sH] = getResolution();

[~, duration] = getPos(0, sW, sH, 1, speed_px_sec); %#ok<NASGU>

getBugPosition = @(t) getPos(t, sW, sH, dir, speed_px_sec); %#ok

if previewPosFunction
    
    t = linspace(0, duration, 1e4); %#ok<UNRCH>
    
    takeFirst = @(x) x(1);
    
    f1 = @(t) takeFirst(getBugPosition(t));
    
    pos = arrayfun(f1, t);
    
    plot(t, pos);

end

args2 = packWorkspace('bugPattern', 'getBugPosition', 'escapeEnabled', 'duration', 'backPattern');

runCamoPattern(args2);

end

function [pos, stimTime] = getPos(t, sW, sH, dir, speed_px_sec)

if ~isscalar(t)
    
    error('t must be a scalar');
    
end

travelDistance = sW + 400; % side to side

travelTime = travelDistance / speed_px_sec;

zigZagPeriod = travelTime * 4;

n = 2;

t0 = 1;

pos = [sW sH]/2 + dir * [1 0] * zigZag(t0, zigZagPeriod, n, t) * travelDistance;

stimTime = t0 + zigZagPeriod * n;

end

function s = zigZag(t0, period, n, t)

% a zig-zag oscillation function, starts at -1 and from t0 to (t0+period*n)
% oscillates with a period of `period`

% params

% t0 = 1; % initial delay
% 
% period = 10; % period of oscillation
% 
% n = 3; % number of oscillations
% 
% t = linspace(0, 50, 1e3);

% body

y = sawtooth((t-t0)/period*(2*pi), 0.5);

t1 = t0 + period * n;

w = (t>t0) .* (t<t1);

s = (y .* w) -1 * (1-w);

% plot(t, s);

end
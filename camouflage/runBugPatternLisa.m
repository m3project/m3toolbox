function runBugPatternLisa(args)

% parameters

fx = 2/80; % bug cycle/px

dir = power(-1, rand>0.5);

W = 80; % bug width (px)

escapeEnabled = 1; %#ok<NASGU>

bugPhase = 0;

viewD = 6; % cm

sf = 40; % px/cm

tf = 8; % Hz

bugType = 1; % 0 for black, 1 for sinusoidal

if nargin>0
    
    unpackStruct(args);
    
end

%% calculations

fx_cpd = 1/range(px2deg(1/fx, sf, viewD));

speed_deg_sec = tf / fx_cpd;

% speed_deg_sec = 74; % in degrees/sec

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

[~, duration] = getPos(0, sW, sH, 0, viewD, sf, speed_deg_sec); %#ok<NASGU>

if previewPosFunction
    
    t = linspace(0, duration, 1e3); %#ok<UNRCH>
    
    pos = getPos(t, sW, sH, dir, viewD, sf, speed_deg_sec);
    
    plot(t, pos);

end

getBugPosition = @(t) getPos(t, sW, sH, dir, viewD, sf, speed_deg_sec); %#ok

args2 = packWorkspace('bugPattern', 'getBugPosition', 'escapeEnabled', 'duration', 'backPattern');

runCamoPattern(args2);

end

function [pos, stimTime] = getPos(t, sW, sH, dir, viewD, sf, speed_deg_sec)

speed_px_sec = 2 * viewD * tand(speed_deg_sec/2) * sf;

travelDistance = sW + 400; % side to side

travelTime = travelDistance / speed_px_sec;

zigZagPeriod = travelTime * 2;

n = 2;

t0 = 1;

pos = [sW sH]/2 + ...
    dir * [1 0] * zigZag(t0, zigZagPeriod, n, t) * travelDistance;

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
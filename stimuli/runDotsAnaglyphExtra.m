% this is similar to runDotsAnaglyph but relies on a more generic RDS
% stimulus and can render a larger variety of stimuli
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 2/6/2016

function varargout = runDotsAnaglyphExtra(args)

% parameters

mode = 'debug';

staticCorr = 1;

crossed = 1 ; % 1 for corssed, 0 for uncrossed

%% prepare arguments

if nargin; unpackStruct(args); else args = struct; end

if isequal(mode, 'debug')
    
    args = setDots(args, 0, 0); % numbers are : isLarge, slowMode
    
    args = setFineDots(args);
    
%     args = setDebug(args); 
    
    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispBruce(ch, x, y, bugX, bugY, bugRad, G, D, crossed);
    
    args.lumFun1 = @getLumBruce;
    
    args.bugY = 0.65;
    
    args.v = 0;
    
    %args.lumFun1 = @getLumBlack; % use this to make all dots black
    
%     args.virtDm = 7;
    
%     args.bugRadius = 1.5;
    
elseif isequal(mode, 'bruce')
    
    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispBruce(ch, x, y, bugX, bugY, bugRad, G, D, crossed);
    
    args.lumFun1 = @getLumBruce;
    
else
    
    error('unsupported mode');
    
end

%% render

args.pairDots = staticCorr;

dotInfo = runDots(args);

if nargout; varargout{1} = dotInfo; end

end

%% Bruce Corr/Uncorr

% from Jenny's email (Tue 31/05/2016 20:42):

% As the target region (black dashed circle) moves around, the dots jump
% asymmetrically in the two eyes. In each eye, half the dots stay still and
% half jump by D (in opposite directions in each eye).
%
% You start with the left eye, say, and pick 50% of the dots at random to
% stay still while the others jump. Then in the right eye, this 50% of the
% dots jump while the others stay still.
%
% Cues:
%
% 1. static disparity: the offset of D between L and R dots
%
% 2. kinetic disparity (decorrelated: it agrees at the level of the whole
% target patch but is scrambled at the level of individual dots): the
% offset of D between the endpoints of the jump in left and right eyes (red
% and blue circles)

% 3. IOVD (decorrelated: again, it agrees at the level of the whole target
% patch but is scrambled at the level of individual dots): in the crossed
% condition, for example, L dots move R and R dots move L

function disp = getDispBruce ...
    (ch, x, y, bugX, bugY, bugRad, G, D, crossed)

edgeSmoothness = 0.8; % same as in runDotsAnaglyph

dispFun = @(adist) tansigAB(adist * edgeSmoothness, D, 0);

dispSign = (-1)^ch;

dispSign2 = ifelse(crossed, 1, -1);

% choose complement sets for left/right channels:

selGroup = ifelse(ch, G(:, 1), ~G(:, 1));

% now that when staticCorr=0 then G(:, 1) will refer to different dots in
% each channel (because dots themselves don't have correspondants)

adist = sqrt((x - bugX).^2 + (y - bugY).^2) - bugRad;

disp = dispFun(adist) .* selGroup * dispSign * dispSign2;

end

function lum = getLumBruce(~, ~, ~, ~, ~, ~, G, ~)

lum = G(:, 3);

end

function lum = getLumBlack(~, ~, ~, ~, ~, ~, G, ~)

lum = G(:, 3) * 0;

end

%% Jump Op/Same

% Jump Op = Kinetic + IOVD
% Jumo Same = Kinetic (only)

%% helper functions

function args = setDebug(args)

% set values to make debugging easier

args.preTrialDelay = -5;

args.finalPresentationTime = inf;

args.renderChannels = [0 1];

args.bugY = 0.5;

end

function args = setDots(args, isLarge, slowMode)

args.n = ifelse(isLarge, 1e3, 1e4); % number of dots  

args.r = ifelse(isLarge, 60, 20); % radius

args.v = ifelse(slowMode, 0.1, 2);

end

function args = setFineDots(args)

args.n = 5e3;

args.r = 20;

end

%% adapted from runDotAnaglyh

function disp = getDispDotAnaglyph(ch, x, y, bugX, bugY, bugRad, ~, D)

edgeSmoothness = 0.8; % same as in runDotsAnaglyph

dispFun = @(adist) tansigAB(adist * edgeSmoothness, D, 0);

adist = sqrt((x - bugX).^2 + (y - bugY).^2) - bugRad;

dispSign = (-1)^ch;

disp = x*0 + dispFun(adist)/2 * dispSign;

end

function y = tansig01(x)

y = (tansig(x)+1)/2;

end

function y = tansigAB(x, a, b)

y = tansig01(x) * (b-a) + a';

end
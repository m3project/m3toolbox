 % this is similar to runDotsAnaglyph but relies on a more generic RDS
% stimulus and can render a larger variety of stimuli
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 2/6/2016

function varargout = runDotsAnaglyphExtra(args)

% inDebug();

%% Vivek parameters

% any parameters in this section can be set by Vivek

mode = 'iovd-debug'; % Vivek can change this to fiddle

staticCorr = 1;

crossed = 1;
% 1 for crossed, 0 for uncrossed (with blue filter on left eye)
% 0 for crossed, 1 for uncrossed (with green filter on left eye)
    
iovd = 1;

rightVar = 1;
% when iovd = 0, rightVar refers to direction of dot jump
% when iovd = 1, rightVar refers to direction of initial offset

bugY = 0.7; %#ok<NASGU>

v = 2; %#ok<NASGU>

n = 1e4; %#ok<NASGU>

r = 20; %#ok<NASGU>

% lumFun1 = @getLumBlack; %#ok<NASGU> % use this to make all dots black

lumFun1 = @getLumBlackWhite; %#ok<NASGU> % use this to make dots black
% and white 
bugRadius = .5; %#ok<NASGU>

%% load overrides

if nargin; unpackStruct(args); end

%% pack parameters plus overrides

args = packWorkspace();

args.pairDots = staticCorr;

%% prepare arguments

if isequal(mode, 'debug')

    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispBruce(ch, x, y, bugX, bugY, bugRad, G, D, crossed);
    
elseif isequal(mode, 'bruce')
    
    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispBruce(ch, x, y, bugX, bugY, bugRad, G, D, crossed);
    
    args.lumFun1 = @getLumBlackWhite;
    
elseif isequal(mode, 'iovd-debug')
    
    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispKineticIOVD ...
        (ch, x, y, bugX, bugY, bugRad, G, D, iovd, crossed, rightVar);
    
elseif isequal(mode, 'iovd-recording')
    
    args = setDebug(args);
    
    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispKineticIOVD ...
        (ch, x, y, bugX, bugY, bugRad, G, D, iovd, crossed, rightVar);
    
    args.lumFun1 = @getLumBlack;
    
    args.plotTarget = [0 -1 1];
    
    args.finalPresentationTime = 30;
    
    args.interTrialTime = 0;
    
    args.n = 200;
    
    args.v = 0.2;
    
    args.enableKeyboard = 0;
    
    args.pairDots = 0; % this is staticCorr
    
elseif isequal(mode, 'iovd')
    
    args.dispFun1 = @(ch, x, y, bugX, bugY, bugRad, G, D) ...
        getDispKineticIOVD ...
        (ch, x, y, bugX, bugY, bugRad, G, D, iovd, crossed, rightVar);
    
else
    
    error('unsupported mode');
    
end

%% render

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

function disp = getDispBruce (ch, x, y, bugX, bugY, bugRad, G, D, crossed)

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

%% Jump Op/Same

% Jump Op = Kinetic + IOVD
% Jumo Same = Kinetic (only)

function disp = getDispKineticIOVD (ch, x, y, bugX, bugY, bugRad, ~, D, iovd, crossed, rightVar)

% NOTE:
% when iovd = 0, rightVar refers to direction of dot jump
% when iovd = 1, rightVar refers to direction of initial offset

edgeSmoothness = 0.8; % same as in runDotsAnaglyph

dispFun = @(adist) tansigAB(adist * edgeSmoothness, D, 0);

xtgt = 0; % dummy variable

jumpL = nan; %#ok<NASGU>
jumpR = nan; %#ok<NASGU>
xtgtL = nan; %#ok<NASGU>
xtgtR = nan; %#ok<NASGU>

% the below logic is a direct translation of Jenny's email
% (Tue 31/05/2016 20:42)

if iovd
    
    if crossed
        
        if rightVar == 1    
            xtgtL = xtgt+1/2;
            xtgtR = xtgt+1/2;
            jumpL = +1/2;
            jumpR = -1/2;            
        else
            xtgtL = xtgt-1/2;
            xtgtR = xtgt-1/2;
            jumpL = +1/2;
            jumpR = -1/2;            
        end
        
    else
        
        if rightVar == 1           
            xtgtL = xtgt+1/2;
			xtgtR = xtgt+1/2;
			jumpL = -1/2;
			jumpR = +1/2;            
        else            
            % Vivek and I confirmed that the below two lines (based on the
            % document emailed by Jenny) are incorrect:
            % xtgtL = xtgt+1/2; % INCORRECT
			% xtgtR = xtgt+1/2; % INCORRECT
            % We showed this to Jenny and she agreed this was incorrect            
            xtgtL = xtgt-1/2;
			xtgtR = xtgt-1/2;
			jumpL = -1/2;
			jumpR = +1/2;            
        end
        
    end
        
else
        
    if crossed
        
        if rightVar == 1            
			xtgtL = xtgt+1/2;
			xtgtR = xtgt-1/2;
			jumpL = +1/2;
			jumpR = +1/2;            
        else            
			xtgtL = xtgt+1/2;
			xtgtR = xtgt-1/2;
			jumpL = -1/2;
			jumpR = -1/2;            
        end
        
    else
        
        if rightVar == 1
            xtgtL = xtgt-1/2;
			xtgtR = xtgt+1/2;
			jumpL = +1/2;
			jumpR = +1/2;
        else
			xtgtL = xtgt-1/2;
			xtgtR = xtgt+1/2;
			jumpL = -1/2;
			jumpR = -1/2;
        end
        
    end
   
end

if any(isnan([jumpL jumpR xtgtL xtgtR]))
    
    error('stimulus parameters not properly defined')
    
end

isLeftChannel = (ch == 0);

bugOffset = ifelse(isLeftChannel, xtgtL, xtgtR) * D;

dispSign = ifelse(isLeftChannel, jumpL, jumpR);

% now that when staticCorr=0 then G(:, 1) will refer to different dots in
% each channel (because dots themselves don't have correspondants)

adist = sqrt((x - (bugX + bugOffset)).^2 + (y - bugY).^2) - bugRad;

disp = dispFun(adist) * dispSign;

end

%% helper functions

function args = setDebug(args)

% set values to make debugging easier

args.preTrialDelay = -5;

args.finalPresentationTime = inf;

args.renderChannels = [0 1];

args.bugY = 0.5;

end

function args = setDots(args, isLarge, slowMode) %#ok<DEFNU>

args.n = ifelse(isLarge, 1e3, 1e4); % number of dots  

args.r = ifelse(isLarge, 60, 20); % radius

args.v = ifelse(slowMode, 0.1, 2);

end

function args = setFineDots(args) %#ok<DEFNU>

args.n = 5e3;

args.r = 20;

end

%% adapted from runDotAnaglyh

function disp = getDispDotAnaglyph(ch, x, y, bugX, bugY, bugRad, ~, D) %#ok<DEFNU>

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

function lum = getLumBlackWhite(~, ~, ~, ~, ~, ~, G, ~)

lum = G(:, 3);

end

function lum = getLumBlack(~, ~, ~, ~, ~, ~, G, ~)

lum = G(:, 3) * 0;

end
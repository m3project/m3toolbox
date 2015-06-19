function StereoDemo3.backup

AssertOpenGL;

KbName('UnifyKeyNames');

scrnNum = max(Screen('Screens'));

PsychImaging('PrepareConfiguration');

PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1);

[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, 0, [], [], [], 100);
%[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, 0, [], [], [], 8);


% Stimulus settings:

numDots = 3000;
dotSize = 10;
dots = zeros(2, numDots);
dotspeed = 3;
tgtspeed = 3;
tgtdisp = 10;
tgtdisp2 = 12;

dotRad = 10;

W = RectWidth(windowRect);
H = RectHeight(windowRect);

% Initially fill left- and right-eye image buffer with black background
% color:
Screen('SelectStereoDrawBuffer', windowPtr, 0);
Screen('FillRect', windowPtr, BlackIndex(scrnNum));
Screen('SelectStereoDrawBuffer', windowPtr, 1);
Screen('FillRect', windowPtr, BlackIndex(scrnNum));

% Show cleared start screen:
Screen('Flip', windowPtr);

% Set up alpha-blending for smooth (anti-aliased) drawing of dots:
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

Screen('Flip', windowPtr);

% Run until a key is pressed:
pressed = 0;
tgtx = W*rand(1) ;
tgty = H*rand(1) ;

x = W*rand(1, numDots) ;
y = H*rand(1, numDots) ;
% Choose random colours

dotcol = unidrnd(256,1,numDots)-1;
%realdotcol = [1];

dotcol = repmat(dotcol, 3, 1);

%dotcol = realdotcol;

i=0;

tic;
        
        dots(1, :) = rand(size(dots(1, :))) * 1920;
        dots(2, :) = rand(size(dots(2, :))) * 540;
while ~pressed
    
    t = toc;
    
    i = i+1;
    
    %if i == 1

          
        dots(1, :) = rand(size(dots(1, :))) * 1920;
        dots(2, :) = rand(size(dots(2, :))) * 540; 
        %dots = [W H]' / 2;
        
    %end
    
    % Stop them going offscreen
    x(x>W+dotSize) = W;
    y(y>H+dotSize) = H;
    x(x<1-dotSize) = 1;
    y(y<1-dotSize) = 1;    
    
    dotsL=dots;
    dotsR=dots;
    dotsL(1,:) = dots(1,:)-tgtdisp/2;
    dotsR(1,:) = dots(1,:)+tgtdisp/2;
    % Add tgt disparity
    x=dots(1,:);
    y=dots(2,:);
    
    
    %radius = (1+sin(2*pi*t/5)) * 1000;
    
    radius = 500;
    
    %radius = 750 * (1-mod(t,12)/12);
    
    %radius = 600;
    
    if mod(i, 1) == 0
        tgtx = W/2 +  sin(2*pi*t/2) * radius;
        
        tgty = H/2 +  cos(2*pi*t/2) * radius/2;
        tgty = H/2;
    end
    
    
    if mod(i, 10) == 0
        
        %tgtyRandComp = (rand-0.5) * 10;
        tgtxRandComp = (rand-0.5) * 150;
        
    end
    
    
    if mod(i, 60 * 3) == 0
        
        %tgtyRandComp = (rand-0.5) * 10;
        %direction = round(rand) * 2 - 1;
        %   direction = -1 * direction;
        %  tgtx = nx/2;
        
    end
    
    
    %tgtx = tgtx + direction * 10; % + tgtxRandComp;
    
    
    
    %tgty = ny/2 + 150;
    
    %tgty = tgty + tgtyRandComp;
    s = 0.75;
    
    m1 = abs(x-tgtx) < 150 * s;
    m2 = abs(y-tgty) < 50 * s;
    
    
    
    bugRegion = find (m1 .* m2);
    
    %tgtdisp2 = tgtdisp * mod(1+t, 5);
    
    %tgtdisp2 = tgtdisp * 2;
    
    dotsL(1,bugRegion) = dots(1,bugRegion)+tgtdisp2/2;
    dotsR(1,bugRegion) = dots(1,bugRegion)-tgtdisp2/2;
    
    
    % Select left-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', windowPtr, 0);
    
    
    
    Screen('FillOval', windowPtr, 255, [dotsL; dotsL(1,:) + dotRad; dotsL(2,:)+dotRad/2]);
    
    
    % Select right-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', windowPtr, 1);
    
    % Draw right stim:
    %Screen('DrawDots', windowPtr, dotsR, dotSize, dotcol,[],2);
    Screen('FillOval', windowPtr, 255, [dotsR; dotsR(1,:) + dotRad; dotsR(2,:)+dotRad/2]);
    
    % Tell PTB drawing is finished for this frame:
    Screen('DrawingFinished', windowPtr);
    
    Screen('Flip', windowPtr);
    
    % Now all non-drawing tasks:
    
    % Keyboard queries and key handling:
    [pressed dummy keycode] = KbCheck;
    
    if pressed
        % ESCape key exits the demo:
        if keycode(KbName('ESCAPE'))
            break;
        end
    end
    
end

% Last Flip:
Screen('Flip', windowPtr);


% Done. Close the onscreen window:
Screen('CloseAll')



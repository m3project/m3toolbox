function StereoDemo2

AssertOpenGL;

% Define response key mappings, unify the names of keys across operating
% systems:
KbName('UnifyKeyNames');
space = KbName('space');
escape = KbName('ESCAPE');

%try
% Get the list of Screens and choose the one with the highest screen number.
% Screen 0 is, by definition, the display with the menu bar. Often when
% two monitors are connected the one without the menu bar is used as
% the stimulus display.  Chosing the display with the highest dislay number is
% a best guess about where you want the stimulus displayed.
scrnNum = max(Screen('Screens'));

% (following edit by Ghaith)
% Disable initial sync tests performed by PTB:
% these tests may flag an error when the the monitor
% resolution is not the same as the laptop's display.
% (the monitor reso must be at max for 3D to work)qqqq
Screen('Preference', 'SkipSyncTests', 1)

% Increase level of verbosity for debug purposes:
%Screen('Preference', 'Verbosity', 6);

% Open double-buffered onscreen window with the requested stereo mode,
% setup imaging pipeline for additional on-the-fly processing:

% Prepare pipeline for configuration. This marks the start of a list of
% requirements/tasks to be met/executed in the pipeline:
PsychImaging('PrepareConfiguration');

PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1);

% Consolidate the list of requirements (error checking etc.), open a
% suitable onscreen window and configure the imaging pipeline for that
% window according to our specs. The syntax is the same as for
% Screen('OpenWindow'):
[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, 0, [], [], [], 100);


% Stimulus settings:
numDots = 300;
dotSize = 10;
dots = zeros(2, numDots);
dotspeed = 3;
tgtspeed = 3;
tgtrotspeed = 2*pi/360 * 2;
tgtxdiam = 200;
tgtydiam = 50;
tgtdisp = 20;

dotRad = 40;

nx = RectWidth(windowRect);
ny = RectHeight(windowRect);

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

col1 = WhiteIndex(scrnNum);
col2 = col1;
i = 1;
keyIsDown = 0;
center = [0 0];

Screen('Flip', windowPtr);

% Maximum number of animation frames to show:
nmax = 100000;

% Perform a flip to sync us to vbl and take start-timestamp in t:
t = Screen('Flip', windowPtr);

% Run until a key is pressed:
pressed = 0;;
tgtx = nx*rand(1) ;
tgty = ny*rand(1) ;
tgtori  = rand(1)*2*pi;

x = nx*rand(1, numDots) ;
y = ny*rand(1, numDots) ;
% Choose random colours

realdotcol = unidrnd(256,1,numDots)-1;


realdotcol = repmat(realdotcol, 3, 1);

dotcol = realdotcol;
    


tic;
i=0;


dx = randn(1,numDots) * dotspeed;
dy = randn(1,numDots) * dotspeed;

tgt_dx = tgtspeed;
tgt_dy = tgtspeed;

randX = rand() * 100;
randY = rand() * 100;

tgtxRandComp = 0;
tgtyRandComp = 0;

direction = 1;

while ~pressed
    
    t = toc;
    
    i = i+1;
    
    if mod(i,10) == 0
        dx = randn(1,numDots) * dotspeed;
        dy = randn(1,numDots) * dotspeed;
        
        tgt_dx = randn(1) * tgtspeed;
        tgt_dy = randn(1) * tgtspeed;
    end
    
    % Random walk dot pattern
    
%     dots(1, :) = x + dx;
%     dots(2, :) = y + dy; 

if i > 0

    dots(1, :) = rand(size(dots(1, :))) * 1920;
    dots(2, :) = rand(size(dots(2, :))) * 540;
    
end
    
    % Stop them going offscreen
    x(x>nx+dotSize) = nx;
    y(y>ny+dotSize) = ny;
    x(x<1-dotSize) = 1;
    y(y<1-dotSize) = 1;

    % Tgt random walk
%     tgtx = tgtx + tgtspeed * randn(1);
%     tgty = tgty + tgtspeed * randn(1);
    
%     tgtx = tgtx + tgt_dx;
%     tgty = tgty + tgt_dy;
%     
%     if tgtx<1
%         tgtx=1;
%     end
%     if tgtx>nx
%         tgtx=nx;
%     end
%     if tgty<1
%         tgty=1;
%     end
%     if tgty>ny
%         tgty=ny;
%     end
    tgtori = tgtori + tgtrotspeed * randn(1);
    
    dotsL=dots;
    dotsR=dots;
    dotsL(1,:) = dots(1,:)-tgtdisp/2;
    dotsR(1,:) = dots(1,:)+tgtdisp/2;
    % Add tgt disparity
    x=dots(1,:);
    y=dots(2,:);
    
    jtgt = find( ((x-tgtx).*cos(tgtori)+(y-tgty).*sin(tgtori)).^2/tgtxdiam^2 + (-(x-tgtx).*sin(tgtori)+(y-tgty).*cos(tgtori)).^2/tgtydiam^2 < 1);
    
    jtgt = find( ((x-tgtx).*cos(tgtori)+(y-tgty).*sin(tgtori)).^2/tgtxdiam^2 + (-(x-tgtx).*sin(tgtori)+(y-tgty).*cos(tgtori)).^2/tgtydiam^2 < 1);
    
    radius = (1+sin(2*pi*t/5)) * 1000;
    
    
    radius = 750 * (1-mod(t,12)/12);
    
    %radius = 600;
    
    if mod(i, 1) == 0
        tgtx = nx/2 +  sin(2*pi*t/2) * radius;
    
        tgty = ny/2 +  cos(2*pi*t/2) * radius/2;
        tgtx = nx/2;
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
    
    m1 = abs(x-tgtx) < 50 * s;
    m2 = abs(y-tgty) < 50 * s;
    
    
    
    jtgt = find (m1 .* m2);
    
    %tgtdisp2 = tgtdisp * mod(1+t, 5);
    
    tgtdisp2 = tgtdisp * 2;
    
    dotsL(1,jtgt) = dots(1,jtgt)+tgtdisp2/2;
    dotsR(1,jtgt) = dots(1,jtgt)-tgtdisp2/2;
    
    %dotcol = realdotcol;
    
    %dotcol(1, jtgt) = 0;
    %dotcol(2, jtgt) = 0;
    %dotcol(3, jtgt) = 0;
    
    % Select left-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', windowPtr, 0);

    %scaleWindow([0 0], 1, 0.5);

    % Draw left stim:
    %size(dotsL)
    %size(dotcol)
    %Screen('DrawDots', windowPtr, dotsL, dotSize, dotcol,[],2);
    
    
    
    

    Screen('FillOval', windowPtr, dotcol, [dotsL; dotsL(1,:) + dotRad; dotsL(2,:)+dotRad/2]);
    
%    Screen('FillOval', windowPtr, dotcol, [100; 200; 300; 540]);
    
    
    % Select right-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', windowPtr, 1);

    % Draw right stim:
    %Screen('DrawDots', windowPtr, dotsR, dotSize, dotcol,[],2);
    %Screen('FillOval', windowPtr, dotcol, [dotsR; dotsR(1,:) + dotRad; dotsR(2,:)+dotRad/2]);
    
    % Tell PTB drawing is finished for this frame:
    Screen('DrawingFinished', windowPtr);

    % Now all non-drawing tasks:

    % Keyboard queries and key handling:
    [pressed dummy keycode] = KbCheck;
    if pressed
        % ESCape key exits the demo:
        if keycode(escape)
            break;
        end
    end

    % Flip stim to display and take timestamp of stimulus-onset after
    % displaying the new stimulus and record it in vector t:

    onset = Screen('Flip', windowPtr);
    t = [t onset];
    
    %scaleWindow([0 0], 1, 2);

end

% Last Flip:
Screen('Flip', windowPtr);


% Done. Close the onscreen window:
Screen('CloseAll')


% Compute and show timing statistics:
dt = t(2:end) - t(1:end-1);
disp(sprintf('N.Dots\tMean (s)\tMax (s)\t%%>20ms\t%%>30ms\n'));
disp(sprintf('%d\t%5.3f\t%5.3f\t%5.2f\t%5.2f\n', numDots, mean(dt), max(dt), sum(dt > 0.020)/length(dt), sum(dt > 0.030)/length(dt)));

% We're done.
return;
%catch
% Executes in case of an error: Closes onscreen window:
Screen('CloseAll');
psychrethrow(psychlasterror);
%end;


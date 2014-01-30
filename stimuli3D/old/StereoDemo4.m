function StereoDemo4
%% Initializations:

% checking for any existing windows

m = Screen('Windows');

if isempty(m)
    
    stereoMode = 100;
    
    AssertOpenGL;
    
    KbName('UnifyKeyNames');
    
    scrnNum = max(Screen('Screens'));
    
    PsychImaging('PrepareConfiguration');
    
    if stereoMode == 100
        
        PsychImaging('AddTask', 'General', 'InterleavedLineStereo', 0);
        
    end
    
    if stereoMode == 101
        
        PsychImaging('AddTask', 'General', 'InterleavedColumnStereo', 0);
        
    end
    
    if stereoMode == 102
        
        PsychImaging('AddTask', 'General', 'SideBySideCompressedStereo');
        
    end
    
    [window, windowRect] = PsychImaging('OpenWindow', scrnNum, 0, [], [], [], stereoMode);
    
    Screen('SelectStereoDrawBuffer', window, 0); Screen('FillRect', window, BlackIndex(scrnNum));
    
    Screen('SelectStereoDrawBuffer', window, 1); Screen('FillRect', window, BlackIndex(scrnNum));
    
    Screen('Flip', window);
    
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
else
    
    window = m(1);
    
    reso = Screen('Resolution', window);

    windowRect = [0 0 reso.width reso.height];
    
end

%% Stimulus settings:

stimSize    = 150;
stimSpeed   = 1;   % pix/frames
motionMode  = 2;    % (0) still (1) bouncing (2) circular (3) looming
dynamic     = 1;
popout      = 0;

numDots     = 5000;

dotSize     = 10;
dots        = zeros(3, numDots);

xmax = windowRect(3) / 2;
ymax = windowRect(4) / 2;

amp = 30;

dots(1, :) = (2*rand(1, numDots)-1) * xmax;
dots(2, :) = (2*rand(1, numDots)-1) * ymax;

dotcol = unidrnd(256,1,numDots)-1;
dotcol = repmat(dotcol, 3, 1);

col1 = 255; %WhiteIndex(scrnNum);
col2 = col1;

center = [0 0];
xvel = (2*rand-1) * stimSpeed;
yvel = (2*rand-1) * stimSpeed;

Screen('Flip', window);

tic;

i = 0;

while 1
    
    i = i+1;
    
    t = toc;
    
    disparityVector = [dots(3, :)/2; zeros(1, numDots)];
    
    
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('DrawDots', window, dots(1:2, :) - disparityVector, dotSize, dotcol, windowRect(3:4)/2, 1);
    
    pos = [dots(1:2, :) + disparityVector];
    
    rect = [pos; pos(1,:)+dotSize; pos(2,:)+dotSize/2];
    
    rect([1 3], :) = rect([1 3], :) + windowRect(3) / 2;
    
    rect([2 4], :) = rect([2 4], :) + windowRect(4) / 2;
    
    %Screen('FillRect', window, BlackIndex(window));
    
    %Screen('FillOval', window, col1, rect);
    
    
    
    
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('DrawDots', window, dots(1:2, :) + disparityVector, dotSize, dotcol, windowRect(3:4)/2, 1);
    
    pos = [dots(1:2, :) - disparityVector];
    
    rect = [pos; pos(1,:)+dotSize; pos(2,:)+dotSize/2];
    
    rect([1 3], :) = rect([1 3], :) + windowRect(3) / 2;
    
    rect([2 4], :) = rect([2 4], :) + windowRect(4) / 2;

    
   % Screen('FillRect', window, BlackIndex(window));
    
    
  %  Screen('FillOval', window, col1, rect);
    
    
    Screen('DrawingFinished', window);
    
    if dynamic && mod(i, 2) == 0
        dots(1, :) = (2*rand(1, numDots)-1) * xmax;
        dots(2, :) = (2*rand(1, numDots)-1) * ymax;
    end
    
    switch (motionMode)
        
        case 0 % still           
            
            
        case 1 % bounce            
            
            center = center + [xvel yvel];
            
            if center(1) > xmax || center(1) < -xmax
                xvel = -xvel;
            end
            
            if center(2) > ymax || center(2) < -ymax
                yvel = -yvel;
            end
            
        case 2 % circular            
            
            radius = 300; % pixels
            
            period = 30/stimSpeed; % seconds
            
            a = t/period*2*pi;
            
            center = [sin(a) cos(a)/2] * radius;
            
        case 3 % looming            
            
            approachSpeed = 5;
            
            t2 = mod(t*approachSpeed, 25);
            
            t2 = min(t2, 5);
            
            stimSize = 100 / (5.5 - t2);
            
         case 4 % swirl
            
            radius = (5-mod(t, 5)) * 300; % pixels
            
            period = 30/stimSpeed; % seconds
            
            a = t/period*2*pi;
            
            center = [sin(a) cos(a)] * radius;
                        

    end
    
    %dots(3, :) = -amp.*exp(-(dots(1, :) - center(1)).^2 / (2*stimSize*stimSize)).*exp(-(dots(2, :) - center(2)).^2 / (2*stimSize*stimSize));
    
    %dots(3, :) = -dots(3, :) + 10;
    
    x = abs(pos(1, :) - center(1));
    y = abs(pos(2, :) - center(2));
    
    k = find( sqrt(x.^2 + (y*2).^2) < stimSize);
    
    pos(1, k) = 0;
    pos(2, k) = 0;
    
    dots(3, :) = 5;
    
    dots(3, k) = 25;
    
    size(k)
    
    if popout
        
        dots(3, :) = dots(3, :) * 0;
        
        t2 = mod(t, 3);
        
        t2 = min(t2, 0.4);
    
        dots(3, :) = dots(3, :) +  50 * t2;
    
    end
    
    [pressed dummy keycode] = KbCheck;
    
    if pressed
        
        if keycode(KbName('ESCAPE'))
            
            break;
            
        end
        
    end
    
    Screen('Flip', window);
    
end

%% Finish

Screen('Flip', window);

Screen('CloseAll')

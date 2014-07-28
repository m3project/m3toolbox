function StereoDemo3
%% Initialization

AssertOpenGL;

KbName('UnifyKeyNames');

scrnNum = max(Screen('Screens'));

PsychImaging('PrepareConfiguration');

PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1);

[window, windowRect]=PsychImaging('OpenWindow', scrnNum, 0, [], [], [], 100);

W = RectWidth(windowRect);

H = RectHeight(windowRect);

Screen('SelectStereoDrawBuffer', window, 0);

Screen('FillRect', window, BlackIndex(scrnNum));

Screen('SelectStereoDrawBuffer', window, 1);

Screen('FillRect', window, BlackIndex(scrnNum));

Screen('Flip', window);

Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

Screen('Flip', window);

%% Stimulus Settings

numDots         = 1000;
dotRad          = 30;
disparityBack   = -10; % minus for out of screen, plus for in screen
disparityBug    = 10; 
frameSkip       = 0;
bugSize         = .5;
motionMode      = 2;
w=200;
l=100;

switch motionMode
    
    case 1 % circle
        
        center = [W/2 H/2];
        
        frequency   = 0.75;
        
        radius = @(t) 400;
        
        bugFunctionX = @(t) center(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY = @(t) center(2) +  cos(2*pi*t*frequency) * radius(t)/2;
        
    case 2 % swirl
        
           
        center = [W/2 H/2];
        
        frequency   = .5;
        
        radius = @(t) (1 - mod(t/5,1)) * 400;
        
        bugFunctionX = @(t) center(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY = @(t) center(2) +  cos(2*pi*t*frequency) * radius(t)/2;        
        
    case 3 % horizontal
        
        center = [W/2 H/2+100];
        
        frequency   = 0.5;
        
        radius = @(t) 400;
        
        bugFunctionX = @(t) center(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY = @(t) center(2);
        
               
    case 4 % vertical
        
        center = [W/2 H/2];
        
        frequency   = 0.25;
        
        radius = @(t) 400;
        
        bugFunctionX = @(t) center(1);
        
        bugFunctionY = @(t) center(2) +  cos(2*pi*t*frequency) * radius(t)/2; 
        
        w=100;
        l=150;
    
    otherwise % still
        
        bugFunctionX = @(t) W/2;
        bugFunctionY = @(t) H/2;        
        
        
end

dots = [W 0; 0 H] * rand(2, numDots); % initialize dots as random 2xnumDots

i=0;

tic;

while 1
    
    i = i+1;
    
    t = toc;    
    
    if mod(i, frameSkip+1) == 0
        
        dots = [W 0; 0 H] * rand(2, numDots); % initialize dots as random 2xnumDots
        
    end
    
    dotsL = dots;
    dotsR = dots;
    
    dotsL(1,:) = dots(1,:) - disparityBack/2;
    dotsR(1,:) = dots(1,:) + disparityBack/2;
    
    if (i==1) || mod(i, frameSkip+1) == 0
        
        bugX = bugFunctionX(t);
        bugY = bugFunctionY(t);
        
    end

    m1 = abs(dots(1, :)-bugX) < w * bugSize;
    m2 = abs(dots(2, :)-bugY) < l/2 * bugSize;
    
    
    bugRegion = find (m1 .* m2);
%      bugRegion =[];
    dotsL(1,bugRegion) = dots(1,bugRegion) - disparityBug/2;
    dotsR(1,bugRegion) = dots(1,bugRegion) + disparityBug/2;
    
    
    Screen('SelectStereoDrawBuffer', window, 0);    
    
    Screen('FillOval', window, 255, [dotsL; dotsL(1,:) + dotRad; dotsL(2,:)+dotRad/2]);
    
    Screen('SelectStereoDrawBuffer', window, 1);    
    
    Screen('FillOval', window, 255, [dotsR; dotsR(1,:) + dotRad; dotsR(2,:)+dotRad/2]);

    Screen('DrawingFinished', window);
    
    Screen('Flip', window);    
    
    [pressed dummy keycode] = KbCheck;
    
    if pressed
        if keycode(KbName('ESCAPE'))
            break;
        end
    end
    
end

%% Finish

Screen('CloseAll')
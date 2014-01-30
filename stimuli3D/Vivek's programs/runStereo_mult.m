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

numDots         = 10000;
dotRad          = 15;
disparityBack   = 5; % minus for out of screen, plus for in screen
disparityBug    = -5; 
frameSkip       = 0;
bugSize         = .9;
motionMode      =2;
w=50;
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
        
        center2=[W/2+50 H/2-100];
        
        center3=[W/2-30 H/2+70];
        
        frequency   = .5;
        
        radius = @(t) (1 - mod(t/5,1)) * 400;
        
        bugFunctionX = @(t) center(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY = @(t) center(2) +  cos(2*pi*t*frequency) * radius(t)/2+100;        
        
         bugFunctionX2 = @(t) center2(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY2 = @(t) center2(2) +  cos(2*pi*t*frequency) * radius(t)/2+100;  
        
         bugFunctionX3 = @(t) center3(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY3 = @(t) center3(2) +  cos(2*pi*t*frequency) * radius(t)/2+100;  
        
    case 3 % horizontal
        
        center = [W/2 H/2];
        
        center2=[W/2+50 H/2];
        
        center3=[W/2-30 H/2+75];
        
        frequency   = 0.5;
        
        radius = @(t) 400;
        
        bugFunctionX = @(t) center(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY = @(t) center(2);
        
        bugFunctionX2 = @(t) center2(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY2 = @(t) center2(2);
        
        bugFunctionX3 = @(t) center3(1) +  sin(2*pi*t*frequency) * radius(t);
        
        bugFunctionY3 = @(t) center3(2);
        
               
    case 4 % vertical
        
        center = [W/2 H/2];
        
        frequency   = 0.5;
        
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
        
        bug2X = bugFunctionX2(t);
        bug2Y = bugFunctionY2(t);
        
        bug3X = bugFunctionX3(t);
        bug3Y = bugFunctionY3(t);
%         
    end

    m1 = abs(dots(1, :)-bugX) < w * bugSize;
    m2 = abs(dots(2, :)-bugY) < l/2 * bugSize;
    
    m1_2 = abs(dots(1, :)-bug2X) < w * bugSize;
    m2_2 = abs(dots(2, :)-bug2Y) < l/2 * bugSize;
    
    m1_3 = abs(dots(1, :)-bug3X) < w * bugSize;
    m2_3 = abs(dots(2, :)-bug3Y) < l/2 * bugSize;
    
    
    bugRegion = find (m1 .* m2);
    bug2Region = find (m1_2 .* m2_2);
    bug3Region = find (m1_3 .* m2_3);
    
%     bugRegion =[];

    dotsL(1,bugRegion) = dots(1,bugRegion) - disparityBug/2;
    dotsR(1,bugRegion) = dots(1,bugRegion) + disparityBug/2;
    
    dotsL(1,bug2Region) = dots(1,bug2Region) - disparityBug/2;
    dotsR(1,bug2Region) = dots(1,bug2Region) + disparityBug/2;
    
    dotsL(1,bug3Region) = dots(1,bug3Region) - disparityBug/2;
    dotsR(1,bug3Region) = dots(1,bug3Region) + disparityBug/2;
    
    
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
%This function presents camouflaged columns that move across 
%the screen horizontally to the viewer. The columns are initally presented 
%stationary and then start moving in the specified direction.

function [t exitCode] = runStereo_columns(expt)
%% Initialization

Screen('Preference', 'VisualDebuglevel', 3); %disabling the welcome screen

AssertOpenGL;

KbName('UnifyKeyNames');

scrnNum =  max(Screen('Screens'));

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
bugSize         =1;
motionMode      =1;
timeLimit = -1;
direction=-1; % specifying direction of movement: 1 for right, -1 for left.
columnSpace=200; %distance between columns
rf=400; %rate factor
rt=2; %reset time
startPoint=W/2;
w=20;
l=H;

centery=H/2;
centery2=H/2;
centery3=H/2;
centery4=H/2;
centery5=H/2;
centery6=H/2;
centery7=H/2;
centery8=H/2;
centery9=H/2;
centery10=H/2;
centery11=H/2;

%running stationary part of the stimulus

timeLimit_stat=5;

bugFunctionX = @(t) startPoint;
bugFunctionY = @(t) centery;
bugFunctionX2 = @(t) columnSpace+startPoint;
bugFunctionY2 = @(t) centery2;
bugFunctionX3 = @(t) -columnSpace+startPoint ;
bugFunctionY3 = @(t) centery3;
bugFunctionX4 = @(t) (2*columnSpace)+startPoint  ;
bugFunctionY4 = @(t) centery4;
bugFunctionX5 = @(t) -(2*columnSpace)+startPoint  ;
bugFunctionY5 = @(t) centery5;
bugFunctionX6 = @(t) (3*columnSpace)+startPoint  ;
bugFunctionY6 = @(t) centery6;
bugFunctionX7 = @(t) -(3*columnSpace)+startPoint  ;
bugFunctionY7 = @(t) centery7;
bugFunctionX8 = @(t) (4*columnSpace)+startPoint  ;
bugFunctionY8 = @(t) centery8;
bugFunctionX9 = @(t) -(4*columnSpace)+startPoint  ;
bugFunctionY9 = @(t) centery9;
bugFunctionX10 = @(t) (5*columnSpace)+startPoint  ;
bugFunctionY10 = @(t) centery10;
bugFunctionX11 = @(t) -(5*columnSpace)+startPoint  ;
bugFunctionY11 = @(t) centery11;


dots = [W 0; 0 H] * rand(2, numDots); % initialize dots as random 2xnumDots

i=0;

tic;

while 1
    
    i = i+1;
    
    t = toc;
    
    if (timeLimit_stat > -1)
        
        if (t >= timeLimit_stat)
            
            break;
            
        end
        
    end
    
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
        
        bug4X = bugFunctionX4(t);
        bug4Y = bugFunctionY4(t);
        
        bug5X = bugFunctionX5(t);
        bug5Y = bugFunctionY5(t);
        
        bug6X = bugFunctionX6(t);
        bug6Y = bugFunctionY6(t);
        
        bug7X = bugFunctionX7(t);
        bug7Y = bugFunctionY7(t);
        
        bug8X = bugFunctionX8(t);
        bug8Y = bugFunctionY8(t);
        
        bug9X = bugFunctionX9(t);
        bug9Y = bugFunctionY9(t);
        
        bug10X = bugFunctionX10(t);
        bug10Y = bugFunctionY10(t);
        
        bug11X = bugFunctionX11(t);
        bug11Y = bugFunctionY11(t);
        %
    end
    
    m1 = abs(dots(1, :)-bugX) < w * bugSize;
    m2 = abs(dots(2, :)-bugY) < l/2 * bugSize;
    
    m1_2 = abs(dots(1, :)-bug2X) < w * bugSize;
    m2_2 = abs(dots(2, :)-bug2Y) < l/2 * bugSize;
    
    m1_3 = abs(dots(1, :)-bug3X) < w * bugSize;
    m2_3 = abs(dots(2, :)-bug3Y) < l/2 * bugSize;
    
    m1_4 = abs(dots(1, :)-bug4X) < w * bugSize;
    m2_4 = abs(dots(2, :)-bug4Y) < l/2 * bugSize;
    
    m1_5 = abs(dots(1, :)-bug5X) < w * bugSize;
    m2_5 = abs(dots(2, :)-bug5Y) < l/2 * bugSize;
    
    m1_6 = abs(dots(1, :)-bug6X) < w * bugSize;
    m2_6 = abs(dots(2, :)-bug6Y) < l/2 * bugSize;
    
    m1_7 = abs(dots(1, :)-bug7X) < w * bugSize;
    m2_7 = abs(dots(2, :)-bug7Y) < l/2 * bugSize;
    
    m1_8 = abs(dots(1, :)-bug8X) < w * bugSize;
    m2_8 = abs(dots(2, :)-bug8Y) < l/2 * bugSize;
    
    m1_9 = abs(dots(1, :)-bug9X) < w * bugSize;
    m2_9 = abs(dots(2, :)-bug9Y) < l/2 * bugSize;
    
    m1_10 = abs(dots(1, :)-bug10X) < w * bugSize;
    m2_10 = abs(dots(2, :)-bug10Y) < l/2 * bugSize;
    
    m1_11 = abs(dots(1, :)-bug11X) < w * bugSize;
    m2_11 = abs(dots(2, :)-bug11Y) < l/2 * bugSize;
    
    bugRegion = find (m1 .* m2);
    bug2Region = find (m1_2 .* m2_2);
    bug3Region = find (m1_3 .* m2_3);
    bug4Region = find (m1_4 .* m2_4);
    bug5Region = find (m1_5 .* m2_5);
    bug6Region = find (m1_6 .* m2_6);
    bug7Region = find (m1_7 .* m2_7);
    bug8Region = find (m1_8 .* m2_8);
    bug9Region = find (m1_9 .* m2_9);
    bug10Region = find (m1_10 .* m2_10);
    bug11Region = find (m1_11 .* m2_11);
    
    
    dotsL(1,bugRegion) = dots(1,bugRegion) - disparityBug/2;
    dotsR(1,bugRegion) = dots(1,bugRegion) + disparityBug/2;
    
    dotsL(1,bug2Region) = dots(1,bug2Region) - disparityBug/2;
    dotsR(1,bug2Region) = dots(1,bug2Region) + disparityBug/2;
    
    dotsL(1,bug3Region) = dots(1,bug3Region) - disparityBug/2;
    dotsR(1,bug3Region) = dots(1,bug3Region) + disparityBug/2;
    
    dotsL(1,bug4Region) = dots(1,bug4Region) - disparityBug/2;
    dotsR(1,bug4Region) = dots(1,bug4Region) + disparityBug/2;
    
    dotsL(1,bug5Region) = dots(1,bug5Region) - disparityBug/2;
    dotsR(1,bug5Region) = dots(1,bug5Region) + disparityBug/2;
    
    dotsL(1,bug6Region) = dots(1,bug6Region) - disparityBug/2;
    dotsR(1,bug6Region) = dots(1,bug6Region) + disparityBug/2;
    
    dotsL(1,bug7Region) = dots(1,bug7Region) - disparityBug/2;
    dotsR(1,bug7Region) = dots(1,bug7Region) + disparityBug/2;
    
    dotsL(1,bug8Region) = dots(1,bug8Region) - disparityBug/2;
    dotsR(1,bug8Region) = dots(1,bug8Region) + disparityBug/2;
    
    dotsL(1,bug9Region) = dots(1,bug9Region) - disparityBug/2;
    dotsR(1,bug9Region) = dots(1,bug9Region) + disparityBug/2;
    
    dotsL(1,bug10Region) = dots(1,bug10Region) - disparityBug/2;
    dotsR(1,bug10Region) = dots(1,bug10Region) + disparityBug/2;
    
    dotsL(1,bug11Region) = dots(1,bug11Region) - disparityBug/2;
    dotsR(1,bug11Region) = dots(1,bug11Region) + disparityBug/2;
    
    
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


%running the movement part of the stimulus



if nargin>0
    if isfield(expt, 'timeLimit')
        
        timeLimit = expt.timeLimit;
        
    end
    
    if isfield(expt, 'motionMode')
        
        motionMode = expt.motionMode;
        
    end
    
    if isfield(expt, 'direction')
        
        direction = expt.direction;
        
    end
    
    if isfield(expt, 'W')
        
        W = expt.W;
        
    end
    
    if isfield(expt, 'H')
        
        H = expt.H;
        
    end
    
    if isfield(expt, 'window')
        
        H = expt.window;
        
    end
end

switch motionMode
    
    
    case 1 % horizontal
        
            
        centerx = @(t) direction*rf*mod(t,rt)+startPoint;
        centerx2 = @(t) direction*rf*mod(t,rt)+columnSpace+startPoint ;
        centerx3= @(t) direction*rf*mod(t,rt)-columnSpace+startPoint;
        centerx4 = @(t) direction*rf*mod(t,rt)+(2*columnSpace)+startPoint ;
        centerx5 = @(t) direction*rf*mod(t,rt)-(2*columnSpace)+startPoint;
        centerx6 = @(t) direction*rf*mod(t,rt)+(3*columnSpace)+startPoint;
        centerx7 = @(t) direction*rf*mod(t,rt)-(3*columnSpace)+startPoint;
        centerx8 = @(t) direction*rf*mod(t,rt)+(4*columnSpace)+startPoint;
        centerx9 = @(t) direction*rf*mod(t,rt)-(4*columnSpace)+startPoint;
        centerx10 = @(t) direction*rf*mod(t,rt)+(5*columnSpace)+startPoint;
        centerx11 = @(t) direction*rf*mod(t,rt)-(5*columnSpace)+startPoint;
        
        bugFunctionX = @(t) centerx(t);
        bugFunctionY = @(t) centery;
        bugFunctionX2 = @(t) centerx2(t);
        bugFunctionY2 = @(t) centery2;
        bugFunctionX3 = @(t) centerx3(t) ;
        bugFunctionY3 = @(t) centery3;
        bugFunctionX4 = @(t) centerx4(t) ;
        bugFunctionY4 = @(t) centery4;
        bugFunctionX5 = @(t) centerx5(t) ;
        bugFunctionY5 = @(t) centery5;
        bugFunctionX6 = @(t) centerx6(t) ;
        bugFunctionY6 = @(t) centery6;
        bugFunctionX7 = @(t) centerx7(t) ;
        bugFunctionY7 = @(t) centery7;
        bugFunctionX8 = @(t) centerx8(t) ;
        bugFunctionY8 = @(t) centery8;
        bugFunctionX9 = @(t) centerx9(t) ;
        bugFunctionY9 = @(t) centery9;
        bugFunctionX10 = @(t) centerx10(t) ;
        bugFunctionY10 = @(t) centery10;
        bugFunctionX11 = @(t) centerx11(t) ;
        bugFunctionY11 = @(t) centery11;
        
    otherwise % still
                
        bugFunctionX = @(t) startPoint;
        bugFunctionY = @(t) centery;
        bugFunctionX2 = @(t) columnSpace+startPoint;
        bugFunctionY2 = @(t) centery2;
        bugFunctionX3 = @(t) -columnSpace+startPoint ;
        bugFunctionY3 = @(t) centery3;
        bugFunctionX4 = @(t) (2*columnSpace)+startPoint  ;
        bugFunctionY4 = @(t) centery4;
        bugFunctionX5 = @(t) -(2*columnSpace)+startPoint  ;
        bugFunctionY5 = @(t) centery5;
        bugFunctionX6 = @(t) (3*columnSpace)+startPoint  ;
        bugFunctionY6 = @(t) centery6;
        bugFunctionX7 = @(t) -(3*columnSpace)+startPoint  ;
        bugFunctionY7 = @(t) centery7;
        bugFunctionX8 = @(t) (4*columnSpace)+startPoint  ;
        bugFunctionY8 = @(t) centery8;
        bugFunctionX9 = @(t) -(4*columnSpace)+startPoint  ;
        bugFunctionY9 = @(t) centery9;
        bugFunctionX10 = @(t) (5*columnSpace)+startPoint  ;
        bugFunctionY10 = @(t) centery10;
        bugFunctionX11 = @(t) -(5*columnSpace)+startPoint  ;
        bugFunctionY11 = @(t) centery11;
        
        
end



dots = [W 0; 0 H] * rand(2, numDots); % initialize dots as random 2xnumDots

i=0;

tic;

while 1
    
    i = i+1;
    
    t = toc;
    
    if (timeLimit > -1)
        
        if (t >= timeLimit)
            
            break;
            
        end
        
    end
    
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
        
        bug4X = bugFunctionX4(t);
        bug4Y = bugFunctionY4(t);
        
        bug5X = bugFunctionX5(t);
        bug5Y = bugFunctionY5(t);
        
        bug6X = bugFunctionX6(t);
        bug6Y = bugFunctionY6(t);
        
        bug7X = bugFunctionX7(t);
        bug7Y = bugFunctionY7(t);
        
        bug8X = bugFunctionX8(t);
        bug8Y = bugFunctionY8(t);
        
        bug9X = bugFunctionX9(t);
        bug9Y = bugFunctionY9(t);
        
        bug10X = bugFunctionX10(t);
        bug10Y = bugFunctionY10(t);
        
        bug11X = bugFunctionX11(t);
        bug11Y = bugFunctionY11(t);
        %
    end
    
    m1 = abs(dots(1, :)-bugX) < w * bugSize;
    m2 = abs(dots(2, :)-bugY) < l/2 * bugSize;
    
    m1_2 = abs(dots(1, :)-bug2X) < w * bugSize;
    m2_2 = abs(dots(2, :)-bug2Y) < l/2 * bugSize;
    
    m1_3 = abs(dots(1, :)-bug3X) < w * bugSize;
    m2_3 = abs(dots(2, :)-bug3Y) < l/2 * bugSize;
    
    m1_4 = abs(dots(1, :)-bug4X) < w * bugSize;
    m2_4 = abs(dots(2, :)-bug4Y) < l/2 * bugSize;
    
    m1_5 = abs(dots(1, :)-bug5X) < w * bugSize;
    m2_5 = abs(dots(2, :)-bug5Y) < l/2 * bugSize;
    
    m1_6 = abs(dots(1, :)-bug6X) < w * bugSize;
    m2_6 = abs(dots(2, :)-bug6Y) < l/2 * bugSize;
    
    m1_7 = abs(dots(1, :)-bug7X) < w * bugSize;
    m2_7 = abs(dots(2, :)-bug7Y) < l/2 * bugSize;
    
    m1_8 = abs(dots(1, :)-bug8X) < w * bugSize;
    m2_8 = abs(dots(2, :)-bug8Y) < l/2 * bugSize;
    
    m1_9 = abs(dots(1, :)-bug9X) < w * bugSize;
    m2_9 = abs(dots(2, :)-bug9Y) < l/2 * bugSize;
    
    m1_10 = abs(dots(1, :)-bug10X) < w * bugSize;
    m2_10 = abs(dots(2, :)-bug10Y) < l/2 * bugSize;
    
    m1_11 = abs(dots(1, :)-bug11X) < w * bugSize;
    m2_11 = abs(dots(2, :)-bug11Y) < l/2 * bugSize;
    
    bugRegion = find (m1 .* m2);
    bug2Region = find (m1_2 .* m2_2);
    bug3Region = find (m1_3 .* m2_3);
    bug4Region = find (m1_4 .* m2_4);
    bug5Region = find (m1_5 .* m2_5);
    bug6Region = find (m1_6 .* m2_6);
    bug7Region = find (m1_7 .* m2_7);
    bug8Region = find (m1_8 .* m2_8);
    bug9Region = find (m1_9 .* m2_9);
    bug10Region = find (m1_10 .* m2_10);
    bug11Region = find (m1_11 .* m2_11);
    
    
    dotsL(1,bugRegion) = dots(1,bugRegion) - disparityBug/2;
    dotsR(1,bugRegion) = dots(1,bugRegion) + disparityBug/2;
    
    dotsL(1,bug2Region) = dots(1,bug2Region) - disparityBug/2;
    dotsR(1,bug2Region) = dots(1,bug2Region) + disparityBug/2;
    
    dotsL(1,bug3Region) = dots(1,bug3Region) - disparityBug/2;
    dotsR(1,bug3Region) = dots(1,bug3Region) + disparityBug/2;
    
    dotsL(1,bug4Region) = dots(1,bug4Region) - disparityBug/2;
    dotsR(1,bug4Region) = dots(1,bug4Region) + disparityBug/2;
    
    dotsL(1,bug5Region) = dots(1,bug5Region) - disparityBug/2;
    dotsR(1,bug5Region) = dots(1,bug5Region) + disparityBug/2;
    
    dotsL(1,bug6Region) = dots(1,bug6Region) - disparityBug/2;
    dotsR(1,bug6Region) = dots(1,bug6Region) + disparityBug/2;
    
    dotsL(1,bug7Region) = dots(1,bug7Region) - disparityBug/2;
    dotsR(1,bug7Region) = dots(1,bug7Region) + disparityBug/2;
    
    dotsL(1,bug8Region) = dots(1,bug8Region) - disparityBug/2;
    dotsR(1,bug8Region) = dots(1,bug8Region) + disparityBug/2;
    
    dotsL(1,bug9Region) = dots(1,bug9Region) - disparityBug/2;
    dotsR(1,bug9Region) = dots(1,bug9Region) + disparityBug/2;
    
    dotsL(1,bug10Region) = dots(1,bug10Region) - disparityBug/2;
    dotsR(1,bug10Region) = dots(1,bug10Region) + disparityBug/2;
    
    dotsL(1,bug11Region) = dots(1,bug11Region) - disparityBug/2;
    dotsR(1,bug11Region) = dots(1,bug11Region) + disparityBug/2;
    
    
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

function runTarget
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

backColor       = 255;
bugColor        = 1;
dotRad = 100;
Xbound = W/3;
Ybound = .5*H;
% t2 = @(t) -min(mod(t, 1), 1)+1;
% stepSize = @(t) t2(t)*10;
stepSize = @(t) 10;
motionMode = 1;


switch motionMode
    
    case 1 %3D target
        disparity = 10;
        
        
    otherwise % 2D target
        
        disparity = 0;
        
end

a = [1 , -1];

posnX = W/2;

posnY = .75*H;

i=0;

tstart=GetSecs;

while 1
    
    i = i+1;
    
    t = GetSecs-tstart;
    
    if posnX < Xbound
        
        posnX=W/2;
        
    elseif posnX > (W-Xbound)
        
        posnX =W/2;
        
    end
    
    if posnY < Ybound
        
        posnY = .85*H;
        
    elseif posnY > H
        
        posnY =.75*H;
        
    end
    
    dots = [posnX; posnY] - [dotRad; dotRad/2];
    d = disparity;
    
    dotsL = dots;
    dotsR = dots;
    
    dotsL(1,:) = dots(1,:) - d/2;
    dotsR(1,:) = dots(1,:) + d/2;
    
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('FillRect', window, backColor);
    
    Screen('FillOval', window, bugColor, [dotsL; dotsL(1,:) + dotRad; dotsL(2,:)+dotRad/2]);
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('FillRect', window, backColor);
    
    Screen('FillOval', window, bugColor, [dotsR; dotsR(1,:) + dotRad; dotsR(2,:)+dotRad/2]);
    
    Screen('DrawingFinished', window);
    
    Screen('Flip', window);
    
    ind = randperm(2);
    
    dirX = a(ind(1));
    
    ind = randperm(2);
    
    dirY = a(ind(1));
    posnX = posnX + dirX*stepSize(t);
    
    posnY= posnY + dirY*stepSize(t);
    
    
    [pressed dummy keycode] = KbCheck;
    
    if pressed
        if keycode(KbName('ESCAPE'))
            break;
        end
    end
    
end

%% Finish

Screen('CloseAll')
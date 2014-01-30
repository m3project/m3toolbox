function runLoom
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
motionMode      = 1;

switch motionMode
    
    case 1 % looming in 3D
        
        t2 = @(t) min(mod(t, 8), 1)+4;
        
        f1 = @(t) 12 / (20.02-4*t2(t));
        
        disparity = @(t) f1(t)/10;        
        
        radFunc = @(t) 80;
        
    otherwise % looming in 2D
        
        disparity = @(t) 0;
        
        t2 = @(t) min(mod(t, 8), 1)+4;
%         
%           f1 = @(t) 12 / (20.02-4*t2(t));
%         
%         disparity = @(t) f1(t)/20;       
        
        radFunc = @(t) 8 / (20.02-4*t2(t));
        
     
        %t2 = @(t) min(mod(t/2.5, 2), 1); radFunc = @(t) 6 * 12 ./ (4.2-4*t2(t));
        
end

i=0;

tic;

while 1
    
    i = i+1;
    
    t = toc;    
    
    dotRad = radFunc(t);
    
    dots = [W; H]/2 - [dotRad; dotRad/2]/2;
    
    d = disparity(t);
    
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
    
    [pressed dummy keycode] = KbCheck;
    
    if pressed
        if keycode(KbName('ESCAPE'))
            break;
        end
    end
    
end

%% Finish

Screen('CloseAll')
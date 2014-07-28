    
function [t exitCode] = runTarget(expt)
%% Initialization

% AssertOpenGL;
% 
% KbName('UnifyKeyNames');
% 
% % scrnNum = max(Screen('Screens'));
% 
% consts= getConstants();
% 
% scrnNum=consts.SCREEN_ID;
% 
% PsychImaging('PrepareConfiguration');
% 
% PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1);
% 
% [window, windowRect]=PsychImaging('OpenWindow', scrnNum, 0, [], [], [], 100);
% 
% W = RectWidth(windowRect);
% 
% H = RectHeight(windowRect);

KbName('UnifyKeyNames');

createWindow3D();

window=getWindow();

[W,H]=getResolution;

H = H/2;

exitCode = 0;

consts= getConstants();

% scrnNum=consts.SCREEN_ID;
% 
% Screen('SelectStereoDrawBuffer', window, 0);
% 
% Screen('FillRect', window, BlackIndex(scrnNum));
% 
% Screen('SelectStereoDrawBuffer', window, 1);
% 
% Screen('FillRect', window, BlackIndex(scrnNum));
% 
% Screen('Flip', window);
% 
% % Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% 
% Screen('FillRect', window, WhiteIndex(scrnNum));
% 
% Screen('Flip', window);

%% Stimulus Settings

timeLimit=-1; % -1 for stimulus playback until 'esc' is hit, 
              %otherwise until specified.
backColor       = 255;
bugColor        = 1;

targetSize = 20;
stepSize = 20;
disparity = 0;

Xbound =  W/2.5;
Ybound = 0.6*H;

fr =8; %this specifies the frequency of the steps, i.e., if fr=10 the
%target will move one stepSize every 10 frames.

% t2 = @(t) -min(mod(t, 2), 1)+1;
% stepSize = @(t) t2(t)*10;


% use the code beneath if you'd like to switch quickly between two
% disparities
% 
% motionMode = 1;
% 
% 
% switch motionMode
% 
%     case 1 %3D target
%         disparity = 10;
% 
% 
%     otherwise % 2D target
% 
%         disparity = 0;
% 
% end


if nargin>0
    unpackStruct(expt)
end



%Background Settings
% backdotRad =;
% backdots


a = [1 , -1];

%initializing the position of the target
posnX = W/2;

posnY = .7*H;

% Screen('FillRect', window, backColor);
% 
% Screen('Flip', window);

% disp('press any key when mantis is aligned ...');
%         pause;

i=0;

tstart=GetSecs;

while 1
    
    i = i+1;
    
%     drawnow;
    
    t = GetSecs-tstart;
    
      
    if posnX < Xbound
        
        posnX=W/2;
        
    elseif posnX > (W-Xbound)
        
        posnX =W/2;
        
    end
    
    if posnY < Ybound
        
        posnY = .7*H;
        
    elseif posnY>H
        
        posnY = .7*H;
        
    elseif posnY >((1.4*H)-Ybound)
       
        posnY =.7*H;
        
    end
    
    dots = [posnX; posnY] - [targetSize; targetSize/2];
    d = disparity;
    
    dotsL = dots;
    dotsR = dots;
    
    dotsL(1,:) = dots(1,:) - d/2;
    dotsR(1,:) = dots(1,:) + d/2;
    
    
    Screen('SelectStereoDrawBuffer', window, 0);
    
    Screen('FillRect', window, backColor);
    
    Screen('FillRect', window, bugColor, [dotsL; dotsL(1,:) + targetSize; dotsL(2,:)+targetSize/2]);
    
    Screen('SelectStereoDrawBuffer', window, 1);
    
    Screen('FillRect', window, backColor);
    
    Screen('FillRect', window, bugColor, [dotsR; dotsR(1,:) + targetSize; dotsR(2,:)+targetSize/2]);
    
    Screen('DrawingFinished', window);
    
    Screen('Flip', window);
    
    %specifying the direction of movement in both X and Y dimensions
    ind = randperm(2);
    
    dirX = a(ind(1));
    
    ind = randperm(2);
    
    dirY = a(ind(1));
    
    %moving the dot
    
    if mod(i,10)== 0 %only ever fr frames
        
        posnX = posnX + dirX*stepSize;
        
        posnY= posnY + dirY*stepSize/2;
        
    end
    if (timeLimit > -1)
        
        if (t >= timeLimit)
            
            break;
            
        end
        
    end
    
    
    [pressed dummy keycode] = KbCheck;
    
    if pressed
        if keycode(KbName('ESCAPE'))
            exitCode = -1; % abort
            break;
        end
    end
    
    
end

clearWindow();
%% Finish

% Screen('CloseAll')
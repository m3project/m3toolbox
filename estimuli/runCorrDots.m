function exitCode = runCorrDots(varargin)

% use the Mersenne twister for generating random numbers for this
% experiment

% below is an anonymous function which resets the random number generator

% this is called after any parameter change (via a keyboard shortcut)
% during the experiment

resetRandSequence = @() rng(0, 'twister');

%% print keyboard shortcuts

shortcuts = {
    'Up',               'Receed', ...
    'Down',             'Loom', ...
    '1',                'Switch to fully anti-correlated', ...
    '2',                'Switch to uncorrelated', ...
    '3',                'Switch to fully correlated', ...
    't',                'Enable toggling between correlation modes', ...
    's',                'Stop toggling between correlation modes', ...
    'Space',            'start/stop flashing', ...
    'Escape',           'Exit stimulus'
    };

printKeyboardShortcuts(shortcuts);

%% Initialization

exitCode = 0;

KbName('UnifyKeyNames');

Gamma = 2.188; % for DELL U2413

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

% LeftGains = [1 0 0];
%
% RightGains = [0 1 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

window = getWindow();

[W, H] = getResolution();

%% variables

apreture = [300 300 1000 800]; % [x1 y1 x2 y2]

%apreture = [0 0 W H];

npoints = 1000;

radius = 1000;

boundaryAlpha = 0.0;

dotRadius = 10;

contrast = 1; % 0 to 1

%% delay settings

delay0 = 3; % stimulus presentation (seconds)

delay1 = 0.5; % pause (grey screen) after each condition presentation (seconds)

% NOTE: the durations of transitions during looming and receeding are
% specied on line 305 of this file

%% disparity calculations

viewD = 10; % viewing distance - between mantis and screen (cm)

IOD = 0.7; % inter-ocular distance (cm)

screenReso = 40; % px/cm

%% looming and receeding params

nearSimD = 2.5; % simulated distance (min) - between mantis and target (cm)

farSimD = 7.5; % simulated distance (max) - between mantis and target (cm)

% viewD = 100; nearSimD = 30; farSimD = 100;

nearDisp = calDisp(nearSimD, viewD, IOD) * screenReso;

farDisp = calDisp(farSimD, viewD, IOD) * screenReso;

%% plots

fbox = createFlickerBox(100, 65);

% fbox.simulate = 1;

%fbox.period = 30;

corrSettings = [-1 0 1];

currentCorrSetting = 1;

toggleOn = 0;

t0 = 0;

dispArr = nearDisp;

dispArrIndexer = 1;

dispArrNorm = 0.1;

stimOn = 0;

oldKeyCode = [];

brects = [...
    0 0 apreture(1) H; ...
    0 0 W apreture(2); ...
    apreture(3) 0 W H; ...
    0 apreture(4) W H; ...
];

resetRandSequence();

while 1
    
    t = GetSecs() - t0;
    
    dispArrIndexer = min(dispArrIndexer+1, length(dispArr));
    
    if dispArrIndexer < length(dispArr)
    
        fbox.pattern = [0 1]  * dispArrNorm(dispArrIndexer);
    
    else
        
        levels2 = [0 0.05 0.2];
        
        fbox.pattern = [1 levels2(currentCorrSetting)];
        
    end
    
    if t > delay0 && toggleOn
        
        Screen('flip', window);
        
        pause(delay1);
        
        t0 = GetSecs();
        
        currentCorrSetting = mod(currentCorrSetting, 3) + 1;
        
        continue;
        
    end
    
    dotD = (2*rand(npoints, 2)-1) * radius;
    
    colV = randi(2, [npoints 1])-1; % color vector
    
    if stimOn || (dispArrIndexer < length(dispArr))
        
        for channel = [0 1]
            
            s = power(-1, 1-channel); % disparity sign
            
            sdisp = s * dispArr(dispArrIndexer);
            
            Screen('SelectStereoDrawBuffer', window, channel);
            
            rect = [1 0 1 0] * W/2 + [0 1 0 1] * H/2 ...
                + [-1 -1 1 1] * radius + [1 0 1 0] * sdisp/2;
            
            Screen('FillOval', window, [0 0 0 boundaryAlpha], rect);
            
            dotX = W/2 + sdisp/2 + dotD(:,1); %dotDistance .* cos(dotAngle);
            
            dotY = H/2 + dotD(:,2); %dotDistance .* sin(dotAngle);
            
            rects = [dotX dotY dotX dotY] + ones(npoints, 1) * [-1 -1 1 1] * dotRadius;
            
            if channel==1
                
                corr = corrSettings(currentCorrSetting); % -1 = fully anti-correlated, 0 = uncorrelated, 1 = fully correlated
                
                xcorr = (corr+1)/2;
                
                k = 1:npoints*(1-xcorr);
                
                colV(k, :) = 1 - colV(k, :);
                
            end
            
            colMat = colV * [1 1 1];
            
            colMat = (colMat * 2 - 1); % change range from [0,1] to [-1,+1]
            
            colMat = 0.5 + colMat * 0.5 * contrast;
            
            Screen('FillOval', window, colMat', rects');
            
            for k=1:size(brects)
               
                Screen('FillRect', window, [1 1 1] * 0.5, brects(k, :));
                
            end
            
            if channel
                
                fbox = drawFlickerBox(window, fbox);
                
            else
                
                drawFlickerBox(window, fbox);
                
            end            
            
        end
        
        
        
    end
    
    Screen(window, 'Flip');
    
    % checking for key presses
    
    [~, ~, keyCode ] = KbCheck;
    
    if ~isequal(keyCode, oldKeyCode) && (dispArrIndexer == length(dispArr))
        
        if keyCode(KbName('Escape'))
            
            exitCode = 0;
            
            break;
            
        end
        
        if keyCode(KbName('END'))
            
            exitCode = 1;
            
            break;
            
        end
        
        numsPressed = intersect(find(keyCode), ('1':'9') + 0);
        
        if keyCode(KbName('Alt'))
            
            if isempty(numsPressed)
                
                % allows continuous holding down of Ctrl
                % by resetting the isKeyDown flag
                
                keyIsDown = 0;
                
            else
                
                exitCode = 100 + min(numsPressed) - '0'; % special exit code to switch stimuli
                
                return;
                
            end
            
        end
        
        if (keyCode(KbName('1!')))
            
            stimOn = 1;
            
            currentCorrSetting = 1;
            
            dispArr = nearDisp;
            
            dispArrIndexer = 1;
            
            resetRandSequence();
            
            dispArrNorm = 0.1;
            
        end
        
        if (keyCode(KbName('2@')))
            
            stimOn = 1;
            
            currentCorrSetting = 2;
            
            dispArr = nearDisp;
            
            dispArrIndexer = 1;
            
            resetRandSequence();
            
            dispArrNorm = 0.1;
            
        end
        
        if (keyCode(KbName('3#')))
            
            stimOn = 1;
            
            currentCorrSetting = 3;
            
            dispArr = nearDisp;
            
            dispArrIndexer = 1;
            
            resetRandSequence();
            
            dispArrNorm = 0.1;
            
        end
        
        if (keyCode(KbName('t')))
            
            toggleOn = 1;
            
            stimOn = 1;
            
            resetRandSequence();
            
            dispArr = nearDisp;
            
            dispArrIndexer = 1;
            
            dispArrNorm = 0.1;
            
        end
        
        if (keyCode(KbName('s')))
            
            toggleOn = 0;
            
            stimOn = 0;
            
            resetRandSequence();
            
            dispArr = nearDisp;
            
            dispArrIndexer = 1;
            
            dispArrNorm = 0.1;
            
        end
        
        if (keyCode(KbName('Space')))
            
            stimOn = 1 - stimOn;
            
            resetRandSequence();
            
        end
        
        if (keyCode(KbName('UpArrow')))
            
            dispArr = calculateDispArr(nearDisp, farDisp);
            
            dispArrNorm = makeSimpArr(calculateDispArr(0.1, 1), 0);
            
            dispArrIndexer = 1;
            
            currentCorrSetting = 3;
            
            stimOn = 0;
            
            resetRandSequence();
            
        end
        
        if (keyCode(KbName('DownArrow')))
            
            dispArr = calculateDispArr(farDisp, nearDisp);
            
            dispArrNorm = makeSimpArr(calculateDispArr(1, 0.1), 0.02);
            
            dispArrIndexer = 1;
            
            currentCorrSetting = 3;
            
            stimOn = 0;
            
            resetRandSequence();
            
        end
        
        oldKeyCode = keyCode;
        
    end
    
end

%closeWindow();

end

function y = calculateDispArr(disp1, disp2)

% segment 1 : disp1
% segment 2 : disp1 -> disp2
% segment 3 : disp2
% segment 4 : disp2 -> disp1
% segment 5 : disp1

fps = 60;

t = [1 0.5 1 0.5 1]; % segment durations (seconds)

frames = t * fps;

seg1 = ones(frames(1), 1) * disp1;

seg2 = disp1:(disp2-disp1)/(frames(2)-1):disp2;

seg3 = ones(frames(3), 1) * disp2;

seg4 = disp2:(disp1-disp2)/(frames(4)-1):disp1;

seg5 = ones(frames(1), 1) * disp1;

y = [seg1; seg2'; seg3; seg4'; seg5];

end

function dispArrNorm = makeSimpArr(dispArrNorm2, k)

dispArrNorm = ones(size(dispArrNorm2)) * 0.5;

dispArrNorm(dispArrNorm2 == 0.1) = k;

dispArrNorm(dispArrNorm2 == 1) = k;

end
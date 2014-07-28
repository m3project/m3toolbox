function dump = runTwoTarget(expt)

KbName('UnifyKeyNames');

createWindow3D();

window = getWindow();

[sW, sH] = getResolution();

%% stimulus parameters

blockWidth= 4; %Block width in degrees

blockHeight=2; %block height in degrees

xOffset= 15; %distance from each stimulus to centre in degrees

viewD = 4; % distance of screen from mantis

virtDm1 = 2.5; %desired simulated distance in cm of first target in front of mantis

virtDm2 = 6; %desired simulated distance in cm of second target in front of mantis

bugColor = 0; % 0 (black), 1 (white) or inbetween

backColor = 1; % 0 (black), 1 (white) or inbetween

iod = 0.5; % mantis inter-ocular distance (cm)

timeStep=0.001;%how often the stimulus should advance in seconds

isDelay = 0; %delay between the initialization stimulus and the test stimuli

% initialDelay = 3; % delay in seconds before bug starts looming




%% stimulus flags

enableMotion = 1;

diffTarget =0; %0 for both targets non-wormlike, 1 for left target wormlike, 2 for right target wormlike, 4 for both targets wormlike

sizeTarget=0; %0 for no size different target, 1 for left target scaled bigger, 2 for right target scaled bigger, 4 for both targets scaled bigger according to virtual distance.
dispTarget=0; %0 for no disparate target, 1 for left target disparate, 2 for right target disparate, 4 for both targets disparate.

startTime = GetSecs();

if nargin>0
    
    unpackStruct(expt)
    
end

dump = packWorkspace();

%% projection calculation:

screenWidth_cm = 50.5;
sf = sW/screenWidth_cm; %scaling factor from cm to pixels

blockWidth_cm= 2*viewD*tand(blockWidth/2);
blockHeight_cm= 2*viewD*tand(blockHeight/2);

blockWidth_px = blockWidth_cm*sf; %width of one block in cm - target consists of ten block
blockHeight_px = blockHeight_cm*sf; %height of one block in cm


virtBlockWidth_cm = viewD / virtDm2 * blockWidth_cm;
virtBlockHeight_cm = viewD / virtDm2 * blockHeight_cm;

virtBlockWidth_px = virtBlockWidth_cm*sf; %width of one block in cm - target consists of ten block
virtBlockHeight_px = virtBlockHeight_cm*sf; %height of one block in cm

disparity = iod * virtDm2./ (viewD - virtDm2) * sf;
% disparity = -100;

xOffset_cm= viewD*tand(xOffset);
xOffset_px=xOffset_cm*sf;
bugX= (screenWidth_cm/2) *sf;
bugX_L = (screenWidth_cm/2 - xOffset_cm) *sf; % horizontal location of left bug.
bugX_R = (screenWidth_cm/2 + xOffset_cm) *sf; % horizontal location of right bug.






%% rendering loop

y1=sH; %y position of the first block - initally set to the bottom of the screen.

stepMult=1;

l_shift(1:10)=0;%shift if required for the "complex stimulus"
r_shift(1:10)=0;%shift if required for the "complex stimulus"

while (y1>0)
    
    t = GetSecs() - startTime;
    
    if t>stepMult*timeStep
        y1=y1-blockHeight_px;
        stepMult=stepMult+1;
             
    end


% Screen(window, 'FillRect' , [1 1 1] * 255, [0 0 sW sH] );

% Screen(window, 'DrawLine',[1 1 1 1] * 255, sW/2, 0, sW/2, sH, 2);

%rendering the initial stimulus

rect1 = [bugX+blockWidth_px;y1;bugX;y1-blockHeight_px];
rect2 = [bugX+blockWidth_px;y1-blockHeight_px;bugX;y1-2*blockHeight_px];
rect3 = [bugX+blockWidth_px;y1-2*blockHeight_px;bugX;y1-3*blockHeight_px];
rect4 = [bugX+blockWidth_px;y1-3*blockHeight_px;bugX;y1-4*blockHeight_px];
rect5 = [bugX+blockWidth_px;y1-4*blockHeight_px;bugX;y1-5*blockHeight_px];
rect6 = [bugX+blockWidth_px;y1-5*blockHeight_px;bugX;y1-6*blockHeight_px];
rect7 = [bugX+blockWidth_px;y1-6*blockHeight_px;bugX;y1-7*blockHeight_px];
rect8 = [bugX+blockWidth_px;y1-7*blockHeight_px;bugX;y1-8*blockHeight_px];
rect9 = [bugX+blockWidth_px;y1-8*blockHeight_px;bugX;y1-9*blockHeight_px];
rect10 = [bugX+blockWidth_px;y1-9*blockHeight_px;bugX;y1-10*blockHeight_px];

bugRects1=[rect1 rect2 rect3 rect4 rect5 rect6 rect7 rect8 rect9 rect10];
bugRects2=[rect1 rect2 rect3 rect4 rect5 rect6 rect7 rect8 rect9 rect10];



Screen('SelectStereoDrawBuffer', window, 0);
Screen('FillRect',window,[0 0 0], bugRects1);
Screen('SelectStereoDrawBuffer', window, 1);
Screen('FillRect',window,[0 0 0], bugRects2);
Screen(window, 'Flip');

% checking for key presses

[~, ~, keyCode ] = KbCheck;

if (keyCode(KbName('Escape')))
    
    break;
    
end


end

pause(isDelay)

y1=0; %y position of the first block - initally set to the top of the screen.
% timeStep=0.05;%how often the stimulus should advance in seconds
stepMult=1;
l_shift(1:10)=0;%shift if required for the "complex stimulus"
r_shift(1:10)=0;%shift if required for the "complex stimulus"
startTime = GetSecs();

while (y1<(sH-(10*blockHeight_px)))
    
    t = GetSecs() - startTime;
    
    if t>stepMult*timeStep
        y1=y1+blockHeight_px;
        stepMult=stepMult+1;
        if diffTarget==4
            for j=1:9
            l_shift(j)=l_shift(j+1);
            r_shift(j)=r_shift(j+1);
            l_shift(10)=(2*rand()-1)*blockWidth_px/2;
            r_shift(10)=(2*rand()-1)*blockWidth_px/2;
            end
        elseif diffTarget==1
            for j=1:9
            l_shift(j)=l_shift(j+1);
            l_shift(10)=(2*rand()-1)*blockWidth_px/2;
            end
            r_shift(:,1)=0;
        elseif diffTarget==2
            for j=1:9
            r_shift(j)=r_shift(j+1);
            r_shift(10)=(2*rand()-1)*blockWidth_px/2;
            end
            l_shift(:,1)=0;
        else
            l_shift(:,1)=0;
            r_shift(:,1)=0;
        end
    end


% Screen(window, 'FillRect' , [1 1 1] * 255, [0 0 sW sH] );

% Screen(window, 'DrawLine',[1 1 1 1] * 255, sW/2, 0, sW/2, sH, 2);

%rendering left stimulus
if sizeTarget==1||sizeTarget==4
    blockWidth_L_px=virtBlockWidth_px;
    blockHeight_L_px=virtBlockHeight_px;
    else
    blockWidth_L_px=blockWidth_px;
    blockHeight_L_px=blockHeight_px;
end

rect1_L = [bugX_L+blockWidth_L_px+l_shift(1);y1;bugX_L+l_shift(1);y1+blockHeight_L_px];
rect2_L = [bugX_L+blockWidth_L_px+l_shift(2);y1+blockHeight_L_px;bugX_L+l_shift(2);y1+2*blockHeight_L_px];
rect3_L = [bugX_L+blockWidth_L_px+l_shift(3);y1+2*blockHeight_L_px;bugX_L+l_shift(3);y1+3*blockHeight_L_px];
rect4_L = [bugX_L+blockWidth_L_px+l_shift(4);y1+3*blockHeight_L_px;bugX_L+l_shift(4);y1+4*blockHeight_L_px];
rect5_L = [bugX_L+blockWidth_L_px+l_shift(5);y1+4*blockHeight_L_px;bugX_L+l_shift(5);y1+5*blockHeight_L_px];
rect6_L = [bugX_L+blockWidth_L_px+l_shift(6);y1+5*blockHeight_L_px;bugX_L+l_shift(6);y1+6*blockHeight_L_px];
rect7_L = [bugX_L+blockWidth_L_px+l_shift(7);y1+6*blockHeight_L_px;bugX_L+l_shift(7);y1+7*blockHeight_L_px];
rect8_L = [bugX_L+blockWidth_L_px+l_shift(8);y1+7*blockHeight_L_px;bugX_L+l_shift(8);y1+8*blockHeight_L_px];
rect9_L = [bugX_L+blockWidth_L_px+l_shift(9);y1+8*blockHeight_L_px;bugX_L+l_shift(9);y1+9*blockHeight_L_px];
rect10_L = [bugX_L+blockWidth_L_px+l_shift(10);y1+9*blockHeight_L_px;bugX_L+l_shift(10);y1+10*blockHeight_L_px];

bugRects_L1=[rect1_L rect2_L rect3_L rect4_L rect5_L rect6_L rect7_L rect8_L rect9_L rect10_L];
bugRects_L2=[rect1_L rect2_L rect3_L rect4_L rect5_L rect6_L rect7_L rect8_L rect9_L rect10_L];

if dispTarget==1||dispTarget==4
bugRects_L1(1,:)=bugRects_L1(1,:)-disparity/2;
bugRects_L1(3,:)=bugRects_L1(3,:)-disparity/2;
bugRects_L2(1,:)=bugRects_L2(1,:)+disparity/2;
bugRects_L2(3,:)=bugRects_L2(3,:)+disparity/2;
end


Screen('SelectStereoDrawBuffer', window, 0);
Screen('FillRect',window,[0 0 0], bugRects_L1);
Screen('SelectStereoDrawBuffer', window, 1);
Screen('FillRect',window,[0 0 0], bugRects_L2);

%rendering right stimulus
if sizeTarget==2||sizeTarget==4
    blockWidth_R_px=virtBlockWidth_px;
    blockHeight_R_px=virtBlockHeight_px;
else
    blockWidth_R_px=blockWidth_px;
    blockHeight_R_px=blockHeight_px;
end

rect1_R = [bugX_R+r_shift(1);y1;bugX_R+blockWidth_R_px+r_shift(1);y1+blockHeight_R_px];
rect2_R = [bugX_R+r_shift(2);y1+blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(2);y1+2*blockHeight_R_px];
rect3_R = [bugX_R+r_shift(3);y1+2*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(3);y1+3*blockHeight_R_px];
rect4_R = [bugX_R+r_shift(4);y1+3*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(4);y1+4*blockHeight_R_px];
rect5_R = [bugX_R+r_shift(5);y1+4*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(5);y1+5*blockHeight_R_px];
rect6_R = [bugX_R+r_shift(6);y1+5*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(6);y1+6*blockHeight_R_px];
rect7_R = [bugX_R+r_shift(7);y1+6*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(7);y1+7*blockHeight_R_px];
rect8_R = [bugX_R+r_shift(8);y1+7*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(8);y1+8*blockHeight_R_px];
rect9_R = [bugX_R+r_shift(9);y1+8*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(9);y1+9*blockHeight_R_px];
rect10_R = [bugX_R+r_shift(10);y1+9*blockHeight_R_px;bugX_R+blockWidth_R_px+r_shift(10);y1+10*blockHeight_R_px];

bugRects_R1=[rect1_R rect2_R rect3_R rect4_R rect5_R rect6_R rect7_R rect8_R rect9_R rect10_R];
bugRects_R2=[rect1_R rect2_R rect3_R rect4_R rect5_R rect6_R rect7_R rect8_R rect9_R rect10_R];

if dispTarget==2||dispTarget==4
bugRects_R1(1,:)=bugRects_R1(1,:)-disparity/2;
bugRects_R1(3,:)=bugRects_R1(3,:)-disparity/2;
bugRects_R2(1,:)=bugRects_R2(1,:)+disparity/2;
bugRects_R2(3,:)=bugRects_R2(3,:)+disparity/2;
end
    
Screen('SelectStereoDrawBuffer', window, 0);
Screen(window, 'FillRect',[0 0 0], bugRects_R1);
Screen('SelectStereoDrawBuffer', window, 1);
Screen(window, 'FillRect',[0 0 0], bugRects_R2);




Screen(window, 'Flip');

% checking for key presses

[~, ~, keyCode ] = KbCheck;

if (keyCode(KbName('Escape')))
    
    break;
    
end

%     break;

end

end



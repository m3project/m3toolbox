% This function calculates the parameters required for different viewing 
%distances so that the viewing angle and step size angle are preserved 
%across experiments. It also calcualtes the appropriate disparity for 
%different distances on the screen.

function [XpxMM, XboundNewpx, YboundNewpx, targetSizeNewpx, stepSizeNewpx, disparityNewpx] = pmtrCalc(viewDist)


%Reference Parameters
%Enter here the parameters you wish to mimic at different distances and the
%fixed parameters like the screen size and the distance between the
%mantis's eyes.
%NOTE: Reference disparity is assumed to be zero.
W=1920; %screen width in pixels
Wmm=510; %screen width in mm
H=540; %screen height in pixels
Hmm=290; %screen height in mm
XpxMM = W/Wmm; % number of pixels per mm
YpxMM = H/Hmm; % number of pixels per mm
eyeDist = 4; % Distance between the mantis's eyes in mm
viewDistRef = 20; %reference viewing distance in mm

Xbound= W/3;
Xbound=Xbound/XpxMM;
XboundAng = atan(((Wmm/2)-Xbound)/viewDistRef); % Assumes default X position of target is at the centre, i.e, Wmm/2
Ybound= 0.5*H;
Ybound=Ybound/YpxMM;
YboundAng = atan(((0.7*Hmm)-Ybound)/viewDistRef);% Assumes default Y position of target is at 0.7*Hmm

stepSizeRef = 4; % movement step size in mm
targetSizeRef = 5; %target size in mm

% converting target size into radians (angular target size kept constant)
targetSizeAng = 2* atan((targetSizeRef/2)/viewDistRef);

%converting step size into radians (angular step size kept constant)
stepSizeAng = atan(stepSizeRef/viewDistRef);


%Experiment Parameters

viewDistNew = viewDist; %experimental viewing distance in mm, specified by user

%Computing the bounds of movement

XboundNew = (Wmm/2)-(tan(XboundAng)*viewDistNew); %New left movement bound in mm
XboundNewpx = XboundNew * XpxMM; 
if XboundNewpx < 0
    XboundNewpx=0;
end
XboundNewpx%New movement bound in pixels: OUTPUT

YboundNew = (0.7*Hmm)-(tan(YboundAng)*viewDistNew); %New upper movement bound in mm
YboundNewpx = YboundNew * YpxMM;
if YboundNewpx < 0
YboundNewpx=0;
end
YboundNewpx;%New movement bound in pixels: OUTPUT



targetSizeNew = 2*tan(targetSizeAng/2)*viewDistNew %New target size in mm
targetSizeNewpx = targetSizeNew * XpxMM %New target size in pixels: OUTPUT

stepSizeNew = tan(stepSizeAng)*viewDistNew; %New step size in mm
stepSizeNewpx = stepSizeNew * XpxMM; %New step size in pixels: OUTPUT

% Computing the disparity. Strictly speaking, this is the parallax, i.e.,
%the displacement (rather than the angle) between the two views for each 
%eye.
disparityNew = eyeDist *((viewDistNew-viewDistRef)/viewDistRef); 
disparityNewpx = disparityNew * XpxMM; % disparity in pixels: OUTPUT


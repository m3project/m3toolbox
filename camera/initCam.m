% initializes camera
%
% resolutions are currently hard coded, to obtain list of supported
% resolutions for your camera device, run:
%
% info = imaqhwinfo('winvideo'); info.DeviceInfo.SupportedFormats
%
function cam1 = initCam()

reso1 = 'YUY2_160x120';
reso2 = 'YUY2_320x240';
reso3 = 'YUY2_640x480';
reso4 = 'YUY2_1280x960';
reso5 = 'YUY2_1600x1200';

try

cam1 = videoinput('winvideo', 1, reso3);

triggerconfig(cam1, 'manual');

%preview(cam1);

disp('video object created');

catch exception
   
    error('no video cameras appear to be connected to this computer.')
    
end

end
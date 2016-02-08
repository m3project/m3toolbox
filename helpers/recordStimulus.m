% this script simplifies the task of recording stimuli videos
%
% it is used as follows
%
% - First, call the script passing a video file name as a parameter (e.g.
% recording = recordingStimulus('d:\stim.avi'). This will initialize the
% recording object
%
% - Then, after each screen flip, call:
% recording = recordingStimulus(recording) making sure to include the
% output argument. This will record a frame
%
% - Finally, to end the recording simply call recordingStimulus(recording)
% without an output argument. This will close the recording object
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 16/12/2015

function recording = recordStimulus(arg1)

isFirstCall = ischar(arg1);

if isFirstCall
    
    % first call to the function
    
    % initialize recording structure

    outputVideoFile = arg1;
    
    parentDirs = fileparts(arg1);
    
    if ~exist(parentDirs, 'file')
    
        mkdir(parentDirs);
        
    end
    
    writerObj = VideoWriter(outputVideoFile);
    
    writerObj.FrameRate = 60;
    
    open(writerObj);
    
    recording.writerObj = writerObj;
    
    recording.frame = 1;

elseif nargout == 0
    
    % last call to function
    
    % close video object
    
    recording = arg1;
    
    close(recording.writerObj);
    
else
    
    % render frame
    
    recording = arg1;
    
    window = getWindow();
    
    imageArray = Screen(window, 'GetImage');
    
    writeVideo(recording.writerObj, imageArray);
    
end

end
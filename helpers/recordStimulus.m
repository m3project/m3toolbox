% this script simplifies the task of recording stimuli videos
%
% it is used as follows
%
% - First, call the script passing a video file name as a parameter (e.g.
% recording = recordStimulus('d:\stim.avi'). This will initialize the
% recording object
%
% - Then, after each screen flip, call:
% recording = recordStimulus(recording) making sure to include the
% output argument. This will record a frame
%
% - Finally, to end the recording simply call recordStimulus(recording)
% without an output argument. This will close the recording object
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 16/12/2015

function recording = recordStimulus(arg1)

cropVideo = 0;

isFirstCall = ischar(arg1);

if isFirstCall
    
    % first call to the function
    
    % initialize recording structure

    outputVideoFile = arg1;
    
    if ~isempty(outputVideoFile)
        
        parentDirs = fileparts(arg1);
        
        if ~exist(parentDirs, 'file')
            
            mkdir(parentDirs);
            
        end
        
        writerObj = VideoWriter(outputVideoFile);
        
        writerObj.FrameRate = 60;
        
        open(writerObj);
        
        recording.writerObj = writerObj;
        
        recording.frame = 1;
        
    else
        
        % when passing an empty string during the first call, the returned
        % object is []
        % this is a mechanism to conveniently disable recording
        % functionality in a stimulus script by setting video file name to
        % an empty string
        
        recording = [];
        
    end
        

elseif nargout == 0
    
    % last call to function
    
    % close video object
    
    recording = arg1;
    
    if ~isempty(recording)
    
        close(recording.writerObj);
        
    end
    
else
    
    % render frame
    
    recording = arg1;
    
    if ~isempty(recording)
        
        window = getWindow();
        
        rect = [];
        
        pW = 0.75;
        pH = 0.25;
        
        if cropVideo
            
            cx = 1920/2;
            cy = 1200/2;
            
            x0 = cx - cx * pW;
            x1 = cx + cx * pW;
            
            y0 = cy - cy * pH;
            y1 = cy + cy * pH;
            
            rect = [x0 y0 x1 y1];
            
        end
            
        imageArray = Screen(window, 'GetImage', rect);        
        
        writeVideo(recording.writerObj, imageArray);
        
    end
    
end

end
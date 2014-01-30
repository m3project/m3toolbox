function saveMP4(cam1, file)

totalFrames = cam1.FramesAvailable;

if (totalFrames == 0)
    
    error('no frames acquired');
    
end

[data time] = getdata(cam1, totalFrames);

fps = totalFrames / time(end);

writerObj = VideoWriter(file, 'MPEG-4');

writerObj.open();

for i=1:totalFrames
    
    frame = data(:,:,:,i);
    
    frame = YUY2toRGB(frame);
    
    data(:,:,:,i) = frame;
    
end

writerObj.writeVideo(data);

writerObj.close();

stop(cam1);



end
function compressVideo(inpFile, outFile)

cmd = 'ffmpeg.exe -y -i %s -b:v 1024k %s';

cmd = sprintf(cmd, inpFile, outFile);

[dummy1 dummy2] = system(cmd);

end
function finishEyelinkRecording(edfFile, outputFile)

% Finish recording, grabbing edfFile from eyelink and saving it as
% outputFile.

Eyelink('StopRecording');

Eyelink('CloseFile');

Eyelink('ReceiveFile');

assert(exist(edfFile, 'file') == 2); % check that file exists

copyfile(edfFile, outputFile);

delete(edfFile);

end
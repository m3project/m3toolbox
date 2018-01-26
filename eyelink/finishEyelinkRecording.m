function finishEyelinkRecording(edfFile, outputFile)

% Finish recording, grabbing edfFile from eyelink and saving it as
% outputFile.
%
% Note: if edfFile and outputFile are not both supplied, recording is
% terminated but the recorded file is discarded.

Eyelink('StopRecording');

Eyelink('CloseFile');

if nargin == 2

    Eyelink('ReceiveFile');

    assert(exist(edfFile, 'file') == 2); % check that file exists

    copyfile(edfFile, outputFile);

    delete(edfFile);

end

end
function edfFile = startEyelinkRecording()

% Start recording, returning edf filename as handle.

edfFile = getFileName();

Eyelink('Openfile', edfFile);

Eyelink('StartRecording');

end

function file = getFileName()

% Return a timestamp based EDF file name.

datePart = datestr(now, 'MMSS');

file = sprintf('m_%s.edf', datePart);

end
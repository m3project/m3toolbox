function exitCode = runDotsAnaglyph_ephys()

error('This stimulus is still being actively modified by Vivek and Jenny and should not be used. Email Ghaith to discuss if necessary.');

% create window with correct gamma setting for ephys

consts = getConstants();

consts.CRT_GAMMA = 2.127; % for DELL U2413

createWindow3DAnaglyph(consts);

% run stimulus

expt = struct;

expt.drawFlickerBox = 1;

expt.flickSize = 200;

exitCode = runDotsAnaglyph(expt);

end
function exitCode = runDotsAnaglyph_ephys()

% run stimulus

expt = struct;

expt.drawFlickerBox = 1;

expt.flickSize = 200;

exitCode = runDotsAnaglyph(expt);

end
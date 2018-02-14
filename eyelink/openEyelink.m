% Convenience Wrappers for PTB Eyelink functions
%
% Usage:
%
%   1. openEyelink();
%
%   2. handle = startEyelinkRecording();
%
%   3. finishEyelinkRecording(handle, 'output_file.edf');
%
%   4. closeEyelink();
%
% Notes:
%
%   (1) initializes device and runs calibration, meant to be used at
%   beginning of experiments
%
%   (2) starts a recording (e.g. pre to rendering stimulus)
%
%   (3) finishes current recording (after rendering stimulus), saving
%   recording to a given output file.
%
%   (4) dealloc eyelink resources at end of experiment
%
% Author:
%
%   Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 22/01/2018

function openEyelink()

% Initialize eyelink device and run calibration.

window = getWindow();

handle = EyelinkInitDefaults(window);

initResult = EyelinkInit(0, 1);

assert(logical(initResult), 'failed to initialize Eyelink');

EyelinkDoTrackerSetup(handle); % launch calibration

end

% creates a PTB window
%
% The function requires that you specify the Gamma value for the used
% monitor. If no Gamma value is provided the function will not apply Gamma
% correction. If an existing window is open and a Gamma value is provided
% the function will throw an error to help programmers catch elusive cases
% when a top function initializes a window without a Gamma value and child
% function calls which attempt to apply Gamma get ignored (because a window
% is already open)
%
% Usage:
%
% createWindow(); % when the stimulus does not require Gamma correction
% createWindow(G); % when the stimulus requires Gamma = G

function window = createWindow(Gamma)

applyGamma = nargin > 0;

if nargin < 1

    % this is just to stop Matlab complaining when the function is called
    % with no parameters

    Gamma = 0; % dummy value which is not used since applyGamma = 0

end

if Gamma == 1

    error('this call is now deprecated, update to createWindow()');

end

consts = getConstants();

% set PTB message verbosity depending on constant SILENT_PTB

verb_level = ifelse(consts.SILENT_PTB, 1, 3);

debug_level = ifelse(consts.NO_TESTS, 0, 5);

Screen('Preference', 'Verbosity', verb_level);

Screen('Preference','SkipSyncTests', consts.NO_TESTS);

Screen('Preference','VisualDebugLevel', debug_level);

% checking for any existing windows

m = Screen('Windows');

if (~isempty(m))

    if applyGamma

        error('attempted to create Window with Gamma while one is open');

    else

        window = getWindow();

        return;

    end

end

% Open a PTB window on the TV

PsychImaging('PrepareConfiguration');

%PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');

PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');

if IsWindows

    enable10Bit();

end

window = PsychImaging('OpenWindow', consts.SCREEN_ID, consts.MEAN_LUM, ...
    [], [], [], consts.STEREO_MODE, 0);

Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

if applyGamma

    PsychColorCorrection('SetEncodingGamma', window, 1/Gamma);

end

end

function enable10Bit()

PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

PsychImaging('AddTask', 'General', 'EnableNative10BitFramebuffer');

end

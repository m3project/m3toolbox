% creates a PTB window

function createWindow3DAnaglyph(consts)

if nargin<1

    consts = getConstants();

end

% set PTB message verbosity depending on constant SILENT_PTB

if (consts.SILENT_PTB == 1)
    verb_level = 1;
else
    verb_level = 3;
end

Screen('Preference', 'Verbosity', verb_level);
    
Screen('Preference','SkipSyncTests', consts.NO_TESTS);

if (consts.NO_TESTS == 1)
    Screen('Preference','VisualDebugLevel', 0);
else
    Screen('Preference','VisualDebugLevel', 5);
end

% checking for any existing windows

m = Screen('Windows');

if (~isempty(m))
    
    return;
    
end

% Open a PTB window on the TV

PsychImaging('PrepareConfiguration');

%PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1); %3d

PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');

PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');

%PsychImaging('AddTask', 'LeftView', 'DisplayColorCorrection', 'AnaglyphStereo')

%PsychImaging('AddTask', 'RightView', 'DisplayColorCorrection', 'AnaglyphStereo')

window = PsychImaging('OpenWindow', consts.SCREEN_ID, consts.MEAN_LUM, [], [], [], 6);

Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Specify the window's inverse gamma value to be applied in the imaging pipeline

PsychColorCorrection('SetEncodingGamma', window, 1/consts.CRT_GAMMA);

SetAnaglyphStereoParameters('LeftGains', window, [0 1 0]);

SetAnaglyphStereoParameters('RightGains', window, [0 0 1]);


end
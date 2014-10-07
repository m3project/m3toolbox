% creates a PTB window

function createWindow3D(Gamma)

if (nargin == 0) || (nargin == 1 && isstruct(Gamma))
    
    % this is most probably a call using the deprecated function signature
    % createWindow(consts)
    
    msg = 'Part of the experiment/stimulus you just attempted to executed includes calls to deprecated functions. If you''re not sure what this means, please email Ghaith.';

    msgbox(msg, 'Important')
    
    if nargin == 0
        
        createWindow3D_dep();
        
    else
    
        createWindow3D_dep(Gamma); % note: Gamma in this case is consts
        
    end
    
    return;    
    
elseif nargin ~= 1
    
    error('This function requires that you specify Gamma');
    
end
    
consts = getConstants();

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

PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1); %3d

PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');

PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');

window = PsychImaging('OpenWindow', consts.SCREEN_ID, consts.MEAN_LUM, [], [], [], 100);

Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Specify the window's inverse gamma value to be applied in the imaging pipeline

PsychColorCorrection('SetEncodingGamma', window, 1/Gamma);

end

%%


function createWindow3D_dep(consts)

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

PsychImaging('AddTask', 'General', 'InterleavedLineStereo',1); %3d

PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');

PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');

window = PsychImaging('OpenWindow', consts.SCREEN_ID, consts.MEAN_LUM, [], [], [], 100);

Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Specify the window's inverse gamma value to be applied in the imaging pipeline

PsychColorCorrection('SetEncodingGamma', window, 1/consts.CRT_GAMMA);

end
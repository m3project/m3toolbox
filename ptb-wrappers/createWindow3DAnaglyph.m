% creates a PTB window

function createWindow3DAnaglyph(Gamma, LeftGains, RightGains, rect)

if (nargin == 0) || (nargin == 1 && isstruct(Gamma))
    
    % this is most probably a call using the deprecated function signature
    % createWindow3DAnaglyph(consts)
    
    msg = 'Part of the experiment/stimulus you just attempted to executed includes calls to deprecated functions. If you''re not sure what this means, please email Ghaith.';

    msgbox(msg, 'Important')
    
    if nargin == 0
        
        createWindow3DAnaglyph_dep();
        
    else
    
        createWindow3DAnaglyph_dep(Gamma); % note: Gamma in this case is consts
        
    end
    
    return;
    
elseif ~ismember(nargin, [3 4]);
    
    error('incompatible call');
    
end

if nargin < 4; rect = []; end

consts = getConstants();

if isequal(getenv('computername'), 'READLAB14')
    
    [sW, sH] = getResolution();
    
    consts.NO_TESTS = 2;
    
    PsychDebugWindowConfiguration(1,50);
    
%     rect = [-sW 0 -1 sH];
    
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

window = PsychImaging('OpenWindow', consts.SCREEN_ID, consts.MEAN_LUM, rect, [], [], 6);

Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Specify the window's inverse gamma value to be applied in the imaging pipeline

PsychColorCorrection('SetEncodingGamma', window, 1/Gamma);

SetAnaglyphStereoParameters('LeftGains', window, LeftGains);

SetAnaglyphStereoParameters('RightGains', window, RightGains);

end

%%


function createWindow3DAnaglyph_dep(consts)

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

SetAnaglyphStereoParameters('LeftGains', window, [0 0.66 0]);

SetAnaglyphStereoParameters('RightGains', window, [0 0 1]);

end
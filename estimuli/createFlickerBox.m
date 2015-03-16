% createFlickerBox
%
% create a data structure which can be used in conjunction with
% drawFlickerBox to render a flickering patch on the bottom-left corner of
% a PTB window. This is used in ephys stimuli to synchronize stimuli
% presentations with recording
%
% W : box width (pixels)
% H : box height (pixels)
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 13/03/2015

function fbox = createFlickerBox(W, H)

[~, sH] = getResolution();

rect = [0 sH-H W sH];

internal = struct('rect', rect, 'i', 0, 'frames', 0);

fbox = struct('period', 1, 'pattern', [0 1], 'visible', 1, 'internal', internal);

end
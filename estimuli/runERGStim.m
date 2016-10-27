% this is an adaption of runFlashAnaglyph
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 27/10/2016

function exitCode = runERGStim(args)

% parameters

nLevels = 20; % number of levels

tOn = 0.2; % secs

tOff = 0.1; % secs

repeats = 2;

tBetweenRepeats = 2; % secs

screenRect = [100 200 500 800]; % leave empty for full screen

backLum = 0.25; % background luminance

Gamma = 2.188; % for DELL U2413

channel = 1;

%% load overrides

if nargin; unpackStruct(args); end

%% create window

if ~isequal(getenv('computername'), 'READLAB14')

	closeWindow(); % avoid restarting ptb window when debugging

end

LeftGains = [0 0.66 0];

RightGains = [0 0 1];

createWindow3DAnaglyph(Gamma, LeftGains, RightGains);

%% serial port object

sobj = initSerial();

ss = @(str) sendSerial(sobj, str);

%% body

KbName('UnifyKeyNames');

window = getWindow();

HideCursor; f1 = @() ShowCursor; obj2 = onCleanup(f1);

fbox = createFlickerBox(150, 55);

while 1

	Screen('SelectStereoDrawBuffer', window, 0);

	Screen(window, 'FillRect', [1 1 1] * backLum, []);

	Screen('SelectStereoDrawBuffer', window, 1);

	Screen(window, 'FillRect', [1 1 1] * backLum, []);

	Screen(window, 'Flip');

	oldKeyIsDown = 1;

	while 1

		[keyIsDown, ~, keyCode] = KbCheck;

		exitCode = checkEscapeKeys(keyCode);

		if exitCode; return; end

		if keyIsDown && ~oldKeyIsDown

			if keyCode(KbName('Space')); break; end

			if keyCode('1') && (channel ~= 1)

				channel = 1; ss('selected channel 1');

			end

			if keyCode('2') && (channel ~= 2)

				channel = 2; ss('selected channel 2');

			end

		end

		oldKeyIsDown = keyIsDown;

	end

	sequence = getSequence(nLevels, tOn, tOff, channel);

	n = size(sequence, 1);

	ss('begin presentation');

	for j=1:repeats

		ss(sprintf('begin repeat %d of %d', j, repeats));

		for i=1:n

			fbox.pattern = 1 * i/n;

			s = sequence(i, :);

			Screen('SelectStereoDrawBuffer', window, 0);

			Screen(window, 'FillRect', [1 1 1] * backLum, []);

			Screen(window, 'FillRect', [1 1 1] * s(1), screenRect);

			drawFlickerBox(window, fbox);

			Screen('SelectStereoDrawBuffer', window, 1);

			Screen(window, 'FillRect', [1 1 1] * backLum, []);

			Screen(window, 'FillRect', [1 1 1] * s(2), screenRect);

			fbox = drawFlickerBox(window, fbox);

			Screen(window, 'Flip');

			duration = sequence(i, 3);

			exitCode = internal_wait(duration);

			if exitCode; return; end

		end

		ss('end of repeat');

		exitCode = internal_wait(tBetweenRepeats);

		if exitCode; return; end

	end

end

end

function exitCode = internal_wait(duration)

exitCode = [];

t0 = GetSecs();

while GetSecs - t0 < duration

	[~, ~, keyCode] = KbCheck;

	exitCode = checkEscapeKeys(keyCode);

	if exitCode; return; end

end

end

function sequence = getSequence(n, tOn, tOff, channel)

% ugly way to generate the sequence but will work for now

% n is number of steps in each channel's sequence

lum = linspace(0, 1, n);

A = [lum' zeros(n, 1)];

B = reshape(A', [n*2 1]);

C = B(2:end-1);

Z = zeros(2*n-2, 1);

halfTimes = (C > 0) .* tOn + (C == 0) .* tOff;

if channel == 1

	sequence = [C Z halfTimes];

elseif channel == 2

	sequence = [Z C halfTimes];

else

	error('incorrect channel');

end

sequence(end+1, :) = sequence(1, :);

end
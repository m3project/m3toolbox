function testFrameDrop

createWindow();

window = getWindow();

[sW, sH] = getResolution();

n = 5000;

timeStamps = zeros(n, 1);

col = 0;

for i=1:n
    
    col = 1 - col;
    
    Screen(window, 'FillRect' , [1 1 1] * col * 255, [0 0 sW sH]);
    
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
    
    timeStamps(i) = VBLTimestamp;
    
    if Missed>0
        
        disp('missed')
        
    end
    
end

%% plot 1

subplot(2, 1, 1);

td = diff(timeStamps);

td_ms = (td(10:end)*1e3);

str = sprintf('std (ms) = %f\n', std(td_ms));

hist(td_ms, 1e2);

title(str);

axis([16 17 0 100]);

xlabel('Rendering Time (ms)');

%% plot 2

subplot(2, 1, 2);

plot(td_ms);

axis([1 n 16 17]);

xlabel('Frame');

ylabel('Rendering Time (ms)');

%% close

closeWindow();

end
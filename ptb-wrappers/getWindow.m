% returns handle of existing PTB window

function window = getWindow()

m = Screen('Windows');

if (isempty(m))
    
    error('no PTB windows created');
    
end

window = m(1);

end
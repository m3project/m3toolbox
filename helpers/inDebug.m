function inDebug()

pc = getenv('computername');

if ~isequal(pc, 'READLAB14')
    
     msgbox('The toolbox is under maintenance. This shouldn''t take long but if you need to run an experiment now please email me.', 'Message from Ghaith');
     
     error('toolbox under maintenance');
     
end

end
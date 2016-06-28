function inDebug()

isREADLAB14 = isequal(getenv('computername'), 'READLAB14');

assert(isREADLAB14, 'Ghaith is working on this stimulus');

end
function runStereo_columns_expt()

a=[1,-1];
ind=randperm(2);
dirn=a(ind(1));

expt.motionMode=1;
expt.timeLimit=20;
expt.direction =dirn;
runStereo_columns(expt)


ind=randperm(2);
dirn=a(ind(1));
expt.motionMode=1;
expt.timeLimit=20;
expt.direction =dirn;
runStereo_columns(expt)

ind=randperm(2);
dirn=a(ind(1));
expt.motionMode=1;
expt.timeLimit=20;
expt.direction =dirn;
runStereo_columns(expt)

ind=randperm(2);
dirn=a(ind(1));
expt.motionMode=1;
expt.timeLimit=20;
expt.direction =dirn;
runStereo_columns(expt)
end
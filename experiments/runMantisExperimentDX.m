function runMantisExperimentDX()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisDX\';

expt.recordVideos = 1;

runExperiment(expt);

end

function paramSet = genParamSet()

    samplingMode = 3;
    
    if samplingMode == 3
        
        intervals = {
            %{
        {40, [20 40 44.8 49.2 53.6 58 62.4 66.8 71.2 75.6 80]} ...
          {25, [12.5 31.25 37.25 43.5 49.5 55.75 61.6 68 80]} ...
          {20, [10 26.8 33.4 40 46.8 53.4 66.8 80]} ...
          {16, [8 30.08 33.4 36.8 40 43.36 46.72 50.08 53.44 60]} ...
          {8, [15.04 20.56 23.36 26.16 28.96 31.68 34.48 37.28 40]} ...
          {4, [2 8 14 20 22.24 24 24.48 26.68 28.92 31.12 36]} ...
          {2, [1 10 12 14 15.12 16.24 18 18.46 20 20.68 24 28 32]} ...
          {1, [0.5 1 2 3.5 5 6 7 9 10 11.56 13.12 14.67 16.23 17.78 19.34 20.89 22.45 24 27]}
        %}
        {40, [20 40 50 60 80 100]} ...
        {25, [15 25 35 40 50 60 70 80 100]} ...
        {20, [10 20 30 40 45 50 60 80 100]} ...
        {16, [8 32 35 40 50 60 70]} ....
        {8, [4 16 20 24 28 34 36 40 44]} ...
        {4, [2 8 14 20 24 32 40]} ... ...
        {2, [1 10 18 24 32 36]} ...
        {1, [1 5 10 12 15 20 24 27]}
        };
    
        dirs = [-1 1];
        
        paramSet = [];
        
        rows = length(intervals);
        
        for i=1:rows
            
            blockSize = intervals{i}{1};

            intv = intervals{i}{2};
            
            paramSeti = createRandTrial(blockSize, intv, dirs);
            
            paramSet = [paramSet; paramSeti];
            
        end
        
        %paramSet(:, 2) = ceil(paramSet(:,2) ./ paramSet(:,1) * 100);
        
        paramSet(:, 2) = (paramSet(:,2) ./ paramSet(:,1) * 100);
      
        r = randperm(size(paramSet, 1));
        
        paramSet = paramSet(r, :);
    
    elseif samplingMode == 2
        
        ROI = [
            1	10	24;
            2	14	24;
            4	20	40;
            8	15	40;
            16	30	60;
            20	20	80;
            25	25	80;
            40	40	80;
            ];
        
        rows = size(ROI, 1);
        
        n = 10;
        
        dirs = [-1 1];
        
        paramSet = [];
        
        for i=1:rows
            
            blockSize = ROI(i, 1);
            
            beginROIPerc = ROI(i, 2) / blockSize * 100;
            
            endROIPerc = ROI(i, 3) / blockSize * 100;
            
            intv = beginROIPerc : (endROIPerc-beginROIPerc)/(n-1) : endROIPerc;
            
            intv = ceil(intv)';
            
            paramSeti = createRandTrial(blockSize, intv, dirs);
            
            paramSet = [paramSet; paramSeti];
            
        end
        
        r = randperm(size(paramSet, 1));
        
        paramSet = paramSet(r, :);
        
    elseif samplingMode == 1
        
        Ms = [1 2 4 8 16 20 25 40];
        
        jumpSizePercs = [50 100 200 350 500 600 700 800 900 1000]; % percentages
        
        dirs = [-1 1];
        
        paramSet = createRandTrial(Ms, jumpSizePercs, dirs);
        
        k = (paramSet(:,1)<8) + (paramSet(:,2)<501);
        
        paramSet = paramSet(k, :);
        
    end

end

function runBeforeTrial(varargin)

runAlignmentStimulus();

end

function [exitCode, dump] = runTrial(paramSetRow)

disp('rendering the stimulus');

expt = struct;

expt.interactiveMode = 0;

expt.timeLimit = 5;

expt.enable3D = 0;

expt.M = paramSetRow(1);

expt.txtCount = 50;

expt.R = 0.5;

expt.textured = 0;

expt.camouflage = 0;

expt.dynamicBackground = 0;

expt.funcMotionX = @(t) paramSetRow(3) * t * 500 ;

expt.stepDX = paramSetRow(2) / 100 * expt.M;

expt.bugVisible = 0;

[~, ~, ~, exitCode, dump] = runAnimation2(expt);

end

function resultRow = runAfterTrial(varargin)

resultRow = getDirectionJudgement();

end
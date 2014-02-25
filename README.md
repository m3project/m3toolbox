## Man, Mantis and Machine (M3) Project Toolbox 

### Overview

This is a Matlab toolbox developed by the Man, Mantis and Machine (M3) project team at the Institute of Neuroscience (ION), Newcastle University, UK. The toolbox is being used by a number of undergrad and postgrad students to develop visual stimuli, run psychophysics experiments, collect data and build computational models of the visual system of the praying mantis.

#### Features

The toolbox contains a hierarchy of scripts which are meant to increase coding productivity, help standardize the structure of collected data, facilitate code-reuse and improve maintainability. In particular, it provides:

1. **Useful wrappers for Psychtoolbox functions**. These are contained in the directory *ptb-wrappers* and are used as building blocks for developing the toolbox stimuli. The wrappers are self-contained and do not build on any other scripts within the toolbox.

2. **Parameterizable visual stimuli**. These are used primarily to conduct visual psychophyics experiments on praying mantids but may also be useful for experiments involving other animals.

3. **Base code for prototyping and running psychophysics experiments**. This can be used to code experiments quickly without worrying about saving data in an organized format or coding runtime timing statistics  such as estimated completion time.

### Installation

#### Dependencies

The visual stimuli in this toolbox are built on top of the [Psychphysics Toolbox]((http://psychtoolbox.org/PsychtoolboxDownload/)). This must be installed and setup correctly together with its own dependencies (including [GStreamer](http://gstreamer.freedesktop.org/)) before using the visual stimuli.

#### Steps

1. Clone the repo: `git clone git://github.com/gtarawneh/m3toolbox.git`. 
2. Launch Matlab and `cd` to the toolbox directory
3. Run the script `setupM3Toolbox.m` to add all toolbox sub-directories to your Matlab PATH (run `savepath` to make this permenant).

### Usage

#### Visual Stimuli Demos

If you have Psychtoolbox installed then you can invoke visual stimuli with the default parameter values straight away.

```matlab

runAnimation % render a chequerboard stimulus with a swirling bug

runGrating % render a moving grating

runDots % render a dynamic background with a camouflaged bug (this requires a 3D monitor)
```

#### Programming an Experiment

Use the base script `runExperiment` to develop scripts for your own experiments. The script takes a packed struct containing a set of arguments as an input and will handle the repetitive experiment coding chores while freeing you to code the  stimuli and experiment logic.

The snippet below from the experiment script `runMantisExperimentDX` illustrates the usage of `runExperiment`:

```matlab

function runMantisExperimentDX()

expt = struct;

expt.genParamSetFun = @genParamSet;

expt.runBeforeTrialFun = @runBeforeTrial;

expt.runTrialFun = @runTrial;

expt.runAfterTrialFun = @runAfterTrial;

expt.workDir = 'V:\readlab\Ghaith\m3\data\mantisDX\';

expt.name = 'Mantis Dmax';

expt.recordVideos = 0;

runExperiment(expt);

end
```

The packed struct contains handles to four main functions:

1. `genParamSetFun`: generates the parameter set for the experiment, returns an NxM matrix containing N combinations of M parameters.
2. `runBeforeTrialFun`: executes any pre-trial logic such as rendering a special stimulus to draw the animal's attention before presenting the actual experiment stimulus.
3. `runTrialFun`: executes the trial logic (renders the stimulus). An individual video will be recorded per trial while this function is executing (this can be disabled by setting the recordVideos flag to zero as in the example above).
4. `runAfterTrialFun`: executes any post-trial logic. This is usually to get the experimenter's response for the animal behavior during the trial.

The function signatures and exact usage are best illustrated by examining the experiment scripts in the directory *experiments*.

#### Analysing the Results of an Experiment

The script `runExperiment` saves data in individual folders inside the experiment's working directory. The folder structure is intuitive and is meant to make it easy to extract and analyze collected data.

One folder is created per block (experiment run); this carries the subject name (keyed in by the experimenter at the beginning of each run), a time-stamp, the experimenter's name plus any additional tags which the experimenter wanted to include. Inside each of these folders are placed two files: *params.mat* and *results.mat* which contain the parameter set (generated by `genParamSetFun`) and the corresponding results entered by the experimenter through `runAfterTrialFun`.
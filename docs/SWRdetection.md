# SWR candidate event detection

## Quick and dirty method

This is based on filtering in the ripple band and then thresholding. A dual threshold for inclusion and start/end detection improves on a single threshold.

See the tutorial page [here](https://nbviewer.jupyter.org/github/Summer-MIND/mind_2017/blob/master/Tutorials/SpikeDecoding/spike_decoding_matlab.ipynb#Application-to-decoding-hippocampal-%22replay%22)

## Nice and slow method

Manually identify a training set of 20 or so SWRs using [this script](https://github.com/transedward/hc_replay/tasks/Alyssa_Tmaze/beta/SCRIPT_Manually_Identify_SWRs.m). Then compute their frequency spectrum using SWRfreak.m and detect SWR candidates with amSWR.m. 



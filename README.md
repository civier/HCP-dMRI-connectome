# HCP-dMRI-connetome
MRtrix scripts to generate dense weighted structural connectomes from the Human Connectome Project "minimally pre-processed" diffusion MRI data

group_preprocess - unpack and pre-process the already "minimally preprocessed" diffusion MRI datasets of the HCP. Intended to be run on a workstation.

group_tractography - construct tractograms for all the subjects that were pre-processed. To speed up processing, the tractograms are being constructed in parallel. Intended to be run on a HPC system with a SLURM job scheduler. 

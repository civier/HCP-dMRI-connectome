# HCP-dMRI-connectome
MRtrix scripts to generate dense weighted structural connectomes from the Human Connectome Project "minimally pre-processed" diffusion MRI data

If utilised in your publication, please cite:

Civier, O., Smith, R. E., Yeh, C. H., Connelly, A., & Calamante, F. (2019). Is removal of weak connections necessary for graph-theoretical analysis of dense weighted structural connectomes from diffusion MRI? NeuroImage. http://doi.org/10.1016/j.neuroimage.2019.02.039

group_preprocess - unpack and pre-process the already "minimally preprocessed" diffusion MRI datasets of the HCP. Intended to be run on a workstation.

group_tractography - construct tractograms for all the subjects that were pre-processed. To speed up processing, the tractograms are being constructed in parallel. Intended to be run on a HPC system with a SLURM job scheduler. 

Please contact me at orenciv@gmail.com for the scripts for the last two stages: SIFT2, and connectome computation.

!#/bin/bash -v

################################################################################
#
# group_tractography
# ------------------
# 
# Submit multiple jobs to constrct subject tractograms
#
################################################################################
#
# Usage  : group_tractography.sh
#	   (Subject subdirectories should be organized below ./hcp)
#
# Output : tractograms for all subjects
#
# Notes  : HCP should run SLURM
#
# Author : Oren Civier
# Version: 1.01
# Date:    19/10/2017 
#
################################################################################

echo "========================================"
echo "Activate TCKGEN jobs"
echo "========================================"

find . -name tracks.tck
find . -name track_weights.txt


# looping over subjects
for n in hcp/* ; do

  # subit job through SLURM
  sbatch subject_tractography.sh ${n}

done

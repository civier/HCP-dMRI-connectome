#!/bin/bash -v
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2048
#SBATCH --partition=main
#SBATCH --time=12:00:00

################################################################################
#
# subject_tractography
# --------------------
# 
# A batch to construct a tractogram for a HCP subject
#
################################################################################
#
# Usage	 : subject_tractography.sh <subject_number>
#	     (Should be ran in the home directory of the subect subdirectories.
#	      Subject subdirectory should include at least these files:
#	        1) wmfod_norm.mif
# 	        2) 5TT.mif
#
# Output : Tractogram for the subject
#	     1) tracks.tck - the tractogram file
#	     2) seeds.txt - the seeds used for tractography
#	     3) tckgen_log.txt - log file
#
# Note   : mrtrix-gcc module should be available
#
# Author : Oren Civier
# Version: 1.01
# Date   : 19/10/2017
#
################################################################################


echo "========================================"
echo "Tractogram reconstruction"
echo "========================================"


echo "start time"
date
echo


echo "temp dir is"
echo $TMPDIR
echo


find . -name tracks.tck
find . -name track_weights.txt


module load mrtrix-gcc

n=$1

  echo "subject: ${n}"
  act_5tt=${n}/5TT.mif
  seed_wm=${n}/seed_wm.nii.gz
  fod=${n}/wmfod_norm.mif


  #### do tracking (specify -number to set the desired track count)
  tckgen \
  -force \
  -algorithm iFOD2 \
  -select 10000000 \
  -cutoff 0.06 \
  -minlength 5.0 \
  -maxlength 300.0 \
  -act ${act_5tt} -backtrack -crop_at_gmwmi \
  -max_attempts_per_seed 1000 \
  -seed_dynamic ${fod} \
  -output_seeds ${n}/seeds.txt \
  ${fod} ${n}/tracks.tck |& tee ${n}/tckgen_log.txt

echo "end time"
date
echo

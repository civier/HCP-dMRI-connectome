#!/bin/bash -v


################################################################################
#
# subject_preprocess
# ----------------
# 
# Pre-process the dMRI data for a single HCP subject using multi-shell CSD
#
################################################################################
#
# Usage	 : subject_preprocess.sh
#	     (should be ran at the top of the subject's directory tree structure.
#	   Directory tree structure must include:
#	     1) data.nii.gz - dwi data
# 	     2) bvecs - diffusion directions
# 	     3) bvals - b-values for each direction
# 	     4) T1w_acpc_dc_restore_brain.nii.gz - structural image
#
# Output : Preprocessed files required for tractography:
#	     1) wmfod_norm.mif - Fiber Orientation Distribution image
#	     2) 5TT.mif - 5 tissue image
#	   (additional intermediate files are generated as well)
#
# Notes	 : Ensure enough space in /tmp directory as some MRtrix commands copy
#	   there .mif files for processing (e.g., dwi2response). 
#
#	   Home directory must include startup_fsl.sh
#
#	   Remove call to mrview if running in batch
#
#	   HCP data is already is already reoriented to AC-PC
#
# Author : Oren Civier
# Version: 1.01
# Date   : 15/8/2018
#
################################################################################

source ~/startup_fsl.sh
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# extracting data.nii.gz to enable memory-mapping. extracted files are about 4.5GB
date
gunzip -c data.nii.gz > data.nii; alert
mrconvert data.nii DWI.mif -fslgrad bvecs bvals -datatype float32 -stride 0,0,0,1 -force -info; alert
rm -f data.nii

# perform mrconvert at the beginning between mif to mif with no options (why?)
# runs multi-threded!
date
dwibiascorrect -ants DWI.mif DWI_bias_ants.mif -bias bias_ants_field.mif -force -info; alert
rm -f DWI.mif

# Extract response function. Uses -stride 0,0,0,1
date
dwi2response dhollander DWI_bias_ants.mif response_wm.txt response_gm.txt response_csf.txt -voxels RF_voxels.mif -force -info; alert

date
dwiextract DWI_bias_ants.mif - -bzero | mrmath - mean meanb0.mif -axis 3 -force -info; alert

# run mreview to verify what voxels response function were taken from
date
mrview meanb0.mif -overlay.load RF_voxels.mif -overlay.opacity 0.5 -force -info 

# Generate mask
date
dwi2mask DWI_bias_ants.mif DWI_mask.mif -force -info; alert

# Generate FODs
date
dwi2fod msmt_csd DWI_bias_ants.mif response_wm.txt wmfod.mif response_gm.txt gm.mif  response_csf.txt csf.mif -mask DWI_mask.mif -force -info; alert
rm -f DWI_bias_ants.mif

# Perform normalization
date
mtnormalise wmfod.mif wmfod_norm.mif gm.mif gm_norm.mif csf.mif csf_norm.mif -mask DWI_mask.mif -check_norm mtnormalise_norm.mif -check_mask mtnormalise_mask.mif -force -info; alert

# Generate a 5 tissue image
date
5ttgen fsl T1w_acpc_dc_restore_brain.nii.gz 5TT.mif -premasked; alert

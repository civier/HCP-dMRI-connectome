#!/bin/bash -v

################################################################################
#
# group_preprocess
# ----------------
# 
# Extracts necessary dMRI and T1 files from HCP datasets and pre-process them
#
################################################################################
#
# Usage  : group_preprocess.sh <path to the directory with the HCP minimally 
#	   "pre-processed" diffusion and structural zip files>
#
# Output : Relevant HCP data files organized by subject (each subject has its own
#	     subdirectory ./<subject_number>)
#          Log of each subjects pre-processing is in 
#	     ./<subject_number>/pre_processing_log_<subject_number>.txt
#
# Author : Oren Civier
# Version: 1.01
# Date:    8/11/2017 
#
################################################################################

HCP_data_dir=$1

# looping over subjects
for n in ${HCP_data_dir}/*Diffusion_preproc.zip; do


  echo "================================="
  echo pre-processing subject ${n}
  echo "================================="


  echo ${n}
  subject=`basename -s _3T_Diffusion_preproc.zip ${n}`
  echo ${subject}


  mkdir ${subject}
  cd ${subject}


          mkdir hcp_preproc
          cd hcp_preproc
                  unzip ${HCP_data_dir}/${subject}_3T_Diffusion_preproc.zip \
                         ${subject}/T1w/Diffusion/bvals \
                         ${subject}/T1w/Diffusion/bvecs \
                         ${subject}/T1w/Diffusion/data.nii.gz; alert
                  ln -s hcp_preproc/${subject}/T1w/Diffusion/bvals ../bvals
                  ln -s hcp_preproc/${subject}/T1w/Diffusion/bvecs ../bvecs
                  ln -s hcp_preproc/${subject}/T1w/Diffusion/data.nii.gz ../data.nii.gz


                  unzip ${HCP_data_dir}/${subject}_3T_Structural_preproc.zip \
                         ${subject}/T1w/T1w_acpc_dc_restore_brain.nii.gz; alert
                  ln -s hcp_preproc/${subject}/T1w/T1w_acpc_dc_restore_brain.nii.gz \
                        ../T1w_acpc_dc_restore_brain.nii.gz
          cd ..


          ../subject_preprocess.sh |& tee pre_processing_log_${subject}.txt
  cd ..
  
done

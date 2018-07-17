#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=4G
#$ -l h_rt=00:10:00
#$ -t 1:2193
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# environment not needed when -V is used 
# FSLDIR="/opt/fmrib/fsl"
# source ${FSLDIR}/etc/fslconf/fsl.sh

PATH_PROJ="${HOME}/UKBB-MH"

SLIST="subjectsN2193_1.txt"
INFO="yeo17"
FILE_ATLAS="${PATH_PROJ}/atlas/Yeo2011_17Networks_N1000_split_components_FSL_MNI152_2mm.nii.gz"

PATH_FMRI="/vols/Data/ukbiobank/FMRIB/IMAGING/data3/SubjectsAll"
FILE_BRAINMASK="${PATH_PROJ}/atlas/brain_mask.nii.gz"
LOG="${PATH_PROJ}/log/roi-${INFO}.log"

MYID=$(echo $(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/${SLIST}) | awk '{ print $1 }')

FILE="${PATH_FMRI}/${MYID}/fMRI/rfMRI.ica/reg_standard/filtered_func_data_clean.nii.gz"
OUT="${HOME}/Drive/ts/${MYID}_${INFO}.txt"
OUTGS="${HOME}/Drive/ts/${MYID}_globalSignal.txt"

if [[ -e "${FILE}" && ! -e "${OUT}" ]] ; then
    fslmeants -i ${FILE} -m ${FILE_BRAINMASK} -o ${OUTGS}
    fslmeants -i ${FILE} --label=${FILE_ATLAS} -o ${OUT}
    echo $(date) $(echo fslmeants -i ${FILE} --label=${FILE_ATLAS} -o ${OUT}) >> $LOG
elif [[ ! -e "${FILE}" ]] ; then
    echo $(date) ERROR ${FILE} not found >> $LOG
fi

#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=4G
#$ -l h_rt=00:05:00
#$ -t 1:158
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# environment not needed when -V is used 
# FSLDIR="/opt/fmrib/fsl"
# source ${FSLDIR}/etc/fslconf/fsl.sh

INFO="limbic"
PATH_FMRI="/vols/Data/ukbiobank/FMRIB/IMAGING/data3/SubjectsAll"
PATH_PROJ="${HOME}/UKBB-MH"
FILE_ATLAS="${PATH_PROJ}/atlas/limbic.nii.gz"
LOG="${PATH_PROJ}/log/roi-limbic.log"

MYID=$(echo $(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/subjectsN158.txt) | awk '{ print $1 }')

FILE="${PATH_FMRI}/${MYID}/fMRI/rfMRI.ica/reg_standard/filtered_func_data_clean.nii.gz"
OUT="${HOME}/Drive/${INFO}/${MYID}_${INFO}.txt"

if [[ -e "${FILE}" && ! -e "${OUT}" ]] ; then
    fslmeants -i ${FILE} --label=${FILE_ATLAS} -o ${OUT}
    echo $(date) $(echo fslmeants -i ${FILE} -m ${PATH_ATLAS}/${ROI} -o ${OUT}) >> $LOG
elif [[ ! -e "${FILE}" ]] ; then
    echo $(date) ERROR ${FILE} not found >> $LOG
fi

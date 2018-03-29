#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=4G
#$ -l h_rt=00:05:00
#$ -t 1:16432
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# environment not needed when -V is used 
# FSLDIR="/opt/fmrib/fsl"
# source ${FSLDIR}/etc/fslconf/fsl.sh

INFO="rois104"
PATH_FMRI="/vols/Data/ukbiobank/FMRIB/IMAGING/data3/SubjectsAll"
PATH_ATLAS="${HOME}/Drive/atlas/Shirer"
PATH_PROJ="${HOME}/Drive/UKBB-MH"
LOG="${PATH_PROJ}/log/roi104.log"

MYID=$(echo $(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/table_${INFO}.txt) | awk '{ print $1 }')
NR=$(echo $(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/table_${INFO}.txt) | awk '{ print $2 }')
ROI=$(echo $(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/table_${INFO}.txt) | awk '{ print $3 }')

FILE="${PATH_FMRI}/${MYID}/fMRI/rfMRI.ica/reg_standard/filtered_func_data_clean.nii.gz"
OUT="${HOME}/Drive/results/${INFO}/${MYID}_$(printf '%02d' ${NR})_${INFO}.txt"

if [[ -e "${FILE}" && ! -e "${OUT}" ]] ; then
    fslmeants -i ${FILE} -m ${PATH_ATLAS}/${ROI} -o ${OUT}
    echo $(date) $(echo fslmeants -i ${FILE} -m ${PATH_ATLAS}/${ROI} -o ${OUT}) >> $LOG
elif [[ ! -e "${FILE}" ]] ; then
    echo $(date) ERROR ${FILE} not found >> $LOG
fi

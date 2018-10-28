#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=4G
#$ -l h_rt=00:15:00
#$ -t 1:4308
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# environment not needed when -V is used 
# FSLDIR="/opt/fmrib/fsl"
# source ${FSLDIR}/etc/fslconf/fsl.sh

PATH_PROJ="${HOME}/UKBB-MH"
PATH_OUT="${HOME}/Drive/UKBB-MH/ts/yeo"

LIST1="subjectsN2193_1.txt"
LIST2="subjectsN2115_2.txt"
INFO1="yeo17"
INFO2="yeo7"
FILE_ATLAS1="${PATH_PROJ}/atlas/Yeo2011_17Networks_N1000_split_components_FSL_MNI152_2mm.nii.gz"
FILE_ATLAS2="${PATH_PROJ}/atlas/Yeo2011_7Networks_N1000.split_components.FSL_MNI152_2mm.nii.gz"

PATH_FMRI="/vols/Data/ukbiobank/FMRIB/IMAGING/data3/SubjectsAll"
FILE_BRAINMASK="${PATH_PROJ}/atlas/brain_mask.nii.gz"
LOG="${PATH_PROJ}/log/ts-${INFO1}_${INFO2}.log"

MYID=$(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/${LIST1} ${PATH_PROJ}/results/${LIST2})

FILE="${PATH_FMRI}/${MYID}/fMRI/rfMRI.ica/reg_standard/filtered_func_data_clean.nii.gz"
OUT1="${PATH_OUT}/${MYID}_${INFO1}.txt"
OUT2="${PATH_OUT}/${MYID}_${INFO2}.txt"
OUTGS="${PATH_OUT}/${MYID}_globalSignal.txt"

if [[ -e "${FILE}" && ! -e "${OUT1}" ]] ; then
    fslmeants -i ${FILE} --label=${FILE_ATLAS1} -o ${OUT1}
    echo $(date) $(echo fslmeants -i ${FILE} --label=${FILE_ATLAS1} -o ${OUT1}) >> $LOG
fi

if [[ -e "${FILE}" && ! -e "${OUT2}" ]] ; then
    fslmeants -i ${FILE} --label=${FILE_ATLAS2} -o ${OUT2}
    echo $(date) $(echo fslmeants -i ${FILE} --label=${FILE_ATLAS2} -o ${OUT2}) >> $LOG
fi

if [[ -e "${FILE}" && ! -e "${OUTGS}" ]] ; then
    fslmeants -i ${FILE} -m ${FILE_BRAINMASK} -o ${OUTGS}
    echo $(date) $(echo fslmeants -i ${FILE} --label=${FILE_BRAINMASK} -o ${OUTGS}) >> $LOG
fi

if [[ ! -e "${FILE}" ]] ; then
    echo $(date) ERROR ${FILE} not found >> $LOG
fi

#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=4G
#$ -l h_rt=00:15:00
#$ -t 1:15133
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

PATH_BB="${HOME}/ukbiobank"
PATH_OUT="${PATH_BB}/lines"
file='ukb8252.tab'
subs='subjects-090318.txt'

# subject ID (imaging subject ID per task)
MYID=$(sed "${SGE_TASK_ID}q;d" $PATH_BB/$subs)

# fetch line no. and extract line from biobank
nr=$(grep -n ${MYID} ${PATH_BB}/${file}.ids | awk -F ":" '{ print $1 }')
sed "${nr}q;d" ${PATH_BB}/${file} > ${PATH_OUT}/${MYID}.tab

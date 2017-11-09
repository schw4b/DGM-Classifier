#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -l h_vmem=512M
#$ -l h_rt=00:01:00
#$ -t 1:5
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log


echo $SGE_TASK_ID > $HOME/results/example/data$SGE_TASK_ID.txt

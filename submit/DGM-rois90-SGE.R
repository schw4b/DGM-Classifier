#!/usr/bin/env Rscript
#$ -S /usr/bin/Rscript
#$ -V
#$ -q long.q
#$ -l h_vmem=512M
#$ -l h_rt=08:00:00
#$ -t 451:900
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# @libraries and paths ----
library(multdyn)
#library(testit)
library(data.table)

PATH_TS  = '~/Drive/results/rois90_concat/'
PATH_RES = '~/Drive/results/DGM_rois90'
INFO     = 'rois90'

N  = 18
Nn = 90
Nt = 490 # Volumes/no. of timepoints

# @read subject IDs and subject data ----
SUBJECTS = as.matrix(read.table(file.path('~/Drive/results/', 'subj_N18.txt')))
#assert(length(SUBJECTS)==N)

# @lookup table across subjects and nodes ----
mysubs = sort(rep(SUBJECTS,Nn))
mynodes = rep(1:Nn,N)
TABLE = cbind(mysubs,mynodes)

# @load data of subject ----
l = as.numeric(Sys.getenv("SGE_TASK_ID")) # line iterator for Lookup TABLE that runs multicore
f=list.files(PATH_TS, glob2rx(paste(TABLE[l,1], '*.txt', sep="")))

# read data
d = as.matrix(fread(file.path(PATH_TS, f)))
#assert(nrow(d) == Nt)
#assert(ncol(d) == Nn)

# mean center time series
d=scaleTs(d)

# calculate networks, will write txt files
if(!file.exists(file.path(PATH_RES,sprintf("%d_%s_node_%03d.txt", TABLE[l,1], INFO, TABLE[l,2])))) {
   m=node(d, TABLE[l,2], id=sprintf("%d_%s", TABLE[l,1], INFO),
          path = PATH_RES, method="both")
}

q(save="no")

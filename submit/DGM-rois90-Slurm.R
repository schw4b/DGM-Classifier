#!/usr/bin/env Rscript

# libraries and paths ----
library(DGM)
library(testit)
library(data.table)

PATH_TS  = '~/Drive/rois90_concat'
PATH_RES = '~/Drive/DGM_rois90'
PATH_PROJ='~/DGM-Classifier'
INFO     = 'rois90'

# variables ----
N  = 20
Nn = 90
Nt = 490 # no. of samples

# read subject IDs ----
SUBJECTS = as.matrix(read.table(file.path(PATH_PROJ, 'results', 'subj_N20.txt')))

# create a lookup table across subjects and nodes ----
mysubs = sort(rep(SUBJECTS[1:N],Nn))
mynodes = rep(1:Nn,N)
TABLE = cbind(mysubs,mynodes)

# assign task ID ----
l = as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID")) # iterator for lookup TABLE that runs multicore

# read data if available
if(file.exists(file.path(PATH_TS,sprintf("%d_ts_%s.txt", TABLE[l,1], INFO)))) {
   
   # read data
   f = list.files(PATH_TS, glob2rx(paste(TABLE[l,1], '*.txt', sep="")))
   d = as.matrix(fread(file.path(PATH_TS, f)))
   d = d[1:Nt,1:Nn] # cuttoff for subjects with more samples
   assert(nrow(d) == Nt)
   assert(ncol(d) == Nn)

   # mean center time series
   d=scaleTs(d)

   # calculate networks, will write txt files
   if(!file.exists(file.path(PATH_RES,sprintf("%d_%s_node_%03d.txt", TABLE[l,1], INFO, TABLE[l,2])))) {
      m=node(d, TABLE[l,2], id=sprintf("%d_%s", TABLE[l,1], INFO),
             path = PATH_RES, method="both")
   }

}

q(save="no")

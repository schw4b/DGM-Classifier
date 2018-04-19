#!/usr/bin/env Rscript

# l:wqibraries and paths ----
library(DGM)
library(testit)
library(data.table)

PATH_TS  = '~/Drive/rois104_concat'
PATH_RES = '~/Drive/DGM_rois104'
PATH_PROJ= '~/UKBB-MH'
INFO     = 'DMN'

# variables ----
N  = 135
Nn = 19
Nt = 490 # no. of samples

# read subject IDs ----
f = list.files(path=PATH_TS, pattern=sprintf('*%s.txt', INFO))
assert(length(f) == N)
EIDS = substring(f, 1, 7)

# create a lookup table across subjects and nodes ----
mysubs = sort(rep(EIDS[1:N],Nn))
mynodes = rep(1:Nn,N)
TABLE = cbind(mysubs,mynodes)

# assign task ID ----
l = as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID")) # iterator for lookup TABLE that runs multicore

# read data
f = list.files(path=PATH_TS, pattern=sprintf('%s_%s.txt', TABLE[l,1], INFO))
d = as.matrix(fread(file.path(PATH_TS, f)))
d = d[1:Nt,1:Nn] # cuttoff for subjects with more samples
assert(nrow(d) == Nt)
assert(ncol(d) == Nn)

# mean center time series
d=scaleTs(d)

# calculate networks, will write txt files
if (!file.exists(file.path(PATH_RES,sprintf("%s_%s_node_%03d.txt", TABLE[l,1], INFO, as.numeric(TABLE[l,2]))))) {
   m=node(d, as.numeric(TABLE[l,2]), id=sprintf("%s_%s", TABLE[l,1], INFO),
          path = PATH_RES, method="exhaustive")
}

q(save="no")

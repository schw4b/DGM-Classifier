#!/usr/bin/env Rscript
#$ -S /usr/bin/Rscript
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=4G
#$ -l h_rt=00:05:00
#$ -t 1:15133
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# @libraries and paths ----
PATH='~/ukbiobank'
PATH_OUT=file.path(PATH, 'icd')

l = as.numeric(Sys.getenv("SGE_TASK_ID"))

load(file.path(PATH, 'eids.RData'))
if (!file.exists(file.path(PATH_OUT, paste(eids[l], 'RData', sep='.')))) {

  library(ukbtools)
  load(file.path(PATH, 'ukbiobank.varfix.RData'))

  icd=ukb_icd_diagnosis(my_ukb_data, id = eids[l], icd.version = 10)
  if (is.null(icd)) {
     icd = NA
  }

  save(icd, file = file.path(PATH_OUT, paste(eids[l], 'RData', sep = ".")))
}

q(save="no")

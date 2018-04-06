# select network nodes from the extracted time series
# by Simon Schwab

library(testit)

PATH='~/ukbiobank'
PATH_PROJ='~/Drive/UKBB-MH'
PATH_TS='~/Drive/results/rois104'
PATH_OUT='~/Drive/results/rois104_concat'

load(file.path(PATH, 'groups.RData'))
N=nrow(subjects)

d.rois = read.table(file = file.path(PATH_PROJ, 'results', 'roi104_order.txt'))

# regular expressions to define nodes
idx_Nn14 = grepl(pattern = 'nii.gz$', d.rois$V2)
idx_Nn66 = grepl(pattern = '\\<(anterior_Salience|Basal_Ganglia|dorsal_DMN|Language|LECN|post_Salience|Precuneus|RECN|ventral_DMN)\\>/[0-9][0-9]/([0-9]|[0-9][0-9]).nii$', d.rois$V2)

labels=list()
labels$Nn14 = d.rois$V2[idx_Nn14]
labels$Nn66 = d.rois$V2[idx_Nn66]

# based on the selection of nodes, create data files of Nn columns
f = list.files(path = PATH_TS, pattern = ".txt")

# quick run to derermine no. of volumes
no_of_vols=rep(NA, N)
for (s in 1:N) {
  if (subjects$hasfMRI[s]) {
    f = list.files(path = PATH_TS, pattern = as.character(subjects$eid[s]))
    tmp = read.table(file = file.path(PATH_TS, f[1]))
    no_of_vols[s] = length(tmp$V1)
  }
}
subjects$no_of_vols=no_of_vols
# save(subjects, file = file.path(PATH, 'UKBB-MH.RData'))

for (s in 1:N) {
  if (subjects$hasfMRI[s]) {
    print(paste(as.character(subjects$eid[s]), 'running!'))
    # all time series
    f = list.files(path = PATH_TS, pattern = as.character(subjects$eid[s]))
    assert(length(f) == 104)
    
    # selecton of time series
    f.14 = f[idx_Nn14]
    f.66 = f[idx_Nn66]
    
    # concat the selected time series column wise
    m.14 = array(NA, dim=c(subjects$no_of_vols[s],14))
    m.66 = array(NA, dim=c(subjects$no_of_vols[s],66))
    
    colnames(m.14) = labels$Nn14
    colnames(m.66) = labels$Nn66
    
    for (t in 1:length(f.14)) {
      tmp = read.table(file = file.path(PATH_TS, f.14[t]))
      m.14[,t] = tmp$V1
    }
    
    for (t in 1:length(f.66)) {
      tmp = read.table(file = file.path(PATH_TS, f.66[t]))
      m.66[,t] = tmp$V1
    }
    
    # write dataset per subject
    write.table(m.14, file = file.path(PATH_OUT, paste(subjects$eid[s], 'Nn14.txt', sep = "_")), row.names = F)
    write.table(m.66, file = file.path(PATH_OUT, paste(subjects$eid[s], 'Nn66.txt', sep = "_")), row.names = F)
  }
}

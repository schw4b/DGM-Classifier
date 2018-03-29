# create jobs table for SGE job
# by Simon Schwab
PATH='~/ukbiobank'
PATH_PROJ='~/Drive/UKBB-MH/'
ATLAS_SHIRER = '~/Drive/atlas/Shirer'
SUBJFILE = file.path(PATH_PROJ, 'results', 'subjectsN158.txt')
N=158
Nn=104

f=list.files(pattern = ".nii",path = ATLAS_SHIRER, recursive = TRUE)
write.table(f, file=file.path(PATH_PROJ, 'results', 'roi104_order.txt'), col.names = FALSE)


myrois=rep(f,N)
subj=as.matrix(read.table(file=SUBJFILE, nrows = N))
mysubj=sort(rep(subj,Nn))
mynr = rep(1:Nn, N)

TABLE=cbind(mysubj, mynr, myrois)
write(t(TABLE), file=file.path(PATH_PROJ, 'results', 'table_rois104.txt'), ncolumns = 3)

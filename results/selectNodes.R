# select network nodes from the extracted time series
# by Simon Schwab

PATH_PROJ='~/Drive/UKBB-MH'
PATH_TS='~/Drive/results/rois104'
PATH_Nn14='~/Drive/results/rois014'
PATH_Nn66='~/Drive/results/rois066'

d = read.table(file = file.path(PATH_PROJ, 'results', 'roi104_order.txt'))

# regular expressions to define nodes
idx_Nn14 = grepl(pattern = 'nii.gz$', d$V2)
idx_Nn66 = grepl(pattern = '\\<(anterior_Salience|Basal_Ganglia|dorsal_DMN|Language|LECN|post_Salience|Precuneus|RECN|ventral_DMN)\\>/[0-9][0-9]/([0-9]|[0-9][0-9]).nii$', d$V2)

labels=list()
labels$Nn14 = d$V2[idx_Nn14]
labels$Nn66 = d$V2[idx_Nn66]
# 
# ls $PATH_RESULTS | awk -F "_" '{ print $1 }' | uniq | while read line; do
#    if [[ ! -e "${PATH_RESULTS_CONCAT}/${line}_ts_rois90.txt" ]] ; then
#       paste $PATH_RESULTS/${line}_[0-9][0-9]_rois90.txt > ${PATH_RESULTS_CONCAT}/${line}_ts_rois90.txt
#       echo concatenated $line
#    fi
# done


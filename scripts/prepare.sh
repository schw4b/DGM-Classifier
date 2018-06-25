# create imaging subject list
PATH_IMG='/vols/Data/ukbiobank/FMRIB/IMAGING/data3'
PATH_BB="${HOME}/ukbiobank"
file='ukb8252.tab'

# Create list of EIDS
cat $PATH_IMG/subjects/subj.txt $PATH_IMG/subjects2/subj.txt $PATH_IMG/subjects3/subj.txt > $PATH_BB/subjects-090318.txt

# Detach IDs from BB for speed
cat $file | awk '{ print $1}' > $file.ids

# Extract imaging UKBB individuals
# Run fetchBB.sh
# This will write a file per subject/line in the UKBB

# Create UKBB imaging DB
head -1 ukb8252.tab > header.tab
cat header.tab lines/* > ukbiobank.tab

# Clean up
# Manually replace Builders Merchant\"s with Builders Merchant\'s

# rename flles: leading digit for node numbers: _99_ to _099_
# eg 1234567_99_rois104.txt 1234567_099_rois104.txt
for file in `ls *.txt`; do echo $file `echo $file|sed  -r 's/([0-9]{7})_([0-9]{2})_(rois104)/\1_0\2_\3/'` ; done

# extract some variables from Steve's workspace
cd('~/ukbiobank')
N=length(FMRIB_info(:,1));

fid = fopen('more_age.txt','w');
fprintf(fid, '%s %s %s\n', 'eid', 'age_2_0', 'scanDate');
for i=1:N   
   fprintf(fid, '%d %f %f\n', FMRIB_info(i,1), age(i),scan_date(i));
end

fclose(fid);
   

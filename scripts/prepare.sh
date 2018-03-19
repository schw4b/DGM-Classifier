# create imaging subject list
PATH_IMG='/vols/Data/ukbiobank/FMRIB/IMAGING/data3'
PATH_BB="${HOME}/ukbiobank"
file='ukb8252.tab'

# Create list of EIDS
cat $PATH_IMG/subjects/subj.txt $PATH_IMG/subjects2/subj.txt $PATH_IMG/subjects3/subj.txt > $PATH_BB/subjects-090318.txt

# create decouple ID from BB for speed
cat $file | awk '{ print $1}' > $file.ids

# Extract imaging UKBB individuals
# Run fetchBB.sh
# This will write a file per subject/line in the UKBB

# Create UKBB imaging DB
head -1 ukb8252.tab > header.tab
cat header.tab lines/* > ukbiobank.tab

# Clean up
# Manually replace Builders Merchant\"s with Builders Merchant\'s
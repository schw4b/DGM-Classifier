# UKBB-MH

UK Biobank: Linking directed dynamic brain networks to mental health

## Notebooks with results and figures
- [R Notebook](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH.nb.html)


prepare.sh

Creates a list of subjects that have imaging and extracts all information from UKBB (N=500K) into a database (ukbiobank.tab, N=15K).

fetchBB.sh

SGE job to extract the subjects from UKBB.



fetchICD.R
Fetch all the ICD-10 diagnoses and writes a file per subject.


jobsTable.R
creates a lookup table (table_rois104.txt) with subject ID, ROI NR, and ROI mask filename.

rois104.sh

Extracts time series of 104 nodes into single files (SGE job). Uses table_104.txt as lookup table. One file per subject and node, see folder rois104, see roi104_order.txt for ROI labels

selectNodes.R

Generates time series data file for DGM analysis per network. Contains regulatar expressions for node selection of the networks under study.

Jobs for Slurm to run DGM
job-$NET-Slurm.sh
job-$NET-Slurm.R

createGroups.R
Creates the final population on healthy controls and patients according to inclusion/exclusion cirteria. Creates a age and gender matched control sample.  Checks if subjects have a fMRI dataset.

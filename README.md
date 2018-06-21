# UKBB-MH

UK Biobank: Linking directed dynamic brain networks to mental health

## Notebooks with results and figures
- [Demographics Sample 1](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Demographics-1.nb.html) [Demographics Sample 2](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Demographics-2.nb.html)
- [Limbic](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-limbic.nb.html)
- [DMN](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-DMN.nb.html)
- [RSN](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-RSN.nb.html)
- [Salience](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Salience.nb.html)

## Description of processing pipeline

### Prepare Biobank Raw data

* `prepare.sh` creates a list of subjects that have brain imaging and extracts all information from UKBB (N=500,000) into a database (`ukbiobank.tab`, N=15,133). `fetchBB.sh` is a SGE job to extract the individuals/rows from the UKBB.

### Prepare group samples of interest

* `createGroups.R` fixes some duplicated variable names and saves data in `ukbiobank.varfix.RData`, the final data container. Checks rs-fMRI data availability `hasfMRI.RData` and concatenates the ICD diagnoses into a list `ICD.RData`. Creates a file `MYUKBB.RData`, this is the final database to sample the groups from with all relevant demographics, diagnoses, and mental variables, N=15,133.
Stores final groups with all relevant fields in `UKBB-MH.RData` and creates a list of EIDs `subjectsN3000.txt`.

* `fetchICD.R` SGE job that fetches all the ICD-10 diagnoses and writes a file per subject.

* Demographics of the groups are analysed in `UKBB-MH-Demographics-1.Rmd`, and of an independent sample in `UKBB-MH-Demographics-2.Rmd`

* `jobsTable.R` creates a lookup table (`table_rois104.txt`) with subject ID, ROI NR, and ROI mask filename.

* `rois104.sh` SGE job that extracts time series of 104 nodes into separate files. Uses `table_rois104.txt` as lookup table. One file per subject and node is written, see folder `rois104`. `roi104_order.txt` shows ROI label ordering.

* `selectNodes.R` generates time series data file (one per subject) for DGM analysis.

* Jobs for Slurm to run DGM: `job-$NET-Slurm.sh and` and `job-$NET-Slurm.R`

* `createGroups.R` creates the final population patient sample according to inclusion/exclusion criteria. Creates a age and gender matched control sample. Checks if subjects have a fMRI dataset.

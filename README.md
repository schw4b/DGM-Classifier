# UKBB-MH

UK Biobank: Linking directed dynamic brain networks to mental health

## Notebooks with results and figures
- [Demographics](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Demographics.nb.html)
- [DMN](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-DMN.nb.html)
- [RSN](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-RSN.nb.html)
- [Salience](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Salience.nb.html)

## Description of processing pipeline

* `prepare.sh` creates a list of subjects that have brain imaging and extracts all information from UKBB (N=500K) into a database (`ukbiobank.tab`, N=15K). * `fetchBB.sh` SGE job to extract the subjects from UKBB.

* `fetchICD.R` SGE job that fetches all the ICD-10 diagnoses and writes a file per subject.
 healthy controls
* `jobsTable.R` creates a lookup table (`table_rois104.txt`) with subject ID, ROI NR, and ROI mask filename.

* `rois104.sh` SGE job that extracts time series of 104 nodes into separate files. Uses `table_rois104.txt` as lookup table. One file per subject and node is written, see folder `rois104`. `roi104_order.txt` shows ROI label ordering.

* `selectNodes.R` generates time series data file (one per subject) for DGM analysis.

* Jobs for Slurm to run DGM: `job-$NET-Slurm.sh and` and `job-$NET-Slurm.R`

* `createGroups.R` creates the final population patient sample according to inclusion/exclusion criteria. Creates a age and gender matched control sample. Checks if subjects have a fMRI dataset.

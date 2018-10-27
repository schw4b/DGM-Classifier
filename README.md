# UKBB-MH

UK Biobank: Linking directed dynamic brain networks to mental health

## Notebooks with results and figures
- [Demographics](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Demo.nb.html)
- [Limbic](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-limbic.nb.html)
- [DMN](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-DMN.nb.html)
- [RSN](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-RSN.nb.html)
- [Salience](https://rawgit.com/schw4b/UKBB-MH/master/results/UKBB-MH-Salience.nb.html)

## Description of processing pipeline

### Prepare Biobank Raw data

* `prepare.sh` creates a list of subjects that have brain imaging and extracts all information from UKBB (N=500,000) into a database (`ukbiobank.tab`, N=15,133). `fetchBB.sh` is a SGE job to extract the individuals (rows) from the UKBB.

### Prepare group samples of interest

* `createGroups.R` fixes some duplicated variable names and saves data in `ukbiobank.varfix.RData`. Also checks the rs-fMRI data availability in `hasfMRI.RData` and concatenates the ICD diagnoses into a list `ICD.RData`. The routine creates a file `MYUKBB.RData`, this is the final database to sample the groups from with all relevant demographics, diagnoses, and mental variables, N=15,133. Final groups are being stored with all relevant fields in `UKBB-MH.RData` with a list of EIDs `subjectsNXXXX.txt`. `fetchICD.R` is the SGE job that fetches all the ICD-10 diagnoses and writes a file per subject.

* `createGroups.R` creates the final patient cohort according to th lifetime major depression status (Smith et al.; 2013, Plos One) and additional exclusion criteria. Creates a age, gender, educaton, ethnicity, and motion-artefact matched control sample using propensity score matching (R package "matchit"). Also checks, if subjects have a fMRI dataset (passed quality control).

* Demographics of the groups are analysed in `UKBB-MH-Demographics.Rmd`.

* `selectNodes.R` generates time series data file (one per subject) for DGM analysis.

* Jobs for Slurm: `job-$foo.sh`. Shell scripts `.sh` extract node time series, and `.R` files run DGM.



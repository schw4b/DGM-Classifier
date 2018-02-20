#!/bin/sh

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=schwab@upd.unibe.ch
#SBATCH --time=12:00:00
#SBATCH --job-name=DGM-rois90
#SBATCH --mem-per-cpu=512M
#SBATCH --output=log/slurm/slurm-%j.out
#SBATCH --error=log/slurm/slurm-%j.out
#SBATCH --array=1-900

# submit is a symlink
srun submit/DGM-rois90-Slurm.R

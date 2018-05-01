#!/bin/sh

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=schwab@upd.unibe.ch
#SBATCH --time=25:00:00
#SBATCH --job-name=DGM-Salience
#SBATCH --mem-per-cpu=512M
#SBATCH --output=log/slurm/slurm-%j.out
#SBATCH --error=log/slurm/slurm-%j.out
#SBATCH --array=1-2000

# submit is a symlink
srun submit/DGM-Salience-Slurm.R

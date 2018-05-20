#!/bin/sh

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=schwab@upd.unibe.ch
#SBATCH --time=00:30:00
#SBATCH --job-name=DGM-limbic
#SBATCH --mem-per-cpu=512M
#SBATCH --output=log/slurm/slurm-%j.out
#SBATCH --error=log/slurm/slurm-%j.out
#SBATCH --array=1-1890

# submit is a symlink
srun submit/DGM-limbic-Slurm.R

#!/bin/bash
#SBATCH --partition=batch
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --time=02:00:00
#SBATCH --mem=32G
#SBATCH --job-name=mpi_job
#SBATCH --output=mpi_job-%j.out
#SBATCH --error=mpi_job-%j.err

set -euo pipefail

module load hpcx-mpi/4.1.5rc2s

srun --mpi=pmix ./MyMPIProgram

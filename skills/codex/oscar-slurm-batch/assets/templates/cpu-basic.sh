#!/bin/bash
#SBATCH -J cpu_job
#SBATCH -p batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH -t 01:00:00
#SBATCH -o cpu_job-%j.out
#SBATCH -e cpu_job-%j.err

set -euo pipefail

module load miniforge3/25.3.0-3
source ${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh

CONDA_ENV=${CONDA_ENV:-torch}
REPO_ROOT=${REPO_ROOT:-/path/to/project}

export OMP_NUM_THREADS=${OMP_NUM_THREADS:-8}
export MKL_NUM_THREADS=${MKL_NUM_THREADS:-8}
export OPENBLAS_NUM_THREADS=${OPENBLAS_NUM_THREADS:-8}
export NUMEXPR_NUM_THREADS=${NUMEXPR_NUM_THREADS:-8}
export PYTHONUNBUFFERED=1

conda activate ${CONDA_ENV}
cd ${REPO_ROOT}

python -u /path/to/script.py

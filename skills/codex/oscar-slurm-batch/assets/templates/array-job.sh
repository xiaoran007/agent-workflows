#!/bin/bash
#SBATCH -J array_job
#SBATCH -p batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH -t 01:00:00
#SBATCH --array=1-16
#SBATCH -o array_job-%A_%a.out
#SBATCH -e array_job-%A_%a.err

set -euo pipefail

module load miniforge3/25.3.0-3
source ${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh

CONDA_ENV=${CONDA_ENV:-torch}
REPO_ROOT=${REPO_ROOT:-/path/to/project}
TASK_ID="${SLURM_ARRAY_TASK_ID}"

export PYTHONUNBUFFERED=1

conda activate ${CONDA_ENV}
cd ${REPO_ROOT}

python -u /path/to/run_one.py --task-id "${TASK_ID}"

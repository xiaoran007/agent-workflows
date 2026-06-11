#!/bin/bash
#SBATCH -J gpu_train
#SBATCH -p gpu
#SBATCH --constraint=ampere
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=24G
#SBATCH -t 04:00:00
#SBATCH -o gpu_train-%j.out
#SBATCH -e gpu_train-%j.err

set -euo pipefail

module load miniforge3/25.3.0-3
module load ffmpeg
source ${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh

CONDA_ENV=${CONDA_ENV:-torch}
REPO_ROOT=${REPO_ROOT:-/path/to/project}
CONFIG_PATH=${CONFIG_PATH:-configs/experiment.yaml}

export OMP_NUM_THREADS=${OMP_NUM_THREADS:-6}
export MKL_NUM_THREADS=${MKL_NUM_THREADS:-6}
export OPENBLAS_NUM_THREADS=${OPENBLAS_NUM_THREADS:-6}
export NUMEXPR_NUM_THREADS=${NUMEXPR_NUM_THREADS:-6}
export PYTHONUNBUFFERED=1

conda activate ${CONDA_ENV}
cd ${REPO_ROOT}

python -u train.py --config ${CONFIG_PATH}

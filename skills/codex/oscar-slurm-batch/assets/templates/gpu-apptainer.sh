#!/bin/bash
#SBATCH -J gpu_container
#SBATCH -p gpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH -t 04:00:00
#SBATCH -o gpu_container-%j.out
#SBATCH -e gpu_container-%j.err

set -euo pipefail

export APPTAINER_BINDPATH="/oscar/home/$USER,/oscar/scratch/$USER,/oscar/data"

srun apptainer exec --nv /path/to/container.simg python /path/to/train.py

# Oscar Slurm Reference

## Core Rules

- Never run long, CPU-intensive, memory-intensive, or GPU workloads directly on login nodes.
- Use batch jobs for long-running work; use interactive jobs only for short debugging or GUI work.
- Put all `#SBATCH` directives before the first executable command.
- Oscar jobs inherit the shell environment from the submission session by default.
- If resources are omitted, expect a small default allocation: 1 core and about 2.8 GB per core.
- Smaller, realistic resource requests usually queue faster.

## Common Partitions

- `batch`: default general CPU compute.
- `debug`: short CPU debugging jobs with shorter wait and runtime.
- `gpu`: standard GPU jobs.
- `gpu-debug`: short GPU debugging jobs.
- `gpu-he`: high-end GPU partition, such as V100/H100-class needs when available.
- `vnc`: graphical desktop workflows.
- `bigmem`: memory-intensive jobs.
- `gracehopper`: Grace Hopper GH200 jobs.

## Common Directives

```bash
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH --job-name=my_job
#SBATCH --output=my_job-%j.out
#SBATCH --error=my_job-%j.err
```

- Use `--ntasks` for separate processes, especially MPI ranks.
- Use `--cpus-per-task` for threads used by one task, such as OpenMP or dataloader workers.
- Use `--mem=` for total memory per node.
- Use `--gres=gpu:N` for GPU count.
- Use `--constraint=` only when a specific node feature or GPU type is required, such as `ampere`, `geforce3090`, `v100`, `h100`, `mig`, or `nomig`.
- Use `--account=` only when the user has a project, Condo, or special allocation account.
- Use `%j` for job ID, `%x` for job name, `%A` for array job ID, and `%a` for array task ID in logs.
- Existing project scripts often use short forms like `-J`, `-p`, `-n`, `-t`, `-o`, and `-e`; preserve that style when editing an existing file.

## Submission

```bash
sbatch submit_job.sh
sbatch -n 4 --mem=16G -t 01:00:00 submit_job.sh
```

Command-line `sbatch` flags override matching directives inside the script.

## Conda Python Jobs

This user's working Oscar scripts commonly use Miniforge and direct Python execution:

```bash
module load miniforge3/25.3.0-3
source ${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh
conda activate torch

cd /users/tfang11/code/project

export PYTHONUNBUFFERED=1
python -u script.py --config config.yaml
```

For B-Gait-style scripts, parameterize reusable paths with shell defaults:

```bash
CONDA_ENV=${CONDA_ENV:-torch}
REPO_ROOT=${REPO_ROOT:-/users/tfang11/code/B-Gait}

export OMP_NUM_THREADS=${OMP_NUM_THREADS:-8}
export MKL_NUM_THREADS=${MKL_NUM_THREADS:-8}
export OPENBLAS_NUM_THREADS=${OPENBLAS_NUM_THREADS:-8}
export NUMEXPR_NUM_THREADS=${NUMEXPR_NUM_THREADS:-8}

conda activate ${CONDA_ENV}
cd ${REPO_ROOT}
```

Do not add `srun` to ordinary single-node Python/conda scripts unless the user asks for that style or the program is explicitly Slurm/MPI-aware.

## GPU Deep Learning

For conda-managed GPU Python jobs, use the Conda Python pattern with:

```bash
#SBATCH -p gpu
#SBATCH --constraint=ampere
#SBATCH --gres=gpu:1
CUDA_VISIBLE_DEVICES=0 PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True python -u train.py
```

Only set `CUDA_VISIBLE_DEVICES=0` when the job requests one GPU and the project already expects that convention.

Prefer Apptainer/Singularity containers when the user has a compatible image:

```bash
export APPTAINER_BINDPATH="/oscar/home/$USER,/oscar/scratch/$USER,/oscar/data"
srun apptainer exec --nv /path/to/image.simg python train.py
```

Use `--nv` so the container can see NVIDIA GPUs. For user-managed Python environments, activate the environment before direct `python -u ...` execution and avoid inventing the path.

## MPI

Use Oscar's Slurm-integrated MPI pattern:

```bash
module load hpcx-mpi/4.1.5rc2s
srun --mpi=pmix ./MyMPIProgram
```

Do not use `mpirun` for Oscar MPI batch scripts unless the user provides a specific documented exception. For interactive MPI, allocate first with `salloc`, then run `srun --mpi=pmix`.

## Job Arrays

Use arrays for repeated runs with different parameters:

```bash
#SBATCH --array=1-16
#SBATCH --output=array_job-%A_%a.out
#SBATCH --error=array_job-%A_%a.err

PARAM_ID="${SLURM_ARRAY_TASK_ID}"
python -u run_one.py --param-id "${PARAM_ID}"
```

Ensure the script consumes `$SLURM_ARRAY_TASK_ID`; otherwise the array repeats the same job.

## Monitoring

- `myq`: show the user's queued and running jobs.
- `allq` or `allq gpu`: inspect cluster or partition queues.
- `myjobinfo`: estimate pending start/completion or inspect completed resource use.
- `sacct -j <jobid> -l`: detailed completed-job accounting.
- `jobstats`: compare requested resources to actual use after completion.
- `scancel <jobid>`: cancel a job.

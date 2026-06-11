---
name: oscar-slurm-batch
description: Create, review, and refine Slurm batch scripts for Brown University's Oscar cluster. Use when Codex needs to write sbatch files, choose Oscar partitions such as batch/debug/gpu/gpu-he/bigmem/gracehopper, configure CPU/GPU/memory/time/account/logging directives, convert interactive commands into batch jobs, draft MPI or job-array submissions, or explain safe Oscar job submission and monitoring workflows.
---

# Oscar Slurm Batch

## Overview

Use this skill to produce concise, Oscar-appropriate Slurm batch files and submission guidance. Prefer batch jobs for long or heavy work, and explicitly avoid running CPU/GPU-intensive commands on login nodes.

## Workflow

1. Identify the workload shape before writing the script:
   - CPU serial or multithreaded: use `batch` unless debugging or memory needs imply another partition.
   - GPU deep learning: use `gpu`, `gpu-he`, `gpu-debug`, or `gracehopper` as requested by hardware needs.
   - MPI/distributed: use Slurm-integrated `srun --mpi=pmix`; avoid `mpirun`.
   - Repeated parameter sweeps: use a job array.
   - Memory-heavy jobs: consider `bigmem`.
2. Ask only for missing values that change resource allocation materially: expected runtime, CPU cores/tasks, memory, GPU count/type, account, environment setup, and command.
3. Write `#!/bin/bash` first, then put every `#SBATCH` directive before executable shell commands.
4. Request the smallest resources that are credible for the task. Remember Oscar's default is only 1 core and about 2.8 GB/core if unspecified.
5. Include stable log paths using `%j` for normal jobs or `%A_%a` for arrays.
6. Include environment setup before execution: modules, conda activation, virtualenv activation, or Apptainer bind paths as appropriate. For this user's Oscar Python jobs, prefer Miniforge/conda when no other environment style is specified.
7. For ordinary single-node Python/conda jobs, use the Oscar pattern `module load miniforge3/25.3.0-3`, `source ${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh`, `conda activate ...`, then `python -u ...` directly. Use `srun --mpi=pmix` for MPI; use `srun` for Apptainer/container jobs when matching that container pattern.
8. Add brief submission and monitoring commands after the script: `sbatch`, `myq`, `myjobinfo`, `sacct -j <jobid> -l`, `jobstats`, and `scancel <jobid>`.

## Resource Selection

Use `references/oscar-slurm.md` when details are needed about partitions, directives, arrays, MPI, containers, or monitoring commands.

Use the templates in `assets/templates/` as starting points:

- `cpu-basic.sh`: single-node CPU jobs using Oscar's Miniforge/conda module pattern.
- `gpu-conda.sh`: GPU Python jobs using Oscar's Miniforge/conda module pattern.
- `gpu-apptainer.sh`: GPU deep learning jobs using Apptainer/Singularity with `--nv`.
- `mpi-pmix.sh`: Slurm-integrated MPI jobs using `srun --mpi=pmix`.
- `array-job.sh`: parameter sweep jobs using `$SLURM_ARRAY_TASK_ID`.

## Output Expectations

When creating a batch file:

- Return a complete `.sh` script with placeholders only where the user has not supplied values.
- Keep comments short and operational.
- Prefer explicit `--partition`, `--nodes`, `--time`, `--mem`, `--output`, `--error`, and `--job-name` directives.
- For scripts following the user's existing Oscar projects, short directives such as `-J`, `-p`, `-n`, `-t`, `-o`, and `-e` are acceptable and often match local style.
- For GPU jobs, include `--gres=gpu:N`; add `--constraint=` only when the user asks for a GPU type or Oscar feature. Common observed constraints include `ampere` and `geforce3090`.
- For single-process multithreaded Python jobs, prefer `--ntasks=1` plus `--cpus-per-task=N` and export `OMP_NUM_THREADS`, `MKL_NUM_THREADS`, `OPENBLAS_NUM_THREADS`, and `NUMEXPR_NUM_THREADS` to match.
- For Condo/project usage, include `--account=` only when the user provides or asks for it.
- For email, include `--mail-type` and `--mail-user` only when requested.
- Do not invent modules, environment paths, account names, or container image paths.

## Safety Checks

Before finalizing, check that:

- `#SBATCH` directives appear before any executable command.
- Runtime format is valid, such as `HH:MM:SS` or `D-HH:MM:SS`.
- CPU directives match the execution model: `--ntasks` for processes/MPI, `--cpus-per-task` for threads.
- Memory is specified per node with `--mem=` unless the user explicitly wants another Slurm memory mode.
- Array logs use `%A_%a` and the command consumes `$SLURM_ARRAY_TASK_ID`.
- Conda Python scripts source `${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh` after loading Miniforge, set `PYTHONUNBUFFERED=1`, and use `python -u` for live logs.
- MPI scripts load an Oscar MPI module and use `srun --mpi=pmix`.
- GPU container scripts include `apptainer exec --nv`.

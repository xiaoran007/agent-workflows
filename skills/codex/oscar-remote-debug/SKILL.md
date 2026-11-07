---
name: oscar-remote-debug
description: Connect to Brown University's Oscar cluster over SSH, sync local code changes, and debug on CPU or GPU compute nodes in a Slurm interactive session. Use for hands-on debugging on Oscar. Use oscar-slurm-batch for authoring batch scripts.
---

# Oscar Remote Debug

## Connect and locate the project

Use the user's SSH target if provided. Otherwise try the local SSH aliases
`oscar`, then `oscar-direct`. Use a short, noninteractive probe such as
`ssh -o BatchMode=yes -o ConnectTimeout=10 oscar hostname`. If neither alias
works, report the SSH errors and ask for a working target or help completing
authentication. Brown's public endpoint uses MFA. The campus endpoint supports
key login from the campus network or VPN. See
[Oscar SSH](https://docs.ccv.brown.edu/oscar/connecting-to-oscar/ssh).

Use the login node to inspect paths, transfer code, and request resources. Run
project commands inside the compute allocation. Locate the existing remote
checkout and dataset from the task or project configuration. Use these
conventions when proposing new paths:

- `~/projects/<project>` under home for source code and small configuration files.
- `~/data` or the project's group data directory for persistent datasets and
  artifacts. Confirm the actual path when it is unclear. Some accounts lack
  `~/data`.
- `~/scratch/<project>` for temporary outputs, caches, and intermediate
  checkpoints. Files can be purged after 30 days without access. Keep results
  that need to persist in the agreed data location. See
  [Oscar's filesystem](https://docs.ccv.brown.edu/oscar/managing-files/filesystem).

## Confirm the request once

Estimate the CPUs, RAM, and walltime from the smallest useful reproduction,
using project settings or previous runs when available. Before the first upload
or allocation, ask the user once to confirm the remote project path, what will
be synced, and the resource request. Use an already confirmed plan if it covers
the work. Subsequent edits and reruns within that scope use the same confirmation.

- CPU-only debugging uses `batch`, with cores, RAM, and time sized to the task.
- GPU debugging uses `gpu-debug`. The usual request for this user is 2 GPUs,
  12 CPU cores, and 30 minutes. Request fewer resources when the reproduction
  clearly needs less and size RAM separately. Submit the confirmed request
  directly and leave partition and account validation to Slurm. If Slurm
  rejects it, report the actual error and discuss a revised request.

## Sync, then reuse the compute shell

Own the transfer of local edits to the agreed remote checkout. Run `rsync` over
the working SSH target for multiple files and `scp` for an isolated file. Use
repo-relative paths and include new files the task needs. Inspect local and
remote changes where Git is available. Preview multi-file transfers with
`rsync --dry-run --itemize-changes` and a scoped file list. Transfer the intended
code and config, excluding `.git`, local environments, credentials, datasets,
and generated outputs. Preserve remote-only edits. Resolve overlapping edits
or remote deletions explicitly. Verify the files arrived before rerunning. See
[Oscar file transfers](https://docs.ccv.brown.edu/oscar/managing-files/filetransfer).

Open an SSH session with a persistent PTY using `ssh -t <host>` and run
`interact` on the login node. Use the same compute shell while editing locally
and syncing in a separate local command. The two requests below illustrate the
flags. Set memory from the workload estimate.

```bash
# Example CPU-only session
interact -q batch -n 2 -m 4g -t 00:15:00

# Usual GPU request for this user, with example memory
interact -q gpu-debug -g 2 -n 12 -m 16g -t 00:30:00
```

Once the compute prompt appears, verify `hostname` and `$SLURM_JOB_ID`, then
`cd` to the synced checkout. For GPU work, check `CUDA_VISIBLE_DEVICES` and
`nvidia-smi` inside the allocation. If the session needs to survive SSH
disconnects, start `interact` inside a named `screen` session on the login node
and record that node for reattachment. See
[interactive jobs](https://docs.ccv.brown.edu/oscar/submitting-jobs/interact)
and [Screen](https://docs.ccv.brown.edu/oscar/software/screen).

## Run and release

Use the project's existing environment on Oscar. Activate its remote venv or
named Conda environment, or launch its documented container inside the
allocation. For a Miniforge-based Conda project, load the project's module
version and source its shell hook before activation. Brown's documented example
is `module load miniforge3/25.3.0-3`, followed by
`source "${MAMBA_ROOT_PREFIX}/etc/profile.d/conda.sh"` and `conda activate <env>`.
Verify the Python executable and relevant dependencies from the compute shell.
Ask before installing missing dependencies. See
[Oscar Conda and Mamba](https://docs.ccv.brown.edu/oscar/software/miniconda).

Run the smallest reproduction, sync fixes, and rerun inside the same
allocation. Capture relevant output and exit status. If the connection drops,
check the job ID with `squeue -j <jobid>` before requesting a replacement. Exit
the compute shell when finished and verify the allocation is released. If the
shell is lost and this task's job is still active and no longer needed, cancel
it with `scancel <jobid>`. Report the job ID, remote checkout, command, result, and any
saved logs. See [Oscar job management](https://docs.ccv.brown.edu/oscar/submitting-jobs/managing-jobs).

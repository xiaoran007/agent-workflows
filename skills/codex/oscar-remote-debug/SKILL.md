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

Use the login node for read-only path discovery, code transfers, and resource
requests. Run project commands inside the compute allocation. Use these Oscar
storage conventions when proposing paths:

- `~/projects/<project>` under home for source code and small configuration files.
- `~/data` or the project's group data directory for persistent datasets and
  artifacts. Some accounts lack `~/data`.
- `~/scratch/<project>` for temporary outputs, caches, and intermediate
  checkpoints. Files can be purged after 30 days without access. Keep results
  that need to persist in the agreed data location. See
  [Oscar's filesystem](https://docs.ccv.brown.edu/oscar/managing-files/filesystem).

## Confirm the request once

Use only paths the user explicitly supplies or approves for the remote source
checkout, datasets or persistent storage, and temporary outputs. If any path
the task needs is missing, propose a concrete path based on project configuration
and read-only discovery. Obtain approval for proposed paths before creating
directories, syncing files, allocating resources, or running project commands.

Estimate CPU and GPU counts, RAM, and walltime from the smallest useful
reproduction, using project settings or previous runs. Confirm the sync scope
and resource request in the same exchange as any proposed paths. Use an already
confirmed plan if it covers the work. Subsequent edits and reruns within that
scope use the same confirmation.

- CPU-only debugging uses `batch`, with cores, RAM, and time sized to the task.
- For GPU debugging, treat 2 GPUs and 12 CPU cores as this user's default
  account ceilings. Request only what the task needs. Prefer `gpu-debug` for
  short sessions and use 30 minutes as a planning guideline for that partition.
- In the user's Oscar setup, `gpu-debug` offers both L40S and H100. Prefer L40S
  with `-q gpu-debug -f l40s`. Use `-q gpu-debug -f h100` when the task needs
  H100, for example for its additional GPU memory or Hopper features.

Submit the confirmed request directly and leave partition and account limit
validation to Slurm. If Slurm rejects it, report the error and discuss a revised
request.

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

# Example L40S session for a short reproduction
interact -q gpu-debug -f l40s -g 1 -n 2 -m 8g -t 00:15:00
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
allocation. On Oscar, `uv` is installed for the user at `~/.local/bin/uv`.
When a Python project needs a new virtual environment, prefer
`~/.local/bin/uv venv` from the project directory.

For a Miniforge-based Conda project, load the project's module
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

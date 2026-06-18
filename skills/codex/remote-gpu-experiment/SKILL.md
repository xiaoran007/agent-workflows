---
name: remote-gpu-experiment
description: Fixed workflow for local deep-learning code development with remote GPU execution over SSH. Use when Codex needs to connect to a user-provided SSH host or temporary SSH config, place or inspect a project under a user-provided remote root path, ensure the remote login shell sources important profiles, use the first remote `python` on PATH by default, verify deep-learning dependencies and GPU availability, sync code, run/debug/monitor experiments, or intentionally stop remote training processes during debugging.
---

# Remote GPU Experiment

## Overview

Use this skill when code is edited locally but the real runtime is a remote GPU host reached with SSH. Treat the remote machine as the source of runtime truth: inspect its login environment, Python, GPU, project path, and running jobs before changing code or launching experiments.

## Inputs

Require these inputs before acting:

- `host`: SSH host name. Use `ssh <host>` by default.
- `remote_root`: Main remote directory where the project should live.
- `ssh_config`: Optional temporary SSH config file. If provided, use `ssh -F <ssh_config> <host>`.
- `action`: inspect, sync, run, debug, monitor, collect logs, or stop a job.

Ask only for missing information that affects correctness. Do not infer a remote path, launch command, environment manager, branch, or dataset location when that choice changes behavior.

## SSH And Login Shell

Build SSH commands explicitly:

```bash
ssh <host> 'exec "$SHELL" -lc '"'"'<command>'"'"''
ssh -F <ssh_config> <host> 'exec "$SHELL" -lc '"'"'<command>'"'"''
```

Run remote commands through the remote login shell so `.profile`, `.bashrc`, `.zshrc`, modules, conda shell hooks, CUDA variables, and site-specific profile logic have a chance to load. If `$SHELL` is unset or the login-shell command fails, report it as an environment risk instead of silently bypassing the profile path.

Prefer sending compact shell scripts over stdin for multi-line remote logic. Keep quoting simple and visible.

## Remote Python

Use the first `python` found on the remote `PATH` by default:

```bash
command -v python
python -V
python -c 'import sys; print(sys.executable)'
```

Do not activate conda, venv, modules, or a fallback Python unless the user asks or project documentation explicitly requires it. If `python` is missing, report the blocker and ask how to proceed. If a dependency is missing, ask whether to install it instead of silently downgrading, substituting, or adding fallback code.

## First Connection Probe

On the first connection to a host/project pair, run `scripts/remote_probe.sh` before syncing or launching experiments:

```bash
ssh <host> 'exec "$SHELL" -lc '"'"'bash -s -- <remote_root>'"'"'' < skills/codex/remote-gpu-experiment/scripts/remote_probe.sh
ssh -F <ssh_config> <host> 'exec "$SHELL" -lc '"'"'bash -s -- <remote_root>'"'"'' < skills/codex/remote-gpu-experiment/scripts/remote_probe.sh
```

The probe is read-only. It checks host identity, profile-sensitive environment variables, remote project path, first PATH `python`, core Python packages, PyTorch CUDA visibility, `nvidia-smi`, git state, disk space, and long-running session tools.

Summarize results as:

- `OK`: ready or expected.
- `Risk`: usable but likely to affect reproducibility or stability.
- `Blocker`: action should not continue without user decision.
- `Unknown`: unavailable signal or command.

For every Risk or Blocker, include the supporting output fragment and a suggested next action.

## Sync Workflow

Before changing remote files, inspect local and remote git state when applicable:

```bash
git status --short --branch
ssh <host> 'exec "$SHELL" -lc '"'"'cd <remote_root> && git status --short --branch'"'"''
```

Prefer git-based sync when both sides are git repositories. Commit local changes before pushing when the repository policy requires traceability. Do not overwrite remote uncommitted changes. Fetch or inspect tracking state before assuming the remote can fast-forward.

Use `rsync` only when git is not appropriate or the user asks. Exclude generated or heavyweight paths unless explicitly requested: `.git`, `__pycache__`, `.venv`, `wandb`, `runs`, `outputs`, `checkpoints`, datasets, and caches.

## Running Experiments

Before running a costly or long command, make the command, cwd, visible GPUs, expected outputs, and log path explicit. For long-running jobs:

- Prefer `tmux` or `screen` when available.
- Write logs to a timestamped file under the project or a user-provided log directory.
- Use unbuffered output when helpful: `python -u ...`.
- Preserve existing progress bars. If editing project code for a long operation, add fine-grained progress reporting.
- Record command, cwd, git commit, Python executable, CUDA/GPU visibility, PID, and log path.

Do not add project-code fallback logic unless the user asks. Keep code changes direct.

## Debugging And Stopping Jobs

Use lightweight checks before deeper debugging:

```bash
nvidia-smi
ps -u "$USER" -o pid,ppid,stat,etime,pcpu,pmem,cmd
tail -n 80 <log-file>
```

When a training or debugging process should be stopped, Codex may decide to terminate it without asking again if the target is clearly identified as part of the current task or the user's debugging intent. Before killing, identify the PID, owner, command, elapsed time, log file when known, and GPU association when available.

Prefer graceful termination:

```bash
kill -INT <pid>
sleep 5
kill -TERM <pid>
```

Use `kill -KILL <pid>` only if the process is still alive, the target remains clear, and graceful termination did not work. Do not kill other users' processes, system processes, scheduler-managed jobs, or unrelated long-running jobs. If ownership or relevance is ambiguous, ask before acting.

## Reporting

Keep reports compact and operational:

- Current local and remote commit/branch state.
- Remote Python and GPU readiness.
- Exact command run or proposed.
- PID/session/log/checkpoint locations.
- Risks, blockers, and the next concrete action.

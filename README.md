# agent-workflows

Personal agent skills, custom subagents, and reusable agent workflows.

This repository is the source of truth for my custom coding agent workflows, mostly for `Codex`. Skills
live under `skills/` and custom subagents live under `subagents/`.
They can be installed into or fetched from another machine's configuration so
the agent apps can use the same workflows.

## Repository layout

```text
skills/
└── codex/
subagents/
└── codex/
scripts/
├── codex-skills.sh
└── codex-subagents.sh
AGENTS.md
```

## Project memory

`AGENTS.md` is the persistent memory for new threads. Read it first when you
need a quick map of the repository, current inventory, operating rules, and
maintenance conventions.

## Quick install

Codex app and Codex CLI read user skills from the Agent Skills directory. The
default is `~/.agents/skills/`. Personal custom subagents are installed to
`~/.codex/agents/`.

1. Clone this repository:

```bash
git clone https://github.com/xiaoran007/agent-workflows.git
cd agent-workflows
```

2. Install everything tracked here:

```bash
./scripts/codex-skills.sh install --all
./scripts/codex-subagents.sh install --all
```

3. Restart Codex app or start a new Codex CLI session.
After restart, skills can be invoked by name:

```text
Use $ssh-git-sync to import commits from my remote worktree.
Use $deep-learning-paper-code-repro to analyze this paper and repository.
Use $research-repro-cv-medimg to prepare a reproduction plan.
Use $oscar-slurm-batch to write an Oscar batch job.
Use $remote-gpu-experiment to run this deep-learning project on my SSH GPU host.
Use $drawio-diagram-builder to create an editable research-style draw.io diagram.
```

## Common commands

```bash
# Update installed copies from this repository
./scripts/codex-skills.sh update --all
./scripts/codex-subagents.sh update --all

# Compare installed copies with this repository
./scripts/codex-skills.sh scan --all
./scripts/codex-subagents.sh scan --all

# Install or update one item
./scripts/codex-skills.sh install skills/codex/ssh-git-sync
./scripts/codex-subagents.sh install subagents/codex/git-branch-auditor.toml

# Copy installed local changes back into this repository
./scripts/codex-skills.sh copy ssh-git-sync
./scripts/codex-subagents.sh copy git-branch-auditor

# Preview an operation
./scripts/codex-skills.sh update --all --dry-run
./scripts/codex-subagents.sh copy git-branch-auditor --dry-run
```

`scan` reports `same`, `changed`, `missing-local`, or `local-only`. The scripts
accept either repository paths or item names. Set custom config roots when
needed:

```bash
AGENTS_HOME=/path/to/.agents ./scripts/codex-skills.sh install --all
CODEX_HOME=/path/to/.codex ./scripts/codex-subagents.sh install --all
```

Project-scoped subagents can be installed into a repository's `.codex/agents`
directory:

```bash
./scripts/codex-subagents.sh install --all --project /path/to/repo
./scripts/codex-subagents.sh scan --all --project /path/to/repo
```

## Update an existing device

```bash
cd agent-workflows
git pull
./scripts/codex-skills.sh update --all
./scripts/codex-subagents.sh update --all
```

This overwrites the installed copies of tracked skills and subagents with the
versions in this repository. It does not remove unrelated local skills or
custom agents.

## Skills

Skills live under `skills/codex/<name>/SKILL.md`. Each skill packages a reusable
workflow and any supporting references or agent presets.

### `deep-learning-paper-code-repro`

Fixed workflow for deep learning paper and code reproduction. It reads a paper
PDF visually, inspects the repository from README to execution paths, assumes a
remote Linux cluster as the real runtime target, and writes a detailed report
under `analysis/`.

### `research-repro-cv-medimg`

Deep reading workflow for computer vision and medical imaging papers with their
experiment repositories. It reconstructs methods, training and evaluation setup,
hidden reproduction details, and reliable next-step plans for reproduction,
modification, ablation, or comparison experiments.

### `ssh-git-sync`

Workflow for importing commits from another reachable worktree without GitHub,
such as an SSH development machine, remote Linux host, container checkout, or
mounted path. It fetches into a namespaced ref, compares commit graphs and
diffs, then chooses fast-forward, merge, cherry-pick, or manual porting.

### `oscar-slurm-batch`

Workflow for creating, reviewing, and refining Slurm batch scripts for Brown
University's Oscar cluster. It helps choose partitions, CPU/GPU/memory/time
directives, job arrays, MPI patterns, environment setup, and monitoring
commands.

### `remote-gpu-experiment`

Workflow for local deep-learning development with execution on a remote GPU
host over SSH. It fixes the connection, login-shell environment, first PATH
Python, GPU/dependency probing, sync, run, monitor, debug, and process-stop
steps used for remote experiments.

### `drawio-diagram-builder`

Workflow for creating, editing, replicating, and iteratively refining editable
diagrams.net / draw.io research and technical figures from prompts, papers,
repositories, screenshots, reference images, or existing diagrams.

## Subagents

Codex custom subagents are standalone TOML files under `subagents/codex/`.
Each file defines one reusable agent and should include `name`, `description`,
and `developer_instructions`.

### `git-branch-auditor`

Read-only Git branch auditor for inspecting local and remote branch state,
tracking relationships, ahead/behind status, divergence, stale refs, and the
current repository position without modifying the repository.

## License

[MIT](LICENSE)

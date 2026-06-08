# agent-workflows

Personal agent skills, custom subagents, and reusable agent workflows.

This repository is the source of truth for my custom Codex workflows. Skills
live under `skills/codex/` and custom subagents live under `subagents/codex/`.
They can be copied into a new machine's Codex configuration so the Codex app
and Codex CLI can use the same workflows.

## Repository layout

```text
skills/
└── codex/
    ├── deep-learning-paper-code-repro/
    ├── research-repro-cv-medimg/
    └── ssh-git-sync/
subagents/
└── codex/
    └── README.md
scripts/
├── codex-skills.sh
└── codex-subagents.sh
```

## Skills

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

## Install on a new device

Codex app and Codex CLI read user skills from the Agent Skills directory. The
current default is `~/.agents/skills/`. Personal custom subagents are installed
to `~/.codex/agents/`.

1. Clone this repository:

```bash
git clone git@github.com:xiaoran007/agent-workflows.git ~/code/agent-workflows
cd ~/code/agent-workflows
```

2. Install all custom skills:

```bash
./scripts/codex-skills.sh install --all
```

3. Install all custom subagents if any are tracked:

```bash
./scripts/codex-subagents.sh install --all
```

4. Verify that the skills and subagents are present:

```bash
find "${AGENTS_HOME:-$HOME/.agents}/skills" -maxdepth 2 -name SKILL.md -print
find "${CODEX_HOME:-$HOME/.codex}/agents" -maxdepth 1 -name '*.toml' -print
```

5. Restart Codex app or start a new Codex CLI session.

After restart, the skills should be available by name, for example:

```text
Use $ssh-git-sync to import commits from my remote worktree.
Use $deep-learning-paper-code-repro to analyze this paper and repository.
Use $research-repro-cv-medimg to prepare a reproduction plan.
```

## Install one skill

To install only one workflow:

```bash
./scripts/codex-skills.sh install skills/codex/ssh-git-sync
```

Restart Codex app or start a new Codex CLI session after copying.

## Manage skills

Use `scripts/codex-skills.sh` to install, update, or remove tracked skills.
When no target is passed, the script operates on all skills under
`skills/codex/`. You can also pass `--all` explicitly. By default, skills are
installed to `~/.agents/skills`.

```bash
# Install or update everything
./scripts/codex-skills.sh install --all
./scripts/codex-skills.sh update --all

# Install, update, or remove one skill by path
./scripts/codex-skills.sh install skills/codex/ssh-git-sync
./scripts/codex-skills.sh update skills/codex/ssh-git-sync
./scripts/codex-skills.sh remove skills/codex/ssh-git-sync

# Skill names also work
./scripts/codex-skills.sh remove ssh-git-sync

# Preview actions without changing files
./scripts/codex-skills.sh update --all --dry-run
```

Set `AGENTS_HOME` if the Agent Skills directory uses a non-default location:

```bash
AGENTS_HOME=/path/to/.agents ./scripts/codex-skills.sh install --all
```

Use `-c` or `--legacy-codex` for older Codex installs that still load skills
from `~/.codex/skills`:

```bash
./scripts/codex-skills.sh install --all -c
./scripts/codex-skills.sh update ssh-git-sync --legacy-codex
```

## Subagents

Codex custom subagents are standalone TOML files under `subagents/codex/`.
Each file defines one agent and should include `name`, `description`, and
`developer_instructions`.

```toml
name = "reviewer"
description = "PR reviewer focused on correctness, security, and missing tests."
developer_instructions = """
Review code like an owner.
Prioritize correctness, security, behavior regressions, and missing tests.
"""
```

Use `scripts/codex-subagents.sh` to install, update, or remove tracked custom
subagents. When no target is passed, the script operates on all TOML files
under `subagents/codex/`. You can also pass `--all` explicitly. By default,
subagents are installed to `~/.codex/agents`.

```bash
# Install or update everything
./scripts/codex-subagents.sh install --all
./scripts/codex-subagents.sh update --all

# Install, update, or remove one custom agent by path
./scripts/codex-subagents.sh install subagents/codex/reviewer.toml
./scripts/codex-subagents.sh update subagents/codex/reviewer.toml
./scripts/codex-subagents.sh remove subagents/codex/reviewer.toml

# Agent names also work
./scripts/codex-subagents.sh remove reviewer

# Preview actions without changing files
./scripts/codex-subagents.sh update --all --dry-run
```

Set `CODEX_HOME` if the personal Codex configuration directory uses a
non-default location:

```bash
CODEX_HOME=/path/to/.codex ./scripts/codex-subagents.sh install --all
```

Use `-p` or `--project` to install project-scoped subagents into a repository's
`.codex/agents` directory:

```bash
./scripts/codex-subagents.sh install --all --project /path/to/repo
./scripts/codex-subagents.sh update reviewer --project /path/to/repo
```

## Update an existing device

Pull the latest repository changes, then run the update command:

```bash
cd ~/code/agent-workflows
git pull
./scripts/codex-skills.sh update --all
./scripts/codex-subagents.sh update --all
```

This overwrites the installed copies of these custom skills and subagents with
the versions tracked in this repository. It does not remove other skills under
`~/.agents/skills` or other custom agents under `~/.codex/agents`.

## License

[MIT](LICENSE)

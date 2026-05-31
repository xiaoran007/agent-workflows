# agent-workflows

Personal Codex skills and reusable agent workflows.

This repository is the source of truth for my custom Codex skills. The skills
live under `skills/codex/` and can be copied into a new machine's Codex home so
both the Codex app and Codex CLI can use the same workflows.

## Repository layout

```text
skills/
└── codex/
    ├── deep-learning-paper-code-repro/
    ├── research-repro-cv-medimg/
    └── ssh-git-sync/
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

Codex app and Codex CLI both read local skills from the Codex home directory.
By default that is `~/.codex`, so custom skills should be installed under
`~/.codex/skills/`.

1. Clone this repository:

```bash
git clone git@github.com:xiaoran007/agent-workflows.git ~/code/agent-workflows
cd ~/code/agent-workflows
```

2. Copy all custom skills into Codex home:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
cp -R skills/codex/* "$CODEX_HOME/skills/"
```

3. Verify that the skills are present:

```bash
find "$CODEX_HOME/skills" -maxdepth 2 -name SKILL.md -print
```

4. Restart Codex app or start a new Codex CLI session.

After restart, the skills should be available by name, for example:

```text
Use $ssh-git-sync to import commits from my remote worktree.
Use $deep-learning-paper-code-repro to analyze this paper and repository.
Use $research-repro-cv-medimg to prepare a reproduction plan.
```

## Install one skill

To install only one workflow:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
cp -R skills/codex/ssh-git-sync "$CODEX_HOME/skills/"
```

Restart Codex app or start a new Codex CLI session after copying.

## Update an existing device

Pull the latest repository changes, then copy the skills again:

```bash
cd ~/code/agent-workflows
git pull
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
cp -R skills/codex/* "$CODEX_HOME/skills/"
```

This overwrites the installed copies of these custom skills with the versions
tracked in this repository. It does not remove other skills under
`$CODEX_HOME/skills`.

## License

[MIT](LICENSE)

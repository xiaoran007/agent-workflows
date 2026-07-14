# Agent Memory

## Project Purpose

This repository is the source of truth for personal Codex workflows:

- reusable skills under `skills/codex/`
- custom subagents under `subagents/codex/`
- install/sync helpers under `scripts/`

New threads should read this file and `README.md` before editing.

## Current Inventory

Tracked skills:

- `deep-learning-paper-code-repro`: explicit-invocation-only deep learning paper/code reproduction workflow with visual PDF reading and detailed `analysis/` reports.
- `research-repro-cv-medimg`: explicit-invocation-only source-grounded CV and medical imaging paper/repository reproduction analysis.
- `ssh-git-sync`: import and integrate commits from another reachable worktree without GitHub.
- `oscar-slurm-batch`: create and review Brown Oscar Slurm batch scripts and job guidance.
- `remote-gpu-experiment`: local deep-learning development with SSH remote GPU execution, probing, sync, run, monitor, debug, and process-stop workflow.
- `drawio-diagram-builder`: create, edit, replicate, and iteratively refine editable diagrams.net / draw.io research and technical figures.
- `zotero-paper-review`: find a Zotero candidate paper by title, copy its PDF into the project, and write a source-grounded structured review report.
- `zotero-bbt-bibtex`: export Zotero items through Better BibTeX using BBT JSON-RPC, `translator=bibtex`, and `worker=false`.
- `qmd-revealjs-to-pptx`: create editable PowerPoint decks from Quarto revealjs slides using the rendered HTML as the visual reference.

Tracked subagents:

- `git-branch-auditor`: read-only Git branch, remote, tracking, and divergence auditor.

## Install And Sync

Install or update everything:

```bash
./scripts/codex-skills.sh install --all
./scripts/codex-subagents.sh install --all
./scripts/codex-skills.sh update --all
./scripts/codex-subagents.sh update --all
```

Compare installed copies with this repository:

```bash
./scripts/codex-skills.sh scan --all
./scripts/codex-subagents.sh scan --all
```

Copy installed local edits back into this repository:

```bash
./scripts/codex-skills.sh copy <skill-name>
./scripts/codex-subagents.sh copy <agent-name>
```

Use `AGENTS_HOME` for non-default skill installs and `CODEX_HOME` for
non-default subagent installs. Use `--project /path/to/repo` with
`codex-subagents.sh` for project-scoped agents.

## Authoring Conventions

- A skill is a directory at `skills/codex/<name>/` with a required `SKILL.md`.
- Skill support files should stay inside that skill directory, usually under
  `references/`, `assets/`, or `agents/`.
- A subagent is a TOML file at `subagents/codex/<name>.toml`.
- Subagent TOML files should include `name`, `description`, and
  `developer_instructions`.
- Keep filenames aligned with skill or subagent names.
- When adding, removing, or renaming a skill/subagent, update both `README.md`
  and this memory file.
- Prefer concise docs that describe workflow intent, invocation triggers,
  install commands, and maintenance rules over long narrative explanations.

## Agent Operating Rules

- Use `rg` or `rg --files` first when inspecting this repository.
- Use `apply_patch` for manual file edits.
- Before using Python, check for a project `venv` first, then conda
  environments. Ask the user before using system Python.
- For research-code projects, do not add tests or run local smoke tests unless
  the user explicitly asks.
- Do not add fallback logic unless the user asks for it; keep workflow code and
  docs simple and direct.
- If an operation is expected to run for a long time, prefer adding fine-grained
  progress reporting.
- If a needed dependency is missing, ask to install it instead of silently
  downgrading or rewriting around it.
- This repository uses Git. Keep changes small and commit focused edits for
  traceability.

## New Thread Checklist

1. Run `git status --short` and preserve any existing user changes.
2. Read `README.md` and this file.
3. Use `rg --files` to confirm the current skill/subagent inventory.
4. If changing docs, keep install instructions early and detailed inventory
   later.
5. Run `git diff --check` before committing documentation changes.

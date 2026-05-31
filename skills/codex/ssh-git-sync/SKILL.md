---
name: ssh-git-sync
description: Import, inspect, and integrate Git commits from another reachable worktree without using GitHub. Use when Codex needs to pull changes from an SSH development machine, remote Linux host, Docker/container checkout, mounted worktree, or any path like host:/path/repo into the local repository; compare local and remote commit graphs; handle non-fast-forward remote updates; choose fast-forward, merge, cherry-pick, or manual porting; and preserve clean, traceable local commits.
---

# SSH Git Sync

## Overview

Use this workflow when a user has committed changes in a Git repository on an SSH host or container-accessible filesystem and wants them brought into the current local repository without pushing through GitHub.

Treat the remote worktree as an analysis source first. Fetch into a local tracking ref, inspect relationships and diffs, then choose the smallest safe integration strategy.

## Workflow

1. Confirm local state:

```bash
git status --short --branch
git log --oneline --decorate -n 8
git remote -v
```

If the working tree is dirty, preserve user changes. Do not merge, reset, checkout, or overwrite until the dirtiness is understood.

2. Fetch the remote worktree into a namespaced ref:

```bash
git fetch <ssh-host-or-path>:<remote-repo-path> <branch>:refs/remotes/<alias>/<branch>
```

Example:

```bash
git fetch dl-pt280-cu128:/home/dev/code/membench main:refs/remotes/dl/main
```

Use a force update only when Git reports the remote tracking ref is non-fast-forward and the user asked to inspect the current remote state:

```bash
git fetch <source> +<branch>:refs/remotes/<alias>/<branch>
```

Be explicit that this only updates the local tracking ref, not the local working branch.

3. Compare commit relationships:

```bash
git rev-list --left-right --count HEAD...<alias>/<branch>
git log --oneline --decorate --graph --left-right --cherry-pick HEAD...<alias>/<branch>
git diff --stat HEAD..<alias>/<branch>
git diff --name-status HEAD..<alias>/<branch>
```

Read the actual commit diffs before integrating:

```bash
git show --stat --oneline <commit>
git show --find-renames --find-copies <commit> -- <relevant paths>
```

## Integration Choice

Prefer these choices in order:

- Fast-forward when local `HEAD` is an ancestor of `<alias>/<branch>`:

```bash
git merge --ff-only <alias>/<branch>
```

- Merge when both sides contain compatible commits and the remote branch is already based on the same structure:

```bash
git merge --no-ff <alias>/<branch> -m "<clear merge message>"
```

- Cherry-pick a small ordered range when remote commits apply cleanly to current structure:

```bash
git cherry-pick <oldest>^..<newest>
```

- Manually port when the remote branch was developed against an older layout or large local refactor. In that case, implement the semantic changes in the current module structure, then create a local commit with a message that explains it is a port.

## Non-Fast-Forward Remote Updates

If fetch rejects with `(non-fast-forward)`, assume the remote tracking ref has been rewritten. Do not rewrite local `main`.

1. Force-update only the tracking ref.
2. Re-run the relationship and diff checks.
3. Explain whether the new remote tip is an ancestor/descendant, a rewritten equivalent, or a different line of work.

## Analysis Checklist

Before changing local `HEAD`, report:

- Local branch and cleanliness.
- Remote tip and new commits.
- Whether local can fast-forward or has diverged.
- Files touched and likely conflict/porting risk.
- Recommended integration path.

After integrating, run non-executing checks such as:

```bash
git status --short --branch
git log --oneline --decorate -n 8
git diff --check HEAD~1..HEAD
```

Do not run project tests or smoke tests unless the user asks or project instructions require them.

## Traceability

When manual porting is necessary, keep the port focused and commit it. Mention the source remote commits in the final answer. Preserve remote commit history when a fast-forward, merge, or cherry-pick is safe; use a port commit only when direct integration would undo local refactors or reintroduce obsolete structure.

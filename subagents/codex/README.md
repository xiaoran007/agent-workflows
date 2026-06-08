# Codex Subagents

This directory stores source-controlled Codex custom agents.

Each `*.toml` file defines one custom agent. Keep the filename aligned with the
agent `name` field when possible:

```toml
name = "reviewer"
description = "PR reviewer focused on correctness, security, and missing tests."
developer_instructions = """
Review code like an owner.
Prioritize correctness, security, behavior regressions, and missing tests.
"""
```

Install personal agents to `~/.codex/agents`:

```bash
./scripts/codex-subagents.sh install --all
```

Install project-scoped agents to a repository's `.codex/agents` directory:

```bash
./scripts/codex-subagents.sh install --all --project /path/to/repo
```

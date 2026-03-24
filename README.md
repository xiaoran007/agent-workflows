# agent-workflows

A collection of reusable AI agent workflows and skills for deep learning paper and code reproduction analysis.

## Overview

This repository contains structured workflows (Skills) for AI agents such as [OpenAI Codex](https://platform.openai.com/docs/guides/codex), helping researchers turn paper PDFs and code repositories into grounded, actionable reproduction reports.

---

## Repository Structure

```
skills/
└── codex/
    ├── deep-learning-paper-code-repro/   # DL paper + code reproduction workflow
    └── research-repro-cv-medimg/         # CV / medical imaging research repro workflow
```

---

## Skills

### `deep-learning-paper-code-repro`

Converts a deep learning paper PDF and its code repository into a detailed, source-grounded reproduction analysis report.

**Use when:**
- A paper PDF already exists in the project (filename is typically the method or model name)
- Visual-first PDF reading is needed to preserve tables, equations, and figures
- The target execution environment is a remote Linux cluster, not a local Mac
- A structured report is required under `analysis/`

**Workflow:**
1. Locate the paper PDF and repository root
2. Read the PDF visually; extract method, datasets, training and inference details
3. Read the repository `README.md` for environment setup, data prep, and run commands
4. Trace the real inference and training execution paths through the code
5. Write the full report to `analysis/<paper-stem>-method-impl-repro.md`

---

### `research-repro-cv-medimg`

Deep-reads computer vision and medical imaging papers alongside their experiment repositories, reconstructs the real implementation and experimental setup, and prepares a reliable reproduction or comparison plan.

**Use when:**
- Reading a paper PDF, arXiv page, or appendix
- Reconstructing the full training and evaluation setup
- Identifying hidden reproduction details (dataset splits, evaluation protocols, preprocessing)
- Planning ablation studies or method comparisons

**Workflow:**
1. Collect all artifacts: paper, code, configs, environment files, checkpoints
2. Read the paper visually; focus on tables, equations, architecture diagrams, and appendix
3. Map the repository with `rg --files`, then dive into entrypoints and key modules
4. Use code as ground truth; reconcile against paper descriptions
5. Produce a reproduction plan or experiment modification proposal

---

## Usage

In a Codex agent environment that supports Skills, activate a skill with:

```
# Deep learning paper reproduction
Use $deep-learning-paper-code-repro to read a paper PDF and its code repo,
then write a detailed report under analysis/.

# CV / medical imaging research reproduction
Use $research-repro-cv-medimg to read this paper and repo,
extract the experimental setup, and prepare a reproduction plan.
```

---

## License

[MIT](LICENSE)

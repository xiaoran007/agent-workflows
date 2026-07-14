---
name: research-repro-cv-medimg
description: Opt-in workflow for deep, source-grounded reading of computer vision and medical imaging papers together with their experiment repositories, including implementation reconstruction, reproduction risks, and plans for reproduction, modification, ablation, or comparison. Never select or load this skill from inferred task intent. Use it only when the user explicitly names `research-repro-cv-medimg` or invokes `$research-repro-cv-medimg`.
---

# Research Repro for CV and MedImg

## Overview

Use this skill to convert a paper plus repository into a source-grounded understanding of the method, code path, experiment setup, and reproduction risks. Prefer concrete evidence from configs, scripts, dataset code, and evaluation code over paper-level paraphrase. When reading paper PDFs, prefer visual page rendering over raw text extraction so tables, equations, figures, and multi-column structure remain intact.

## Workflow

1. Collect the actual artifacts.
   - Find the paper, appendix or supplement, project page, repository, commit or tag if available, README, environment files, config files, training scripts, evaluation scripts, and pretrained checkpoints.
   - If key artifacts are missing, state that immediately and continue with the strongest available evidence.
2. Read the paper with reproduction in mind.
   - If the paper is a PDF, read it visually first. Render pages and inspect the actual layout instead of relying on extracted plain text as the primary source.
   - Use text extraction only as a secondary aid for search, copyable snippets, or locating keywords after the visual pass.
   - Pay special attention to tables, equations, figure captions, architecture diagrams, algorithm boxes, and appendix pages where implementation details often hide.
   - Extract the task, inputs and outputs, dataset and split definitions, preprocessing, model blocks, losses, optimizer and scheduler, training duration, augmentation, inference procedure, post-processing, metrics, baselines, and ablations.
   - Use `references/paper-reading.md` for the extraction checklist.
3. Map the repository before diving deep.
   - Use `rg --files` first, then open only the entrypoints, configs, dataset loaders, model definitions, training engine, evaluation code, and utility modules that control the real behavior.
   - Use `references/repo-analysis.md` for the code-reading order and reconciliation strategy.
4. Reconcile paper claims with executable code.
   - Treat code as the source of truth for what actually runs.
   - Compare the paper text against default config values, launch scripts, dataset transforms, metric implementation, checkpoint loading, thresholding, fold selection, and random seed behavior.
   - Use `references/repro-checklist.md` to catch hidden assumptions.
5. Prepare the next research step.
   - If the goal is reproduction, produce the minimal runnable path and the unresolved blockers.
   - If the goal is modification or comparison, identify the clean intervention points, affected configs, and what must be held constant for a fair comparison.
   - Use `references/experiment-design.md` when planning ablations or follow-up experiments.

## Expected Output

When the user asks for a deep read, structure the answer around these sections unless they want something shorter:

- `Paper summary`: problem, claimed contribution, and what is genuinely new versus standard practice.
- `Method`: architecture, losses, preprocessing, inference path, and any paper ambiguities.
- `Repo map`: main entrypoints, key modules, config files, and how data flows through the code.
- `Experiment specification`: datasets, splits, input shape, augmentations, optimizer, scheduler, epochs or iterations, batch size, hardware assumptions, and metrics.
- `Paper-code gaps`: defaults, missing details, silent deviations, and inferred behavior.
- `Reproduction plan`: exact commands or the closest available commands, prerequisites, expected artifacts, and blockers.
- `Modification hooks`: the safest files or config keys to change for new experiments.

## Working Rules

- Treat visual PDF reading as the default whenever layout matters.
- Prefer exact file paths, function names, class names, argument names, and config keys.
- Separate `stated in paper`, `implemented in code`, and `inferred from evidence`.
- Do not trust plain-text PDF extraction for tables, formulas, multi-column ordering, or model diagrams.
- Do not stop at README-level understanding if the task is about reproduction or faithful comparison.
- Inspect dataset code and evaluation code even if the model architecture looks straightforward.
- For medical imaging repositories, pay extra attention to spacing, orientation, resampling, patch extraction, fold definitions, and case-level versus slice-level evaluation.
- For vision training code, check whether augmentations, normalization, crop policy, resize policy, and test-time inference match the paper.

## References

- Read `references/paper-reading.md` when extracting technical content from the paper and appendix.
- Read `references/repo-analysis.md` when tracing the real execution path through the repository.
- Read `references/repro-checklist.md` when preparing a faithful reproduction or troubleshooting a mismatch.
- Read `references/experiment-design.md` when planning modifications, ablations, or fair comparisons.

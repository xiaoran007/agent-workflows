---
name: deep-learning-paper-code-repro
description: Opt-in fixed workflow for reproducing or deeply analyzing a deep learning paper together with its repository through visual-first PDF reading, README-first inspection, inference-first code tracing, remote-Linux execution assumptions, and a detailed report under analysis/. Never select or load this skill from inferred task intent. Use it only when the user explicitly names `deep-learning-paper-code-repro` or invokes `$deep-learning-paper-code-repro`.
---

# Deep Learning Paper Repro

## Overview

Turn a paper PDF plus its codebase into a source-grounded reproduction analysis. Read the paper visually first, inspect the repository in the order that most affects faithful execution, assume the user's Mac is for reading and editing while a remote Linux cluster is the real execution target, and leave behind a detailed report in `analysis/` that separates paper claims, repository guidance, executable behavior, remote-run requirements, and reproducibility risks.

## Workflow

1. Locate the paper and normalize the working artifacts.
   - Search the current project for PDFs before assuming the paper is missing.
   - Prefer the PDF already stored in the project. The filename is often the method or model name and should be treated as the default identifier for the report filename.
   - Record the local PDF path, the repository root, and the main README path before deeper analysis.
2. Read the paper visually through the `pdf` skill before relying on extracted text.
   - Invoke [$pdf](/Users/xiaoran/.codex/skills/pdf/SKILL.md) and use a visual-first workflow so tables, equations, diagrams, appendix pages, and multi-column ordering are preserved.
   - Use plain-text extraction only as a secondary search aid after the visual pass.
   - Extract the method, architecture, inputs and outputs, loss terms, inference procedure, training recipe, datasets, splits, preprocessing, post-processing, metrics, hardware hints, and appendix-only implementation details.
   - Pay extra attention to datasets or evaluation protocols inherited from prior work. Capture the original source paper or benchmark when the current paper reuses a prior split, preprocessing convention, or evaluation paradigm.
3. Read `README.md` before diving into the code.
   - Treat the repository README as the first code-side artifact to inspect.
   - Extract pretrained checkpoints, environment setup, dependency versions, dataset download instructions, preprocessing scripts, expected folder structure, training commands, evaluation commands, cluster-facing assumptions, and any caveats around unavailable assets.
   - Note every place where the README already contradicts, narrows, or extends the paper.
4. Map the repository, then trace the real execution path.
   - Use `rg --files` to map the repository first. Open only the files that control actual execution: configs, launch scripts, model definitions, dataset loaders, inference entrypoints, evaluation code, and training engine code.
   - Prioritize the inference pipeline over the training pipeline. Reconstruct how inputs are loaded, normalized, forwarded through the model, post-processed, and scored before moving to training details.
   - After the inference path is clear, trace the training path: data pipeline, augmentation, losses, optimizer, scheduler, checkpointing, logging, and distributed behavior.
   - Treat code as the source of truth for what actually runs on the remote Linux environment. Use the paper and README to explain intent, but use executable code to explain behavior.
5. Write the report under `analysis/`.
   - Create `analysis/` in the project root if it does not exist.
   - Write the main report to `analysis/<paper-stem>-method-impl-repro.md`. Use the PDF stem as `<paper-stem>` unless the user asks for a different name.
   - Follow `references/report-template.md` for the report structure.
   - Use `references/inspection-checklist.md` to avoid missing hidden reproduction issues.
   - State explicitly that local dependency availability on macOS is not evidence that the project is runnable; evaluate runtime feasibility against the remote Linux cluster target instead.

## Report Requirements

Always leave a concrete artifact in `analysis/` unless the user explicitly asks for a lighter answer. The report should be detailed enough that a later agent can continue the reproduction without rereading the entire paper and codebase from scratch.

Include these sections:

- `Artifacts`: exact local paths for the paper, README, key configs, core inference files, and core training files.
- `Paper Method`: the paper's stated method, datasets, and experiment setup.
- `Repository Guidance`: what the README and config surface tell you to do.
- `Implementation Reality`: what inference and training code actually do.
- `Execution Environment Assumptions`: what must hold on the remote Linux cluster, and which details are irrelevant or potentially misleading on the local Mac.
- `Paper-Code Consistency`: direct matches, partial matches, contradictions, and unresolved ambiguities.
- `Hidden Reproducibility Issues`: missing weights, undocumented preprocessing, inherited dataset conventions, implicit defaults, seed issues, unavailable scripts, and evaluation quirks.
- `Minimal Reproduction Path`: the shortest credible path to run inference or training, including blockers if full reproduction is not yet possible.

Use explicit evidence labels inside the report:

- `Stated in paper`
- `Stated in README/config`
- `Implemented in code`
- `Inferred from evidence`

## Working Rules

- Prefer local project artifacts over web summaries.
- Prefer visual PDF reading over plain-text extraction whenever layout matters.
- Treat README as mandatory reading, not optional context.
- Assume the user's local macOS machine is an editing and analysis environment, not the authoritative runtime environment.
- Assume training and evaluation are intended to run on a remote Linux cluster unless the user explicitly says otherwise.
- Do not judge reproducibility by whether commands can run locally on the Mac, and do not try to install or validate local dependencies as a proxy for experiment readiness.
- When discussing commands, dependencies, paths, CUDA requirements, or distributed launch behavior, evaluate them against the remote Linux cluster target and call out any macOS-versus-Linux mismatch.
- Inspect evaluation and inference code before training code unless the user explicitly asks only about training.
- Track reused datasets, inherited splits, and borrowed evaluation protocols from prior work. Many reproducibility failures come from details that the current paper assumes as common knowledge.
- Quote exact file paths, function names, class names, CLI flags, and config keys whenever possible.
- Separate confirmed facts from inference. Do not collapse uncertainty into a definitive claim.
- If a key asset is missing, say so clearly in the report and describe the impact on reproducibility.
- If paper, README, and code disagree, rank them as: code behavior first, README operational guidance second, paper intent third.

## References

- Read `references/report-template.md` before writing the final `analysis/` report.
- Read `references/inspection-checklist.md` while reconciling paper, README, configs, and executable code.

# Reproduction Checklist

Use this checklist before claiming a repository is reproducible or before planning modifications on top of it.

## Minimal Reproduction Spec

Confirm or extract:

- Exact code source: repository URL, branch, commit, or release tag.
- Python version and framework versions.
- Required system packages or custom ops.
- Dataset location and expected directory structure.
- Exact training command or script.
- Exact evaluation command or script.
- Config file plus all command-line overrides.
- Expected checkpoint artifact names and log locations.

## Hidden Variables That Often Break Reproduction

- Random seed is set in one place but not for dataloader workers or CUDA.
- Dataset split file is generated dynamically.
- Best checkpoint depends on a metric that is not the one reported in the paper.
- Validation uses different crop size, stride, or preprocessing than the paper summary suggests.
- Evaluation code silently applies post-processing not mentioned in the method section.
- Multi-GPU effective batch size differs from the reported batch size.
- Gradient accumulation changes the real optimizer step count.
- Mixed precision, EMA, or gradient clipping is enabled by default but undocumented.
- Fold assignment, subject exclusion, or preprocessing cache is stored outside the repo.

## Paper-Code Gap Report

When a gap is found, record it in this format:

- `Observed in paper`
- `Observed in code`
- `Effect on reproduction`
- `Confidence`
- `Action`

Example actions:

- keep code default and note paper mismatch
- test both settings
- mark as unresolved blocker
- search issues or supplemental material for clarification

## Reproduction Readiness Levels

- `Ready`
  - Main command path is identified and required settings are explicit.
- `Mostly ready`
  - Main path is identified but one or two important assumptions remain.
- `Blocked`
  - Dataset split, environment, checkpointing, or evaluation behavior is too ambiguous to trust results.

## Troubleshooting Order

When reproduced metrics do not match:

1. Confirm dataset split and filtering.
2. Confirm input size, spacing, and normalization.
3. Confirm augmentation and sampling policy.
4. Confirm learning rate schedule and effective batch size.
5. Confirm checkpoint selection and evaluation script.
6. Confirm thresholding, post-processing, and metric aggregation.

Do not start by changing the architecture unless the execution path is already verified.

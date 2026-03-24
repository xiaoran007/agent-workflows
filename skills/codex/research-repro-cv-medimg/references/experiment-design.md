# Modification and Comparison Planning

Use this file after the baseline behavior is understood. The goal is to change the right thing while keeping comparisons fair.

## Before Changing Anything

- Identify the smallest faithful baseline that can run.
- Freeze a reference config and checkpoint selection rule.
- Write down which metrics, split, and preprocessing pipeline define the baseline.
- Separate "needed for baseline reproduction" from "new experiment idea".

## Find Safe Modification Hooks

Prefer edits that are localized and reversible:

- Config keys for architecture variants.
- A single model block or loss module with a stable interface.
- Dataset transform functions that can be toggled cleanly.
- Evaluation and post-processing functions that can be parameterized.

Avoid starting with broad refactors unless the user explicitly wants restructuring.

## Fair Comparison Rules

Keep these constant unless the experimental question is specifically about them:

- dataset split
- preprocessing and normalization
- training budget
- optimizer family and scheduler
- checkpoint selection rule
- evaluation code and metric implementation
- number of seeds or folds

If one of these changes, say the comparison is not apples-to-apples.

## Ablation Planning

For each ablation, define:

- `Question`
- `Single variable changed`
- `Constants held fixed`
- `Expected effect`
- `Failure mode to watch`

Good ablations isolate one mechanism. Weak ablations bundle several changes together.

## Medical Imaging Caveats

For medimg comparisons, explicitly track:

- resampling spacing
- orientation handling
- patch sampling policy
- patient-level leakage risks
- scanner or site heterogeneity
- external validation versus internal validation

These often dominate architectural gains.

## Suggested Output Format

When the user asks for next experiments, propose a compact table with:

- experiment name
- exact files or config keys to change
- rationale
- expected runtime cost
- fairness risk
- priority

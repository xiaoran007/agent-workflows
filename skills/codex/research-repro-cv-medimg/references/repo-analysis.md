# Repository Analysis Workflow

Use this file when the user wants more than a README summary. The goal is to recover the real runnable path and implementation choices.

## Reading Order

1. Read `README`, installation notes, and any experiment table or command examples.
2. List the repository with `rg --files` and identify:
   - launch scripts
   - config directories
   - dataset modules
   - model definitions
   - training engine or trainer
   - evaluation or inference scripts
   - utilities for metrics, checkpointing, logging, and distributed setup
3. Open the main entrypoint and trace:
   - argument parsing
   - config loading and default overrides
   - dataset construction
   - model construction
   - optimizer and scheduler creation
   - training loop
   - validation and checkpoint selection
4. Open evaluation and inference code separately. Do not assume evaluation mirrors training defaults.

## What to Look For

### Config and launch behavior

- Which config file is actually used in the example command?
- Which values are set in code even if missing from configs?
- Which environment variables or external files are assumed?
- Is there a hidden default checkpoint, cache path, fold, or split file?

### Dataset path

- Where are file lists loaded?
- Where are transforms defined?
- Is preprocessing online or offline?
- Is there any sampling logic that changes class balance or patch distribution?

### Model path

- Which class is instantiated by default?
- Are there optional branches or loss heads enabled by config flags?
- Are pretrained weights loaded partially, strictly, or with ignored keys?

### Training path

- Where is the loss assembled?
- Where are metrics computed during training versus offline validation?
- How is the best checkpoint selected?
- Are mixed precision, gradient clipping, accumulation, EMA, or distributed sync used?

### Evaluation path

- Is there different preprocessing at test time?
- Are multiple checkpoints or folds ensembled?
- Are thresholds or post-processing parameters loaded from config, hard-coded, or tuned on validation?

## Reconciliation Rule

If paper text and code disagree:

- Prefer the exact command plus resolved config for runnable behavior.
- Report the disagreement explicitly.
- Avoid "the paper must mean X" unless you have multiple converging signals.

## Useful Shell Pattern

Prefer quick repository discovery first:

```bash
rg --files .
rg -n "argparse|OmegaConf|yaml|config|Dataset|DataLoader|optimizer|scheduler|validate|inference|metric" .
```

Then narrow into the few files that control behavior instead of reading the whole repo linearly.

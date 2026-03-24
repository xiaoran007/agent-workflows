# Inspection Checklist

Use this checklist while reconciling paper, README, configs, and code.

## Paper pass

- Confirm the exact task and output target.
- Confirm the model's proposed novelty versus reused components.
- Confirm the full inference procedure, not just the architecture block diagram.
- Confirm datasets, splits, metrics, and preprocessing.
- Confirm whether any experimental setting is delegated to prior work.
- Confirm whether appendix pages contain omitted implementation details.

## README pass

- Confirm environment creation steps.
- Confirm whether the documented environment assumes Linux, CUDA, Slurm, or other cluster-side tooling.
- Confirm whether pretrained checkpoints are public.
- Confirm dataset acquisition and preprocessing instructions.
- Confirm canonical inference and training commands.
- Confirm whether README notes differ from the paper.

## Inference code pass

- Confirm the true entry script.
- Confirm how configs and defaults are loaded.
- Confirm input normalization, resize, crop, padding, or tokenization.
- Confirm checkpoint loading behavior and strictness.
- Confirm test-time augmentation, ensembling, or sliding-window behavior.
- Confirm post-processing, thresholding, decoding, or NMS behavior.
- Confirm metric computation or saved artifact format.

## Training code pass

- Confirm data sampling and shuffling behavior.
- Confirm augmentation sequence and probabilities.
- Confirm loss composition and weights.
- Confirm optimizer, scheduler, warmup, gradient clipping, and AMP behavior.
- Confirm distributed training assumptions and effective batch size.
- Confirm checkpoint cadence, early stopping, and resume behavior.

## Execution environment pass

- Confirm which parts of the workflow are only meant for local editing or inspection.
- Confirm which commands are intended for remote Linux execution.
- Confirm whether shell scripts, path handling, or launch code are Linux-specific.
- Confirm whether CUDA, NCCL, MPI, Slurm, or cluster launch wrappers are required.
- Confirm whether macOS dependency success or failure would be misleading for reproduction.

## Reproducibility risk pass

- Check for hidden defaults not surfaced in README.
- Check for paths hard-coded to private storage.
- Check for version-sensitive dependencies.
- Check for implicit dependence on remote filesystems, mounted datasets, or job schedulers.
- Check for dataset variants with multiple unofficial split definitions.
- Check for reused settings inherited from earlier papers but not restated here.
- Check for mismatches between nominal and actual evaluation behavior.

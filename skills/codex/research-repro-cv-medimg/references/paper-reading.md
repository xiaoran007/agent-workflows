# Paper Reading Checklist

Use this file when reading the paper, appendix, or supplement. Extract evidence, not impressions.

## Visual-First Rule

- If the paper is available as a PDF, read it in a visual form first.
- Prefer rendered pages or another layout-preserving view over extracted plain text.
- Use extracted text only to search within the document or copy short snippets after you already know where the relevant content lives.
- Do not trust plain-text extraction alone for:
  - multi-column reading order
  - tables
  - formulas
  - architecture figures
  - algorithm pseudo-code blocks
  - footnotes, appendix references, and figure captions

For deep learning, computer vision, and medical imaging papers, layout is often part of the information. A malformed text extraction can scramble table rows, equation boundaries, symbols, and figure-text alignment.

## Core Questions

- What problem is being solved, and what is the exact prediction target?
- What is the novelty claim, and which parts are actually standard components?
- What are the paper's strongest empirical claims?
- Which claims depend on implementation details that may not be fully stated?

## Visual Inspection Checklist

Before summarizing the paper, inspect these parts directly on the rendered page:

- title, abstract, and contributions
- main method figure and caption
- all result tables and highlighted best numbers
- equations and loss definitions
- training details paragraphs, usually near implementation details or appendix
- dataset split tables, supplemental settings, and footnotes

If a table, formula, or figure is important, describe it from the visual source rather than trusting the text extraction order.

## Extraction Template

Capture the following items in a compact but explicit form:

- `Task and setting`
  - Supervised, self-supervised, weakly supervised, semi-supervised, detection, segmentation, registration, reconstruction, survival prediction, multimodal fusion, or another setting.
  - Input modality, label granularity, and inference target.
- `Datasets`
  - Dataset names, split policy, internal or external validation, patient-level or image-level splitting, preprocessing exclusions, and any pretraining corpus.
- `Input pipeline`
  - Spatial size, crop policy, patch policy, normalization, windowing, modality stacking, tokenization, and augmentation.
- `Method`
  - Backbone, encoder-decoder structure, fusion block, attention block, latent representation, feature pyramid, memory bank, or diffusion component.
  - What is new, what is reused, and what is optional.
- `Objective`
  - Loss terms, weights, auxiliary heads, consistency losses, distillation, regularization, and post-hoc calibration.
- `Training`
  - Optimizer, learning rate, schedule, warmup, epochs or iterations, batch size, mixed precision, gradient accumulation, early stopping, seeds, and hardware.
- `Inference`
  - Sliding window or full image, test-time augmentation, ensemble, thresholding, non-maximum suppression, connected-component filtering, post-processing, and checkpoint selection.
- `Evaluation`
  - Metrics, averaging policy, confidence intervals, bootstrap, fold aggregation, significance testing, and external validation.
- `Baselines and ablations`
  - Which settings must be matched to make later comparisons fair.

## High-Risk Omitted Details

Watch for these common omissions:

- Whether metrics are case-level, slice-level, lesion-level, pixel-level, or volume-level.
- Whether validation is used for checkpoint selection, hyperparameter tuning, or threshold calibration.
- Whether preprocessing happens offline or inside the dataloader.
- Whether patch sampling is class-balanced, random, hard-mined, or anatomy-aware.
- Whether input resolution, resampling spacing, and interpolation differ between training and testing.
- Whether the reported result is single-run, mean of several seeds, best seed, or ensemble.
- Whether the paper reports one split but the code defaults to another.

## MedImg-Specific Checks

- Record voxel spacing and anisotropy handling.
- Record orientation conventions and whether images are reoriented.
- Record intensity clipping, z-score normalization, and modality-specific preprocessing.
- Record patch overlap, context padding, and sliding-window aggregation.
- Record whether evaluation is patient-wise and whether multiple scans from one patient can leak across splits.

## Deliverable Style

When summarizing, separate these labels:

- `Paper says`
- `Supplement says`
- `Seen in visual PDF`
- `Not specified`
- `Likely inferred from code`

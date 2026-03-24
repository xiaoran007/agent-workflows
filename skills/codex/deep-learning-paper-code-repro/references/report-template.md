# Analysis Report Template

Use this template for `analysis/<paper-stem>-method-impl-repro.md`.

## 1. Artifacts

- Paper PDF:
- Repository root:
- README:
- Main inference entrypoint:
- Main training entrypoint:
- Key config files:
- Checkpoints or pretrained weights:

## 2. Paper Method

### Problem and claimed contribution

Summarize what the paper claims is new.

### Method details

Capture:
- model architecture
- inputs and outputs
- losses
- inference procedure
- training recipe
- post-processing

### Datasets and experimental paradigm

List:
- datasets
- split definitions
- metrics
- preprocessing
- borrowed settings from prior work

For every borrowed protocol, note the upstream paper, benchmark, or repository if identifiable.

## 3. Repository Guidance

Document what `README.md`, setup docs, and exposed configs instruct the user to do.

Include:
- environment setup
- dependency versions
- dataset download or organization
- preprocessing commands
- inference commands
- training commands
- stated hardware assumptions

## 4. Execution Environment Assumptions

State the default environment model explicitly:
- local macOS machine for reading, editing, and code inspection
- remote Linux cluster for actual training, evaluation, and large-scale inference

Capture:
- OS-specific assumptions in the repo
- CUDA, driver, and GPU assumptions
- distributed launch assumptions
- scheduler or cluster tooling assumptions
- path conventions that may break between local and remote environments
- reasons local dependency checks should not be treated as authoritative
## 5. Implementation Reality

### Inference pipeline

Trace the actual execution path:
- entry script
- config loading
- checkpoint loading
- preprocessing and transforms
- model forward path
- post-processing
- metric computation or result saving

### Training pipeline

Trace:
- dataset loader
- augmentation
- batching and sampling
- loss computation
- optimizer and scheduler
- checkpointing
- logging
- distributed behavior

## 6. Paper-Code Consistency

Use a table or bullet list with these labels:
- `Match`
- `Partial match`
- `Conflict`
- `Unresolved`

For each item, include:
- topic
- paper claim
- README or config claim
- code evidence
- conclusion

## 7. Hidden Reproducibility Issues

Look for:
- missing or private checkpoints
- missing preprocessing scripts
- undocumented dataset cleanup
- inherited assumptions from prior work
- random seed or nondeterminism issues
- silent defaults in config parsing
- evaluation-time tricks
- unavailable external dependencies
- Linux-only runtime assumptions
- cluster-only launch wrappers or scheduler dependencies
- code paths that differ from the paper's wording

## 8. Minimal Reproduction Path

Provide the shortest credible path to:
- run inference
- run evaluation
- start training

Express the path for the remote Linux cluster target. Include blockers, assumptions, and what still needs manual confirmation. If you mention local steps, limit them to editing, inspection, synchronization, or log reading.

## 9. Open Questions

List unresolved ambiguities that require:
- additional code reading
- missing assets
- paper appendix confirmation
- external benchmark documentation

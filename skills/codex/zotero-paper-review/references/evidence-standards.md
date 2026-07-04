# Evidence Standards

Use this reference to keep the review auditable and context-neutral.

## Evidence Labels

- `Paper statement`: Explicitly stated in the main PDF.
- `Appendix statement`: Explicitly stated in appendix or supplement.
- `Visual evidence`: Supported by a figure, table, equation, or algorithm box.
- `Zotero metadata`: Supported only by Zotero metadata.
- `Attachment evidence`: Supported by a Zotero attachment other than the main PDF.
- `Inferred from evidence`: Inferred from named evidence; explain the inference.
- `Not specified`: The paper does not state it.
- `Cannot confirm from the paper`: The available paper artifacts do not confirm it.

## Citation Granularity

Prefer the most precise locator available:

- section name or number
- PDF page number
- figure, table, equation, or algorithm number
- appendix or supplement section
- caption or footnote when it materially changes interpretation

Avoid unsupported phrases such as "clearly", "obviously", or "the authors likely mean" unless the report names the evidence and marks the statement as inference.

## Claim Auditing

For each important claim, capture:

- what the paper claims
- the evidence location
- whether experiments directly test the claim
- whether the reported baseline and metric are appropriate for that claim
- what remains untested or ambiguous

Treat a claim as only partially supported when the result covers a narrower setting than the wording of the claim.

## Experimental Evidence

For result claims, look for:

- dataset names and versions
- train/validation/test split policy
- sample size or number of tasks/cases
- metrics and averaging policy
- baselines and whether they use comparable inputs, data, and compute
- ablations that isolate the proposed component
- variance, confidence intervals, or significance tests
- external validation or out-of-domain tests

If any of these are missing and important, record the gap explicitly.

## Risk Review

Check whether the paper gives enough information to rule out:

- data leakage across train, validation, and test splits
- benchmark artifacts or synthetic shortcuts
- baseline under-tuning or unequal resources
- metric mismatch with the real objective
- generalization claims without out-of-domain evidence
- conclusions based only on simulation, private data, or one narrow dataset

Do not accuse the paper of a flaw unless evidence supports it. Use `risk cannot be ruled out from the paper` when the issue is simply unspecified.

## Relationship Network

Separate these cases:

- `Inherits from`: the paper explicitly builds on a prior method, dataset, benchmark, theory, or protocol.
- `Contrasts with`: the paper explicitly argues against or improves on a prior approach.
- `Uses as baseline`: the paper evaluates against the work.
- `Later inherited by`: require user-provided context, Zotero evidence, or another explicit source; otherwise write `Cannot confirm from the paper`.

Do not infer a paper-map connection unless the user supplies the map or asks for broader research-context mapping.

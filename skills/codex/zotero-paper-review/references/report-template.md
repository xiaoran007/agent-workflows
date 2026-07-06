# Zotero Paper Review Report Template

Use this template for `analysis/<paper-slug>-paper-review.md`. It is optimized for non-survey research papers. If the paper is a survey or position paper, keep `Source Artifacts`, `Identity`, and evidence standards, then explicitly mark method, data-flow, and experiment sections as `Not applicable` or adapt them to the paper's structure.

Every section must include a short narrative statement before tables or lists. Tables are for auditability; they should not replace prose interpretation.

## 1. Source Artifacts

Write one short paragraph stating what was reviewed, how the Zotero item was resolved, whether the paper was visually reviewed, and which evidence types were used. Do not list temporary copied PDF paths, rendered page-image paths, OCR files, or extraction artifacts unless they explain a blocker.

- User-provided title:
- Zotero item key:
- Better BibTeX citation key:
- Report date:
- Visual review used: yes / no
- Primary evidence reviewed: main PDF / appendix / supplement / Zotero metadata / attachments
- Better BibTeX export used: yes / no
- Missing or inaccessible artifacts:

## 2. Identity

Write a short paragraph identifying what kind of paper this is, where it sits, and what concrete artifacts are available.

| Field | Value | Evidence |
| --- | --- | --- |
| Title |  |  |
| Authors |  |  |
| Year |  |  |
| Venue |  |  |
| DOI / arXiv / URL |  |  |
| BibTeX | See the fenced `bibtex` block below this Identity table. | BBT export via `zotero-bbt-bibtex`; include citation key and export command details if available. |
| Field position |  |  |
| Code availability |  |  |
| Data availability |  |  |
| Paper type | method / dataset / benchmark / theory / application / survey / other |  |

### BibTeX Entry

Include the full Better BibTeX export entry.

```bibtex

```

## 3. Problem Definition

Write a concise paragraph explaining the paper's problem in plain language before filling the table.

| Question | Answer | Evidence |
| --- | --- | --- |
| What problem does the paper solve? |  |  |
| What is the input? |  |  |
| What is the output? |  |  |
| What task setting is assumed? |  |  |
| Is the paper's setting isomorphic to the user's target problem? | Not specified unless the user supplied that target problem |  |

## 4. Core Assumptions

Write a short paragraph summarizing the main assumptions the paper needs in order to work.

| Assumption Area | Paper-Backed Finding | Evidence | Uncertainty |
| --- | --- | --- | --- |
| Data |  |  |  |
| Labels / annotations |  |  |  |
| Scenario / deployment context |  |  |  |
| Model capability |  |  |  |
| Evaluation metric |  |  |  |
| Hidden or implicit assumption |  |  |  |

## 5. Method Mechanism

Write a short paragraph explaining the method's core mechanism and whether it is a new modeling view, an engineering composition, or a reuse of known components.

| Component | Role / Subproblem | Evidence | Novelty Assessment |
| --- | --- | --- | --- |
|  |  |  | New modeling view / engineering composition / reused component / Not specified |

## 6. Data Flow

Write a paragraph tracing how data moves through the paper's method, including modality, shape, granularity, preprocessing, representation changes, and outputs. Mark shape or processing details as `Not specified` when the paper does not state them.

| Stage | Data Form / Shape / Granularity | Processing Or Transformation | Output / Hand-Off | Evidence | Unspecified Details |
| --- | --- | --- | --- | --- | --- |
| Raw input |  |  |  |  |  |
| Preprocessing |  |  |  |  |  |
| Model input |  |  |  |  |  |
| Internal representation |  |  |  |  |  |
| Prediction / generation output |  |  |  |  |  |
| Post-processing / scoring |  |  |  |  |  |

## 7. Experiments

Write a paragraph summarizing the experiment design: what questions the experiments answer, what datasets and splits are used, how baselines are chosen, and what metrics define success.

| Experiment / Study | Research Question Tested | Dataset / Split | Setup Details | Baselines | Metrics | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

## 8. Evidence Chain

Write a paragraph explaining whether the paper's main claims are supported by its experiments and where the support is weak, indirect, or missing.

| Claim | Dataset / Split | Metric | Baseline | Ablation / Significance | Evidence | Supported? |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  | Supported / Partially supported / Not supported / Cannot confirm |

## 9. Limitations And Risks

Write a paragraph summarizing the most important limitations and risks, separating stated limitations from risks that cannot be ruled out from the paper.

| Risk Type | Finding | Evidence | Impact |
| --- | --- | --- | --- |
| Data leakage |  |  |  |
| Benchmark artifact |  |  |  |
| Unfair baseline |  |  |  |
| Metric mismatch |  |  |  |
| Generalization limit |  |  |  |
| Simulation-only or narrow setting |  |  |  |
| Other |  |  |  |

## 10. Relationship Network

Write a paragraph explaining what the paper inherits from, contrasts with, or positions itself against. Do not infer later influence unless the user provides external context.

| Relation | Paper / Work | Evidence | Notes |
| --- | --- | --- | --- |
| Inherits from |  |  |  |
| Contrasts with / refutes |  |  |  |
| Builds benchmark/data from |  |  |  |
| Later inherited by | Cannot confirm from the paper unless supported by provided external context |  |  |
| Existing paper-map node | Not specified unless the user provides a paper map |  |  |

## 11. Action Conclusion

Write a paragraph giving the action recommendation and the paper evidence behind it. Keep this separate from paper facts.

Choose one or more labels:

- `Ignore`
- `Background citation`
- `Method reference`
- `Experimental baseline`
- `Close reading`
- `Reproduction candidate`
- `Potential gap evidence`

| Recommendation | Evidence Basis | What To Do Next |
| --- | --- | --- |
|  |  |  |

## 12. Evidence Audit

Write a short paragraph summarizing the overall evidence quality and the highest-risk judgments.

| Important Judgment | Evidence Location | Evidence Type | Confidence | Notes |
| --- | --- | --- | --- | --- |
|  | section/page/figure/table/equation/appendix | paper / supplement / Zotero metadata / attachment / inference | high / medium / low |  |

## 13. Unconfirmed Items

Write a short paragraph explaining what remains unknown and why it matters.

List every important point that the paper does not specify or that cannot be confirmed from available Zotero artifacts.

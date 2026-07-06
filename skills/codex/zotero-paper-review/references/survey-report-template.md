# Zotero Survey Paper Review Report Template

Use this template for `analysis/<paper-slug>-paper-review.md` when the paper is a survey, review, systematic review, scoping review, meta-analysis, tutorial survey, benchmark overview, or position-style survey.

Survey review notes should evaluate how the paper organizes a field, not whether a single proposed method works. Every section must include a short narrative statement before tables or lists. Tables are for auditability; they should not replace prose synthesis.

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

Write a short paragraph identifying the survey type, field, intended audience, and whether the paper is primarily a field map, tutorial, systematic review, meta-analysis, benchmark overview, or position-style synthesis.

| Field | Value | Evidence |
| --- | --- | --- |
| Title |  |  |
| Authors |  |  |
| Year |  |  |
| Venue |  |  |
| Survey type | systematic review / scoping review / narrative survey / tutorial survey / meta-analysis / benchmark overview / position-style survey / other |  |
| DOI / arXiv / URL |  |  |
| BibTeX | See the fenced `bibtex` block below this Identity table. | BBT export via `zotero-bbt-bibtex`; include citation key and export command details if available. |
| Intended audience |  |  |
| Field position |  |  |

### BibTeX Entry

Include the full Better BibTeX export entry.

```bibtex

```

## 3. Scope And Field Boundary

Write a paragraph explaining what field, task family, method family, dataset family, or application space the survey claims to cover. State what the survey excludes or leaves ambiguous.

| Question | Answer | Evidence |
| --- | --- | --- |
| What domain or problem space is surveyed? |  |  |
| What questions does the survey ask? |  |  |
| What is explicitly in scope? |  |  |
| What is explicitly out of scope? |  |  |
| What time span is covered? |  |  |
| What geographic, language, venue, or discipline boundary is implied? |  |  |

## 4. Literature Selection And Exclusion

Write a paragraph evaluating how the surveyed literature was selected. Distinguish systematic search evidence from informal or narrative selection.

| Item | Finding | Evidence | Risk |
| --- | --- | --- | --- |
| Search databases |  |  |  |
| Search keywords / query strings |  |  |  |
| Inclusion criteria |  |  |  |
| Exclusion criteria |  |  |  |
| Screening process |  |  |  |
| Number of papers included |  |  |  |
| Reproducibility of search protocol |  |  |  |
| Selection bias risk |  |  |  |

## 5. Taxonomy

Write a paragraph explaining the survey's organizing framework. Evaluate whether the taxonomy categories are clear, mutually exclusive when needed, exhaustive enough for the stated scope, and useful for later paper mapping.

| Category / Axis | Definition | Boundary Rule | Evidence | Notes |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 6. Representative And Notable Works

Write a paragraph identifying the papers, datasets, benchmarks, or methods that deserve special attention after reading this survey. Separate works the survey treats as representative from works that appear practically important for follow-up reading.

| Work | Why It Matters | Taxonomy Location | Role | Evidence | Follow-Up Priority |
| --- | --- | --- | --- | --- | --- |
|  |  |  | foundational work / representative method / dataset source / benchmark source / contrastive work / notable gap / other |  | high / medium / low |

## 7. Topic Synthesis

Write a paragraph synthesizing the main topics covered by the survey. Do not merely list papers; state what the survey concludes about each topic.

| Topic | Main Ideas | Representative Works | Survey Conclusion | Evidence |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 8. Method And Dataset Entry Points

Write a paragraph explaining how the survey can be used as an entry point into methods and datasets. Highlight which method families, datasets, benchmarks, or evaluation setups are worth tracing to primary papers.

| Entry Point | Type | Why To Follow It | Primary Works / Sources | Evidence | Notes |
| --- | --- | --- | --- | --- | --- |
|  | method family / dataset / benchmark / metric / application / tool |  |  |  |  |

## 9. Comparative Dimensions

Write a paragraph explaining how the survey compares prior work and whether those comparison dimensions are sufficient.

| Dimension | Compared Items | Survey Finding | Evidence | Missing Comparison |
| --- | --- | --- | --- | --- |
| Methods |  |  |  |  |
| Datasets |  |  |  |  |
| Metrics |  |  |  |  |
| Applications |  |  |  |  |
| Assumptions |  |  |  |  |

## 10. Trends, Controversies, And Gaps

Write a paragraph identifying what the survey presents as major trends, unresolved controversies, and open gaps. Separate the survey authors' stated claims from reader-inferred gaps.

| Type | Finding | Source | Evidence | Confidence |
| --- | --- | --- | --- | --- |
| Trend |  | stated by survey / inferred from evidence |  | high / medium / low |
| Controversy |  | stated by survey / inferred from evidence |  | high / medium / low |
| Gap |  | stated by survey / inferred from evidence |  | high / medium / low |
| Open challenge |  | stated by survey / inferred from evidence |  | high / medium / low |

## 11. Coverage Risks And Biases

Write a paragraph assessing whether the survey may be incomplete, biased, outdated, or unclear in its classification choices.

| Risk | Finding | Evidence | Impact |
| --- | --- | --- | --- |
| Search bias |  |  |  |
| Venue or publisher bias |  |  |  |
| Language or region bias |  |  |  |
| Recency or outdated coverage |  |  |  |
| Taxonomy ambiguity |  |  |  |
| Missing subfield |  |  |  |
| Weak cross-paper comparison |  |  |  |

## 12. Relationship Network

Write a paragraph explaining how this survey can anchor a paper map. Identify foundational works, major branches, competing taxonomies, dataset hubs, and benchmark hubs only when supported by the survey.

| Relation | Paper / Cluster | Evidence | Notes |
| --- | --- | --- | --- |
| Foundational works |  |  |  |
| Major branches |  |  |  |
| Dataset hubs |  |  |  |
| Benchmark hubs |  |  |  |
| Competing taxonomies |  |  |  |
| Follow-up surveys | Cannot confirm from the paper unless supported by provided external context |  |  |

## 13. Reliability As Field Entry Point

Write a paragraph judging whether the survey is a reliable field entry point and whether it provides a usable primary-paper seed set.

| Question | Judgment | Evidence | Caveat |
| --- | --- | --- | --- |
| Is the domain boundary clear enough? |  |  |  |
| Is the literature selection transparent enough? |  |  |  |
| Is the taxonomy useful for paper mapping? |  |  |  |
| Are representative works sufficient as a seed set? |  |  |  |
| Is the survey current enough? |  |  |  |

## 14. Action Conclusion

Write a paragraph giving the action recommendation and the paper evidence behind it. Keep this separate from survey facts.

Choose one or more labels:

- `Background citation`
- `Paper map seed`
- `Taxonomy reference`
- `Representative work seed set`
- `Method landscape`
- `Dataset or benchmark pointer`
- `Gap evidence`
- `Ignore`

| Recommendation | Evidence Basis | What To Do Next |
| --- | --- | --- |
|  |  |  |

## 15. Evidence Audit

Write a short paragraph summarizing the overall evidence quality and the highest-risk judgments.

| Important Judgment | Evidence Location | Evidence Type | Confidence | Notes |
| --- | --- | --- | --- | --- |
|  | section/page/figure/table/appendix | paper / supplement / Zotero metadata / attachment / inference | high / medium / low |  |

## 16. Unconfirmed Items

Write a short paragraph explaining what remains unknown and why it matters.

List missing search-protocol details, unclear coverage boundaries, unsupported gap claims, taxonomy ambiguities, or primary-paper seed-set limitations.

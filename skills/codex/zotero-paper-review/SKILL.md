---
name: zotero-paper-review
description: Source-grounded Zotero candidate-paper review workflow. Use when the user gives a paper title and wants Codex to locate the item in Zotero, copy the paper PDF into the current project before processing, read the full paper and attachments, and produce a structured, context-neutral evidence audit covering identity, problem definition, assumptions, method, experimental evidence, limitations, relationship network, and action recommendation.
---

# Zotero Paper Review

## Overview

Convert a Zotero candidate paper into a structured, verifiable review report. Focus on what the paper itself states and supports; mark missing or unconfirmable information instead of filling gaps from background knowledge.

## Workflow

1. Resolve Zotero access and the target item.
   - Use the available Zotero skill or Zotero local workflow.
   - Run the Zotero readiness flow first, then search by the exact title supplied by the user.
   - If multiple plausible items match, stop and ask the user to choose. Do not silently pick a near match.
   - Use the `zotero-bbt-bibtex` skill to export the paper's BibTeX entry through Better BibTeX from the resolved Zotero item key.
   - Record the Zotero item key, Better BibTeX citation key, full BibTeX entry, title, creators, year, venue, DOI/arXiv identifier if available, URL, tags, collections, and attachment keys.
2. Retrieve the PDF and copy it into the project before reading.
   - Use Zotero attachment commands to identify the PDF attachment path or file URL.
   - Copy the PDF into `analysis/_tmp/zotero-paper-review/<paper-slug>/paper.pdf` under the current project root before any PDF processing.
   - Do not read, render, OCR, annotate, or otherwise process the Zotero-managed attachment in place.
   - If the project has no `analysis/` directory, create it when writing the report or copied PDF.
   - Keep supplementary PDFs, appendices, or extra material in the same temporary folder with clear filenames.
3. Read the copied paper visually.
   - Use the available PDF skill or another layout-preserving PDF workflow.
   - Inspect the rendered title/abstract, method figures, result tables, equations, algorithm boxes, captions, footnotes, limitations, and appendices.
   - Use extracted text only as a search aid after visual inspection.
4. Extract evidence into the review structure.
   - Read `references/report-template.md` before drafting the report.
   - Read `references/evidence-standards.md` while deciding whether a claim is supported, partially supported, inferred, or unconfirmed.
   - Prefer paper sections, page numbers, figures, tables, equations, and appendix locations over loose paraphrase.
5. Write the report.
   - Unless the user asks for an inline-only answer, write `analysis/<paper-slug>-paper-review.md`.
   - Include the copied PDF path, Zotero item key, Better BibTeX citation key, full BibTeX entry, and every source artifact used.
   - Keep the report neutral to the user's research agenda. Do not map the paper into a broader research context unless the user explicitly provides that context.
   - Separate paper evidence from reader-facing action recommendations.

## Working Rules

- Treat the paper, appendix, supplement, and Zotero metadata as the primary evidence.
- Do not use web summaries, citation counts, or broad field knowledge as evidence for what the paper says.
- Mark missing information as `Not specified` or `Cannot confirm from the paper`.
- Use `Inferred from evidence` only when the inference is necessary and the supporting evidence is named.
- For claims about code, data, or supplementary material, distinguish `Paper statement`, `Zotero metadata`, `Attachment evidence`, and `Cannot confirm`.
- For relationship-network claims, include only cited, contrasted, inherited, or explicitly discussed work unless the user provides an external paper map.
- For action conclusions, choose among `Ignore`, `Background citation`, `Method reference`, `Experimental baseline`, `Close reading`, `Reproduction candidate`, or `Potential gap evidence`, and explain what paper evidence supports the choice.
- If a required PDF or attachment is unavailable in Zotero, state the blocker and continue only with the strongest available evidence if the user agrees.

## References

- Read `references/report-template.md` before writing the final paper review.
- Read `references/evidence-standards.md` while auditing claims and uncertainty.

---
name: zotero-paper-review
description: Source-grounded Zotero candidate-paper review workflow. Use when the user gives a paper title and wants Codex to locate the item in Zotero, copy the paper PDF into the current project before processing, read the full paper and attachments, and produce a structured, context-neutral evidence audit covering identity, problem definition, assumptions, method, experimental evidence, limitations, relationship network, and action recommendation.
---

# Zotero Paper Review

## Overview

Convert a Zotero candidate paper into a structured, verifiable review report. Focus on what the paper itself states and supports; mark missing or unconfirmable information instead of filling gaps from background knowledge.

## Workflow

1. Resolve Zotero access and the target item.
   - Invoke [$Zotero](/Users/xiaoran/.codex/plugins/cache/openai-curated-remote/zotero/0.1.2/skills/zotero/SKILL.md).
   - Run the Zotero readiness flow first, then search by the exact title supplied by the user.
   - If multiple plausible items match, stop and ask the user to choose. Do not silently pick a near match.
   - Record the Zotero item key, title, creators, year, venue, DOI/arXiv identifier if available, URL, tags, collections, and attachment keys.
2. Retrieve the PDF and copy it into the project before reading.
   - Use Zotero attachment commands to identify the PDF attachment path or file URL.
   - Copy the PDF into `analysis/_tmp/zotero-paper-review/<paper-slug>/paper.pdf` under the current project root before any PDF processing.
   - Do not read, render, OCR, annotate, or otherwise process the Zotero-managed attachment in place.
   - If the project has no `analysis/` directory, create it when writing the report or copied PDF.
   - Keep supplementary PDFs, appendices, or extra material in the same temporary folder with clear filenames.
3. Read the copied paper visually.
   - Invoke [$pdf](/Users/xiaoran/.codex/skills/pdf/SKILL.md) for a visual-first PDF workflow.
   - Inspect the rendered title/abstract, method figures, result tables, equations, algorithm boxes, captions, footnotes, limitations, and appendices.
   - Use extracted text only as a search aid after visual inspection.
4. Extract evidence into the review structure.
   - Read `references/report-template.md` before drafting the report.
   - Read `references/evidence-standards.md` while deciding whether a claim is supported, partially supported, inferred, or unconfirmed.
   - Prefer paper sections, page numbers, figures, tables, equations, and appendix locations over loose paraphrase.
5. Write the report.
   - Unless the user asks for an inline-only answer, write `analysis/<paper-slug>-paper-review.md`.
   - Include the copied PDF path, Zotero item key, and every source artifact used.
   - Keep the report neutral to the user's research agenda. Do not map the paper into a broader research context unless the user explicitly provides that context.
   - Separate paper evidence from reader-facing action recommendations.

## Working Rules

- Treat the paper, appendix, supplement, and Zotero metadata as the primary evidence.
- Do not use web summaries, citation counts, or broad field knowledge as evidence for what the paper says.
- Mark missing information as `未说明` or `无法从论文中确认`.
- Use `从证据推断` only when the inference is necessary and the supporting evidence is named.
- For claims about code, data, or supplementary material, distinguish `论文说明`, `Zotero 元数据`, `附件证据`, and `无法确认`.
- For relationship-network claims, include only cited, contrasted, inherited, or explicitly discussed work unless the user provides an external paper map.
- For action conclusions, choose among `忽略`, `背景引用`, `方法参考`, `实验 baseline`, `核心精读`, `复现实验`, or `潜在 gap 证据`, and explain what paper evidence supports the choice.
- If a required PDF or attachment is unavailable in Zotero, state the blocker and continue only with the strongest available evidence if the user agrees.

## References

- Read `references/report-template.md` before writing the final paper review.
- Read `references/evidence-standards.md` while auditing claims and uncertainty.

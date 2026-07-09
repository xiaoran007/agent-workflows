---
name: qmd-revealjs-to-pptx
description: Create editable PowerPoint decks from Quarto revealjs presentations by treating the rendered HTML slides as the visual source of truth. Use when Codex needs to convert an index.qmd or Quarto revealjs project into a style-matched, editable PPTX for later manual PowerPoint refinement; visually reproduce revealjs spacing, typography, tables, images, diagrams, slide numbers, and overall deck rhythm; avoid Quarto/Pandoc native pptx layout breakage; render and QA the generated PPTX with screenshots/contact sheets; or iterate with visual review/subagents when requested.
---

# QMD RevealJS To PPTX

## Purpose

Use this workflow to turn a Quarto revealjs deck into an editable PowerPoint deck that is visually aligned with the HTML slides.

Treat `index.qmd` as the content source, rendered revealjs HTML as the visual source, and the generated PPTX as a practical editable handoff for final manual tuning.

## Core Rule

Do not use Quarto/Pandoc native `pptx` as the final route unless the user explicitly asks for a native Quarto PPTX experiment. Native PPTX is useful as a reference draft, but it often splits slides, reflows tables, changes columns, and loses revealjs visual rhythm.

Prefer a programmatic editable rebuild with the Presentations skill and `@oai/artifact-tool`.

## Standard Workflow

1. Inspect the project:

```bash
git status --short --branch
rg --files
sed -n '1,220p' <deck>/_quarto.yml
sed -n '1,260p' <deck>/index.qmd
```

Respect repository instructions. For Quarto projects, do not redirect `HOME` or cache paths; request escalation for normal `quarto render` if user-level cache access is blocked.

2. Render revealjs:

```bash
cd <deck>
quarto render
```

Use the generated HTML as the visual reference. If only a specific deck is needed, render that deck directory.

3. Capture visual references:

- Prefer browser screenshots or rendered slide images of the revealjs output.
- Capture a full-deck contact sheet when possible.
- Record slide size, theme, margins, slide-number/progress behavior, fonts, colors, and recurring table/image patterns.

4. Build the PPTX with `@oai/artifact-tool`:

- Use the Presentations skill and read its artifact-tool docs before coding.
- Create the generated `.mjs` builder in a scratch directory outside the repository unless the user asks to keep a reusable builder.
- Export a final `.pptx` to the requested path, repository convention, or scratch output.
- Keep output objects editable where practical: titles, paragraphs, bullets, tables, and simple diagrams should be native PowerPoint objects.

5. Match revealjs visually:

- Use the HTML slides as the visual truth, not the markdown source alone.
- Preserve the slide count and sequencing unless a slide is impossible to keep readable.
- Match the revealjs canvas size and margins, commonly `1280 x 720` for this project.
- Use simple white backgrounds, restrained typography, thin table/grid lines, and source images from the deck assets.
- Rebuild Mermaid or flowchart slides as native PowerPoint shapes when they must remain editable; use images only when fidelity matters more than editability.

6. Render and QA the PPTX:

- Render the final PPTX to PNG slides or PDF plus PNG pages.
- Create a contact sheet.
- Inspect full-size high-risk slides: title, image/table combinations, diagrams, wide metric tables, references, and any slide with dense text.
- Fix clipping, overlap, unexpected wrapping, wrong arrow direction, inconsistent page markers, and unreadable tables.

7. Use visual review/subagents only when allowed:

- If the user explicitly asks for subagent review or visual QA, spawn a bounded subagent after the first rendered PPTX contact sheet exists.
- Pass the contact sheet and a concise QA task.
- Do not pass hidden conclusions unless the review explicitly asks for confirmation.
- Iterate once or twice based on the findings.

See `references/visual-qa.md` for a compact checklist and subagent prompt pattern.

## Design Tradeoffs

- Prefer an editable near-match over a screenshot-perfect but uneditable deck.
- For dense metric tables, keep the complete data only when it remains readable. Otherwise emphasize key columns and preserve the full table only if the user asks.
- For deck-specific visual quirks, hard-code the layout in the builder instead of adding brittle generic fallback logic.
- Keep generated builders simple. Add reusable scripts only after the same pattern has repeated across multiple decks.

## Deliverables

Return the final `.pptx` path. Mention the revealjs HTML or screenshots used as the visual reference and any known limitations, such as slides intentionally simplified for readability.

If files are changed in a repository, keep commits small and focused: one commit for reusable workflow/scaffold changes, another for deck-specific generated artifacts if the user asks to track them.

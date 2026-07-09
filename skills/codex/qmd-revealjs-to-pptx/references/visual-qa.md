# Visual QA Checklist

Use this checklist after rendering the generated PPTX to slide images or a contact sheet.

## Check The Deck

- Slide count and order match the revealjs reference unless an intentional readability split is documented.
- Title slide matches the revealjs hierarchy and whitespace.
- Recurring slide chrome, slide numbers, footers, and progress indicators are consistent.
- Tables are readable at presentation scale and use consistent line weight, header styling, and alignment.
- Images preserve aspect ratio, are not over-cropped, and sit in the same visual role as revealjs.
- Mermaid/diagram replacements have correct arrow direction, grouping, labels, and color semantics.
- Dense result slides emphasize the intended metrics without inventing or changing data.
- References and citations remain present and legible enough for final manual editing.
- No unintended overlap, clipping, broken text wrapping, or off-canvas objects appear.

## High-Risk Slides

Inspect these at full size:

- Image plus table slides.
- Two-column slides.
- Mermaid or flowchart slides.
- Wide metric tables.
- Slides with long interpretation paragraphs.
- Final synthesis and reference slides.

## Subagent Prompt Pattern

Use only when the user explicitly asked for subagent/visual QA or confirmed delegation.

```text
Please do visual QA only; do not edit files.

Goal: this PPTX was generated from a Quarto revealjs deck and should visually match the HTML slides while remaining editable.

Review this contact sheet and list high-priority problems by slide number:
1. text/table too small or crowded,
2. clipping, overlap, unexpected wrapping, or off-canvas objects,
3. image aspect ratio or placement problems,
4. diagram arrow/label/layout errors,
5. slides that differ materially from the revealjs visual rhythm.

Return concrete fixes and an iteration priority order.
```

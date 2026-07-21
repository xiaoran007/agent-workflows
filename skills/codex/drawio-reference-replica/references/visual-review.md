# One-to-One Visual Review

## Review Evidence

Use three evidence levels:

1. Original full-resolution reference.
2. Native-resolution reference chunks.
3. Latest local PNG render of the complete `Replica` page.

The latest render must be produced after the latest XML edit. Compare at matched aspect ratio and a scale where text, thin strokes, arrowheads, and icon details are readable.

## Row-by-Row Review

Review every row of `replication-map.md`; do not sample repeated items or assume a canonical atom guarantees correct final placement.

For each row inspect:

- **Presence** — the object exists exactly where required and is not duplicated unexpectedly.
- **Geometry** — bounding box, aspect ratio, alignment, spacing, padding, rotation, and relative scale.
- **Appearance** — fill, stroke, opacity, dash, corner radius, shadow, icon construction, and highlight treatment.
- **Typography** — exact visible text, font family when known, size hierarchy, weight, color, alignment, and line breaks.
- **Connector** — source, target, direction, arrowhead, route, bend, crossing, fan-in/fan-out, and label placement.
- **Z-order** — background, containers, connectors, text, icons, and foreground decorations stack correctly.

Set one status:

- `MATCH` — no material visible mismatch.
- `PATCHED` — a mismatch was observed, corrected, and verified in a new render.
- `APPROXIMATE` — a visible difference remains for a specific documented reason.
- `MISSING` — no acceptable reconstruction exists; blocks handoff.

Do not use subjective numeric scores or minimum defect counts. The table must truthfully describe observed correspondence.

## Chunk Review

After reviewing object rows in a chunk, compare the chunk as a composition:

- internal balance and density;
- shared baselines and repeated gaps;
- containment and whitespace;
- connectors crossing chunk boundaries;
- local color and typography hierarchy.

A set of individually plausible atoms can still form an incorrect chunk. Patch composition-level differences and recheck affected rows.

## Full-Canvas Review

After all chunks pass, compare the complete reference and complete render:

- canvas aspect ratio and occupied bounds;
- major region proportions;
- global flow direction;
- margin and whitespace distribution;
- repeated-component rhythm;
- cross-region connectors;
- global color balance and visual hierarchy.

If the full composition is wrong, correct the assembly rather than distorting atoms that already match locally.

## Regression and Final Gate

Every patch requires:

1. a new local render;
2. re-review of the changed rows;
3. re-review of neighboring rows affected by geometry or z-order;
4. one full-canvas regression comparison.

Handoff is allowed only when:

- every reference chunk and visible object has a mapping row;
- no row is `PENDING` or `MISSING`;
- every `APPROXIMATE` row explains the remaining difference and cause;
- the final render was created after the final XML edit;
- the final full-canvas review found no undisclosed material mismatch.

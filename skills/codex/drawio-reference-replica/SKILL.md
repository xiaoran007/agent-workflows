---
name: drawio-reference-replica
description: Explicit-invocation-only workflow for strictly reproducing a user-provided bitmap reference, screenshot, or design sketch as native editable draw.io XML. Use only when the user explicitly invokes $drawio-reference-replica and wants the image decomposed into reference chunks, rebuilt as vector atomic components, assembled into a complete .drawio diagram, and reviewed one-to-one against the original. Do not use for generic diagram creation, paper interpretation, architecture design, or style inspiration.
---

# Draw.io Reference Replica

Convert a supplied bitmap into editable draw.io primitives with the reference image as the visual source of truth. Reproduce what is visibly present; do not redesign, infer missing scientific content, or substitute a generic house style.

## Required Environment

Verify all requirements before authoring:

- The original bitmap is available at its full resolution.
- A vision/image-reading tool can inspect the original, individual crops, and local render exports.
- draw.io Desktop CLI is installed locally and can export without opening an online service.
- The work directory is writable.
- A project virtual environment is available for bundled Python scripts. Prefer project venv, then conda; ask before using system Python.

If draw.io CLI or local image inspection is unavailable, stop and identify the missing dependency. Do not fall back to an iframe, browser automation, app.diagrams.net, remote conversion, or externally hosted images.

Read these references before starting:

- `references/replication-protocol.md` — mandatory chunking, atomization, assembly, and evidence workflow.
- `references/drawio-xml.md` — mandatory XML, grouping, editability, and two-page file rules.
- `references/local-cli.md` — mandatory local CLI discovery and rendering commands.
- `references/visual-review.md` — mandatory one-to-one review protocol and acceptance gate.

Resolve all paths relative to this skill directory.

## Output Contract

Create:

- `<name>.drawio` with `Components` as page 1 and `Replica` as page 2.
- `replication-map.md` mapping every reference chunk and visible object to its atomic component and final assembled cell/group.
- `<name>-review.png`, rendered locally from the final `Replica` page after the latest XML edit.
- Optional embedded-XML PNG, SVG, or PDF only when the user asks.

Keep the supplied bitmap and cropped reference chunks outside the final `.drawio`. Never embed the full reference bitmap, hide it behind vectors, or hand it off as part of the replica. A temporary background is allowed only during alignment and must be removed before validation.

## Strict Workflow

### 1. Freeze the reference

- Preserve the original file unchanged.
- Record its pixel dimensions, aspect ratio, orientation, visible background, and any uncertain or unreadable regions.
- Treat user-provided corrections as explicit overrides; otherwise copy visible text and geometry rather than interpreting them.

### 2. Slice the reference into chunks

- Divide the image into non-overlapping logical regions that cover the full canvas.
- Save native-resolution crops under `reference-chunks/` using stable IDs such as `R01-header.png`, `R02-pipeline.png`, and `R03-legend.png`.
- Subdivide dense chunks until every visible object can be inventoried without ambiguity.
- Record every chunk in `replication-map.md`. No area of the reference may be silently skipped.

### 3. Vectorize atomic components first

- Inventory the shapes, text lines, connectors, icons, highlights, brackets, and decorative elements inside each chunk.
- Assign each visible object a reference ID and each vector reconstruction an atomic ID.
- Build each atomic component as a grouped editable draw.io subtree on the `Components` page before assembling the final page.
- Prefer native text, vertices, edges, and primitive paths. Use a local SVG only when primitive reconstruction would materially reduce fidelity; record the approximation.
- Build repeated components once as a canonical group, then duplicate that group. Do not redraw repeated instances independently.
- Do not start the `Replica` page until every required row in `replication-map.md` has an atomic component or a documented asset blocker.

### 4. Assemble the complete diagram

- Copy atomic groups from `Components` into `Replica` and position them using the reference coordinate system.
- Preserve relative dimensions, spacing, alignment, z-order, text wrapping, arrow routes, and repeated patterns.
- Use stable IDs that preserve traceability, such as `A07-memory-card` on the component page and `F07-memory-card-03` on the final page.
- Add cross-component connectors only after the participating atomic groups are placed.

### 5. Validate and render locally

Run structural validation before visual review:

```bash
<python> <skill-dir>/scripts/validate_drawio.py <name>.drawio
```

Render page 2 locally:

```bash
<python> <skill-dir>/scripts/render_drawio.py <name>.drawio --page-index 1 --output <name>-review.png
```

The render must come from the current XML. Re-render after every XML change that could affect appearance.

### 6. Perform one-to-one visual review

- Inspect the original reference, every reference chunk, and the latest local render.
- Review every row of `replication-map.md`; sampling is forbidden.
- Compare presence, geometry, typography, appearance, connector behavior, and z-order for each mapped object.
- Then compare the complete reference and complete render at matched aspect ratio and comparable scale.
- Mark each row `MATCH`, `PATCHED`, `APPROXIMATE`, or `MISSING`, with concrete visual evidence.
- Fix every material mismatch and repeat the affected row review plus the full-canvas regression review.

Do not use fixed iteration counts, defect quotas, red-team quotas, or self-scores. Continue while real material mismatches remain.

### 7. Final gate and handoff

After the final XML edit:

1. Run structural validation again.
2. Render a new `Replica` review image.
3. Recheck all changed rows and complete one final full-canvas comparison.
4. Confirm no row is `MISSING` and every `APPROXIMATE` row has a specific reason.
5. Confirm the full reference bitmap is not embedded in the `.drawio`.

Provide the `.drawio`, latest review render, `replication-map.md`, requested exports, and a concise list of remaining approximations or assets the user could supply for further fidelity.

Never claim pixel-perfect or 100% reproduction. State that the artifact is a strict editable reconstruction and identify any remaining visible differences so the user can make informed final adjustments.

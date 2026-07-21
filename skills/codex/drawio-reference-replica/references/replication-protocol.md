# Bitmap Replication Protocol

## Purpose

Use a user-supplied bitmap as a visual specification for an editable draw.io reconstruction. Work from observable evidence, build vector atoms before the final composition, and maintain traceability from every reference object to the final diagram.

## Work Directory

Use a task-local directory:

```text
drawio-replica-work/
├── reference-original.<ext>
├── reference-chunks/
│   ├── R01-<region>.png
│   └── R02-<region>.png
├── replication-map.md
├── <name>.drawio
└── <name>-review.png
```

Preserve the original unchanged. Crops are inspection evidence, not final diagram assets.

## Phase 1: Canvas Partition

Partition the full reference into logical, non-overlapping chunks that cover the entire canvas. Choose boundaries at panels, stages, containers, legends, headers, footers, or natural whitespace. When a chunk remains too dense to inventory reliably, split it again.

For every chunk record:

- reference ID and crop path;
- pixel bounding box `(x, y, width, height)` in the original;
- normalized bounding box as fractions of canvas width and height;
- background, border, and dominant alignment;
- contained object IDs;
- uncertainty or clipped source content.

Do not use a few representative crops. Chunk coverage must account for the complete reference canvas.

## Phase 2: Visible-Object Inventory

Within every chunk, assign one reference object ID to each independently reviewable visual object:

- text line or bounded text block;
- filled or outlined shape;
- icon or illustration;
- connector, bracket, divider, or arrow;
- highlight, shadow, background band, or meaningful decoration;
- repeated unit or nested group.

Separate objects when they can differ independently in position, appearance, or meaning. Keep a coherent illustration together only when decomposing it would not improve editability or reviewability.

## Phase 3: Atomic Vectorization

Build atoms on the `Components` page before creating the complete diagram.

An atom is an editable group with:

- a stable atomic ID;
- a group bounding box and local coordinate system;
- native draw.io text and geometry where possible;
- internal z-order matching the reference;
- explicit styles rather than inherited editor state;
- no dependency on the original raster crop.

For repeated structures:

1. Build one canonical atom.
2. Validate its internal geometry against the clearest reference instance.
3. Duplicate the same subtree for other instances.
4. Apply only evidence-backed instance differences such as label or color changes.

Do not independently recreate repeated components because small inconsistencies accumulate in the final assembly.

## Phase 4: Full Assembly

Create the `Replica` page only after atomic coverage is complete.

- Map reference pixel coordinates to one consistent draw.io coordinate system.
- Place copied atomic groups using their outer bounding boxes first.
- Preserve alignment lines, shared baselines, repeated gaps, and margins.
- Add inter-atom connectors after placement so routes reflect final geometry.
- Keep background bands and large containers behind all dependent atoms.
- Use group parents and relative child coordinates so the user can move coherent components during manual refinement.

## Required Replication Map

Create `replication-map.md` with source metadata and this table:

```markdown
# Replication Map

## Source

- Reference: path/to/reference.png
- Pixel size: 1920 x 1080
- Draw.io: path/to/replica.drawio
- Components page: 0
- Replica page: 1

## One-to-One Map

| Ref ID | Chunk | Visible object | Atom ID | Final ID(s) | Geometry | Appearance | Text | Connector | Status | Evidence / remaining difference |
|---|---|---|---|---|---|---|---|---|---|---|
| R01-O01 | R01-header.png | Main title | A01-title | F01-title | pending | pending | pending | n/a | PENDING | |
```

Use one row per independently reviewable object. Connector rows may use `n/a` for text; text rows may use `n/a` for connectors. `PENDING` is allowed during construction but blocks handoff.

## Blockers

Stop and ask for input when:

- the reference is too low-resolution to read essential content;
- a required font or exact logo materially affects fidelity and is unavailable;
- an object is visually ambiguous enough that different reconstructions would change meaning;
- local cropping, image inspection, or draw.io CLI rendering is unavailable.

Do not silently invent missing text, use an unrelated icon, or skip an ambiguous region.

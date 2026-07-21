# Draw.io XML Rules for Reference Replication

## File Structure

Generate native, uncompressed draw.io XML. Use one `mxfile` with exactly these first two pages unless the user requests additional final pages:

1. `Components` — canonical editable atomic groups.
2. `Replica` — complete assembled reconstruction.

Each page must contain:

```xml
<mxGraphModel>
  <root>
    <mxCell id="0" />
    <mxCell id="1" parent="0" />
  </root>
</mxGraphModel>
```

Use unique IDs within each page. Vertices require `vertex="1"`; edges require `edge="1"`. Every non-root cell must reference an existing parent. Connected edges must reference existing source and target cells and use `<mxGeometry relative="1" as="geometry" />`.

## Atomic Groups

Represent each atom as a parent vertex with child cells positioned relative to the group:

```xml
<mxCell id="A01-card" value="" style="group;" vertex="1" parent="1">
  <mxGeometry x="40" y="40" width="180" height="90" as="geometry" />
</mxCell>
<mxCell id="A01-card-bg" value="" style="rounded=1;..." vertex="1" parent="A01-card">
  <mxGeometry x="0" y="0" width="180" height="90" as="geometry" />
</mxCell>
```

Keep children within the group coordinate system. Place the outer group to reposition the entire component. Use explicit geometry and styles so XML regeneration is deterministic.

On the `Replica` page, copy canonical group subtrees with new `F...` IDs. Draw.io groups are copied instances, not linked symbols; preserve the canonical structure and change only evidence-backed instance properties.

## Visual Fidelity Rules

- Match the reference canvas aspect ratio and page dimensions before placing atoms.
- Use one cell per important visual line when exact wrapping matters.
- Preserve visible whitespace, padding, stroke width, dash pattern, corner radius, and opacity.
- Use native edges for arrows and connectors. Hand-author waypoints when the visible route is part of the reference design.
- Preserve arrowhead placement and direction; geometry without correct direction is not a match.
- Use explicit z-order through XML cell order and containment.
- Avoid `overflow=visible` for bounded labels.
- Escape XML special characters and use deliberate HTML labels only where the reference requires rich text.

## Asset and Raster Rules

Prefer native draw.io primitives. A local SVG may be embedded when an exact complex icon cannot be represented reasonably with primitives. Keep its provenance in `replication-map.md` and identify it as less atomically editable.

Do not embed:

- the original bitmap;
- reference chunks;
- remote image URLs;
- unapproved PNG, JPEG, GIF, or WebP data URIs.

A temporary raster alignment layer must be removed before final validation.

## Official Compatibility

Follow the stable structural rules in the official draw.io AI XML reference: mandatory root/layer cells, unique IDs, uncompressed XML, valid parent references, explicit geometry, well-formed style strings, and escaped labels. Keep this local reference sufficient for runtime use; network access is not required.

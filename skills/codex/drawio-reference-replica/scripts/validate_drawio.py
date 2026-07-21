#!/usr/bin/env python3
"""Validate the structural contract for a draw.io reference replica."""

from __future__ import annotations

import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


REMOTE_IMAGE_RE = re.compile(r"image=https?://", re.IGNORECASE)
RASTER_DATA_RE = re.compile(r"data:image/(?:png|jpe?g|gif|webp);", re.IGNORECASE)


def geometry(cell: ET.Element) -> ET.Element | None:
    return cell.find("mxGeometry")


def validate_page(diagram: ET.Element) -> tuple[list[str], list[str], int]:
    name = diagram.get("name", "<unnamed>")
    errors: list[str] = []
    warnings: list[str] = []
    model = diagram.find("mxGraphModel")
    if model is None:
        return [f"page {name!r}: missing mxGraphModel"], warnings, 0
    root = model.find("root")
    if root is None:
        return [f"page {name!r}: missing root"], warnings, 0

    cells = list(root.findall("mxCell"))
    ids = [cell.get("id") for cell in cells]
    if not cells or ids[:2] != ["0", "1"]:
        errors.append(f"page {name!r}: first cells must be id 0 and id 1")
    elif cells[1].get("parent") != "0":
        errors.append(f"page {name!r}: cell 1 must have parent 0")

    missing_ids = [index for index, cell_id in enumerate(ids) if not cell_id]
    if missing_ids:
        errors.append(f"page {name!r}: cells without ids at indexes {missing_ids[:5]}")
    actual_ids = [cell_id for cell_id in ids if cell_id]
    duplicates = sorted({cell_id for cell_id in actual_ids if actual_ids.count(cell_id) > 1})
    if duplicates:
        errors.append(f"page {name!r}: duplicate cell ids: {', '.join(duplicates[:10])}")
    id_set = set(actual_ids)

    for cell in cells:
        cell_id = cell.get("id", "<missing>")
        if cell_id not in {"0", "1"}:
            parent = cell.get("parent")
            if not parent:
                errors.append(f"page {name!r}: cell {cell_id!r} has no parent")
            elif parent not in id_set:
                errors.append(f"page {name!r}: cell {cell_id!r} references missing parent {parent!r}")

        is_vertex = cell.get("vertex") == "1"
        is_edge = cell.get("edge") == "1"
        if is_vertex and is_edge:
            errors.append(f"page {name!r}: cell {cell_id!r} is both vertex and edge")
        if is_vertex:
            geom = geometry(cell)
            if geom is None:
                errors.append(f"page {name!r}: vertex {cell_id!r} has no geometry")
            else:
                for attribute in ("width", "height"):
                    raw = geom.get(attribute)
                    try:
                        value = float(raw) if raw is not None else None
                    except ValueError:
                        value = None
                    if value is None or value <= 0:
                        errors.append(
                            f"page {name!r}: vertex {cell_id!r} has invalid {attribute}={raw!r}"
                        )
        if is_edge:
            geom = geometry(cell)
            if geom is None or geom.get("relative") != "1":
                errors.append(f"page {name!r}: edge {cell_id!r} needs relative geometry")
            for endpoint in ("source", "target"):
                reference = cell.get(endpoint)
                if reference and reference not in id_set:
                    errors.append(
                        f"page {name!r}: edge {cell_id!r} references missing {endpoint} {reference!r}"
                    )

        label = cell.get("value", "")
        if "TODO" in label or "PLACEHOLDER" in label:
            warnings.append(f"page {name!r}: cell {cell_id!r} contains placeholder text")

    return errors, warnings, len(cells)


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a draw.io reference replica.")
    parser.add_argument("drawio", type=Path)
    parser.add_argument("--json", action="store_true", help="Emit JSON")
    args = parser.parse_args()

    path = args.drawio.expanduser().resolve()
    errors: list[str] = []
    warnings: list[str] = []
    page_stats: dict[str, int] = {}
    if not path.is_file():
        errors.append(f"file not found: {path}")
    else:
        text = path.read_text(encoding="utf-8")
        if REMOTE_IMAGE_RE.search(text):
            errors.append("remote image URL found; replicas must be self-contained")
        if RASTER_DATA_RE.search(text):
            errors.append("embedded raster image found; remove reference bitmap and raster crops")
        try:
            root = ET.fromstring(text)
        except ET.ParseError as exc:
            errors.append(f"XML parse error: {exc}")
            root = None

        if root is not None:
            if root.tag != "mxfile":
                errors.append(f"root tag must be 'mxfile', found {root.tag!r}")
            diagrams = list(root.findall("diagram"))
            names = [diagram.get("name", "") for diagram in diagrams]
            if len(diagrams) < 2:
                errors.append("expected at least two pages: Components and Replica")
            if names[:2] != ["Components", "Replica"]:
                errors.append(
                    f"first two pages must be ['Components', 'Replica'], found {names[:2]!r}"
                )
            for diagram in diagrams:
                page_errors, page_warnings, count = validate_page(diagram)
                errors.extend(page_errors)
                warnings.extend(page_warnings)
                page_stats[diagram.get("name", "<unnamed>")] = count

    report = {
        "file": str(path),
        "ok": not errors,
        "pages": page_stats,
        "errors": errors,
        "warnings": warnings,
    }
    if args.json:
        print(json.dumps(report, indent=2, ensure_ascii=False))
    else:
        print(f"file: {path}")
        print(f"pages: {page_stats}")
        for warning in warnings:
            print(f"WARNING: {warning}", file=sys.stderr)
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        print("validation: PASS" if not errors else "validation: FAIL")
    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main())

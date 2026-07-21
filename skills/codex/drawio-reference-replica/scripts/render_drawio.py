#!/usr/bin/env python3
"""Render a draw.io page locally with draw.io Desktop CLI."""

from __future__ import annotations

import argparse
import os
import shlex
import shutil
import subprocess
import sys
from pathlib import Path


def find_drawio(explicit: str | None) -> Path:
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit).expanduser())
    if os.environ.get("DRAWIO_CLI"):
        candidates.append(Path(os.environ["DRAWIO_CLI"]).expanduser())

    for command in ("drawio", "draw.io", "draw.io.exe"):
        resolved = shutil.which(command)
        if resolved:
            candidates.append(Path(resolved))

    candidates.extend(
        [
            Path("/Applications/draw.io.app/Contents/MacOS/draw.io"),
            Path.home() / "Applications/draw.io.app/Contents/MacOS/draw.io",
            Path("/mnt/c/Program Files/draw.io/draw.io.exe"),
            Path("C:/Program Files/draw.io/draw.io.exe"),
        ]
    )

    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()

    raise FileNotFoundError(
        "draw.io Desktop CLI was not found. Install draw.io Desktop or pass "
        "--drawio /path/to/executable (or set DRAWIO_CLI). No online fallback is used."
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export a draw.io page locally for visual review or handoff."
    )
    parser.add_argument("input", type=Path, help="Source .drawio file")
    parser.add_argument("--output", type=Path, help="Output path")
    parser.add_argument("--format", choices=("png", "svg", "pdf"), default="png")
    parser.add_argument("--page-index", type=int, default=1, help="Zero-based page index")
    parser.add_argument("--border", type=int, default=0, help="Export border in pixels")
    parser.add_argument("--scale", type=float, help="Optional export scale")
    parser.add_argument("--embed", action="store_true", help="Embed diagram XML in export")
    parser.add_argument("--drawio", help="Explicit draw.io Desktop CLI path")
    parser.add_argument("--dry-run", action="store_true", help="Print command without running it")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    source = args.input.expanduser().resolve()
    if not source.is_file():
        print(f"error: input file not found: {source}", file=sys.stderr)
        return 2
    if source.suffix.lower() != ".drawio":
        print(f"error: input must end in .drawio: {source}", file=sys.stderr)
        return 2
    if args.page_index < 0 or args.border < 0:
        print("error: page index and border must be non-negative", file=sys.stderr)
        return 2

    try:
        executable = find_drawio(args.drawio)
    except FileNotFoundError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 3

    output = args.output or source.with_name(f"{source.stem}-review.{args.format}")
    output = output.expanduser().resolve()
    output.parent.mkdir(parents=True, exist_ok=True)

    command = [
        str(executable),
        "--disable-update",
        "-x",
        "-f",
        args.format,
        "--page-index",
        str(args.page_index),
        "-b",
        str(args.border),
    ]
    if args.scale is not None:
        if args.scale <= 0:
            print("error: scale must be positive", file=sys.stderr)
            return 2
        command.extend(["-s", str(args.scale)])
    if args.embed:
        command.append("-e")
    command.extend(["-o", str(output), str(source)])

    if args.dry_run:
        print(shlex.join(command))
        return 0

    environment = os.environ.copy()
    environment["DRAWIO_DISABLE_UPDATE"] = "true"
    result = subprocess.run(command, env=environment, check=False)
    if result.returncode != 0:
        return result.returncode
    if not output.is_file():
        print(f"error: draw.io reported success but output was not created: {output}", file=sys.stderr)
        return 4

    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

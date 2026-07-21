# Local Draw.io CLI

## Requirement

Use draw.io Desktop CLI as the only rendering path. Do not use browser iframe previews, app.diagrams.net URLs, MCP conversion, or remote render services.

Configure draw.io before invoking this skill. Common executable locations are:

- macOS: `/Applications/draw.io.app/Contents/MacOS/draw.io`
- Linux: `drawio` or `draw.io` on `PATH`
- Windows: `draw.io.exe` in the draw.io installation directory
- WSL: the Windows executable under `/mnt/c/Program Files/draw.io/`

The bundled renderer checks an explicit `--drawio` path, `DRAWIO_CLI`, `PATH`, and common platform locations. If no executable is found, stop and ask the user to install or configure draw.io Desktop.

## Review Render

With `Components` at page index 0 and `Replica` at page index 1:

```bash
<python> <skill-dir>/scripts/render_drawio.py replica.drawio \
  --page-index 1 \
  --border 0 \
  --output replica-review.png
```

The script disables update checks for the CLI subprocess. It does not access the network or open the editor UI.

Use PNG for visual review. Re-render after every appearance-affecting XML edit. Never review a stale export.

## Final Editable Exports

When the user asks for PNG, SVG, or PDF, embed the diagram XML in the exported file:

```bash
<python> <skill-dir>/scripts/render_drawio.py replica.drawio \
  --format svg \
  --page-index 1 \
  --embed \
  --output replica.drawio.svg
```

Always keep the source `.drawio`; the exported file does not replace it.

## Environment Discipline

Run the bundled Python script with the target project's virtual environment. If none exists, check conda next and ask before using system Python. The script uses only the Python standard library.

Do not install dependencies or choose a browser fallback when the CLI is missing.

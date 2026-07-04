---
name: zotero-bbt-bibtex
description: Export correct BibTeX for one or more Zotero items through Better BibTeX, not Zotero's standard Local API BibTeX exporter. Use when Codex needs a BBT-respecting BibTeX entry from a Zotero item key, BBT citation key, paper title, Markdown or LaTeX citation workflow, references.bib update, or any request that explicitly mentions Better BibTeX, BBT, citation keys, or Zotero BibTeX cleanup rules.
---

# Zotero BBT BibTeX

## Overview

Export BibTeX through the Better BibTeX HTTP endpoints so BBT citation keys and BBT export preferences are respected. Use direct HTTP calls with `curl`; do not use Zotero's standard `format=bibtex` Local API export as the BibTeX source.

## Core Rule

- Use `/better-bibtex/json-rpc` to resolve BBT citation keys and library IDs.
- Use `/better-bibtex/export/item` for the final BibTeX export.
- Always include `worker=false` for Codex or headless environments.
- Use `translator=bibtex` for BibTeX output through Better BibTeX.
- Do not use `translator=bib`; in BBT this maps to Better BibLaTeX.
- Do not use `/api/users/0/items?itemKey=<key>&format=bibtex` for final output. That is Zotero's standard BibTeX export and may include fields that BBT preferences would omit.

## Workflow

1. Resolve the Zotero item key.
   - If the user supplies a Zotero item key such as `NCZC4ZKE`, use it directly.
   - If the user supplies only a title or query, invoke [$Zotero](/Users/xiaoran/.codex/plugins/cache/openai-curated-remote/zotero/0.1.2/skills/zotero/SKILL.md) to search Zotero and identify the exact item key.
   - Use Zotero's Local API only for lookup or disambiguation, not for the final BibTeX export.
2. Get the BBT citation key.

   ```bash
   curl -sS -X POST \
     -H "Content-Type: application/json" \
     --data '{"jsonrpc":"2.0","method":"item.citationkey","params":[["NCZC4ZKE"]],"id":1}' \
     "http://127.0.0.1:23119/better-bibtex/json-rpc"
   ```

   Expected shape:

   ```json
   {"NCZC4ZKE":"vaswaniAttentionAllYou2017"}
   ```

3. Get the BBT library ID.

   ```bash
   curl -sS -X POST \
     -H "Content-Type: application/json" \
     --data '{"jsonrpc":"2.0","method":"user.groups","params":[false],"id":2}' \
     "http://127.0.0.1:23119/better-bibtex/json-rpc"
   ```

   Use the library ID that contains the item. For My Library, this is often `1`, but do not hardcode it when the JSON-RPC response gives a different value or the item belongs to a group library.

4. Export BibTeX through BBT.

   ```bash
   curl -sS --get \
     "http://127.0.0.1:23119/better-bibtex/export/item" \
     --data-urlencode "libraryID=1" \
     --data-urlencode "citationKeys=vaswaniAttentionAllYou2017" \
     --data-urlencode "translator=bibtex" \
     --data-urlencode "worker=false"
   ```

5. Return or save the result.
   - If the user asks for the BibTeX entry, paste the exported entry exactly as returned.
   - If the user asks to update a `.bib` file, write the BBT export output to that file or replace the matching entry after confirming the target file.
   - Report the Zotero item key, BBT citation key, library ID, translator, and whether `worker=false` was used.

## Multiple Items

For multiple Zotero item keys, pass all item keys to `item.citationkey` as one array, then pass the returned BBT citation keys to `citationKeys` as a comma-separated list:

```text
citationKeys=keyOne,keyTwo,keyThree
```

Use the same `translator=bibtex` and `worker=false` parameters.

## Failure Handling

- If the sandbox blocks `127.0.0.1:23119`, rerun the same `curl` command with elevated localhost access.
- If Zotero is not running or the local API is disabled, use the Zotero skill readiness flow before retrying.
- If BBT endpoints return 404 or no response, report that Better BibTeX may be missing or disabled.
- If the export raises `TypeError: can't access property "getSelectedLibraryID", Zotero.getActiveZoteroPane() is null`, add or confirm `worker=false`.
- If export output is empty, verify that `libraryID` matches the item library and that `citationKeys` contains the BBT citation key, not the Zotero item key.
- If the output looks like BibLaTeX, check that `translator=bibtex` was used and not `translator=bib`.

## Validation Checklist

- The final BibTeX entry came from `/better-bibtex/export/item`.
- The final command used `translator=bibtex`.
- The final command used `worker=false`.
- The entry key matches the BBT citation key returned by `item.citationkey`.
- The response starts with a BibTeX entry type such as `@article`, `@inproceedings`, `@book`, or another BibTeX entry.
- The result was not copied from Zotero's standard `format=bibtex` Local API response.

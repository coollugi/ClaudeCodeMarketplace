#!/usr/bin/env python3
"""Read back what a component's `.md` documentation claims about its API.

The cache files are meant to hold "what the docs say"; the source extractor
(extract-api.py) holds "what the code says". Reconciling those two is the whole
point of a same-version run, so both sides must be machine-readable.

Parses, per `references/components/<Comp>.md`:

  * every markdown table whose first header cell is Prop/Input/Property/Name
    → props {name: {type, default, required}}
  * every table whose first header cell is Output/Event → outputs
  * the value imports in fenced code blocks that import from the package
    → standaloneImports (what a consumer puts in `imports: []`)
  * `MZN_*` identifiers the prose presents as provided by the component
    → providesTokens

Deliberately permissive: a table the parser cannot read must not be reported as
a missing table (RECONCILIATION.md — that mistake has produced phantom gaps).
Rows whose first cell is not an identifier are skipped, not guessed at.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from typing import Dict, List, Optional

PROP_HEADERS = {"prop", "props", "property", "input", "inputs", "name", "屬性", "參數"}
OUTPUT_HEADERS = {"output", "outputs", "event", "events"}
TYPE_HEADERS = {"type", "型別", "類型"}
DEFAULT_HEADERS = {"default", "預設", "預設值"}
NO_VALUE = {"—", "-", "–", "──", "n/a", "na", "無", ""}


def _cells(line: str) -> List[str]:
    row = line.strip()
    if row.startswith("|"):
        row = row[1:]
    if row.endswith("|"):
        row = row[:-1]
    # Split on unescaped pipes: `\|` inside a type cell is a union, not a column.
    parts = re.split(r"(?<!\\)\|", row)
    return [p.strip() for p in parts]


def _plain(cell: str) -> str:
    text = cell.replace("\\|", "|")
    text = re.sub(r"<br\s*/?>", " ", text)
    text = text.replace("`", "").replace("**", "").replace("*", "")
    return " ".join(text.split()).strip()


def _identifier(cell: str) -> Optional[str]:
    text = _plain(cell)
    text = re.sub(r"\s*\((?:required|必填|deprecated|已棄用)\)\s*$", "", text, flags=re.I)
    text = text.split()[0] if text else ""
    text = text.rstrip("?")
    return text if re.fullmatch(r"[A-Za-z_$][\w$]*", text) else None


def _type_and_required(cell: str) -> (Optional[str], bool):
    text = _plain(cell)
    required = bool(re.search(r"\((?:required|必填)\)|必填", text, re.I))
    text = re.sub(r"\((?:required|必填|optional|選填)\)", "", text, flags=re.I).strip()
    # React docs write unions with a slash in some tables:
    # `TableActions<T> / TableActionsWithMinWidth<T>`.
    text = re.sub(r"\s+/\s+", " | ", text)
    # `RadioSize ('main' | 'sub')` — the alias is the type, the parenthetical is
    # its expansion for the reader.
    alias = re.match(r"^([A-Za-z_$][\w$]*(?:<[^<>]*>)?)\s*\((.+)\)$", text)
    if alias:
        text = alias.group(1)
    return (text or None), required


def _required_from_description(cell: str) -> bool:
    """React tables carry requiredness in the Description column.

    A row reads `| variant | BadgeCountVariant | - | Required, count variant |`;
    reading only the Type column reported 65 correctly-documented props as
    "required in source, optional in docs".
    """
    text = _plain(cell)
    return bool(re.match(r"^(required|必填|必要)\b", text, re.I))


def _default(cell: str) -> Optional[str]:
    text = _plain(cell)
    if text.lower() in NO_VALUE:
        return None
    # "false（rc.7 起）" / "`'main'`（見下方）" — keep the literal, drop the aside.
    text = re.split(r"[（(]", text)[0].strip()
    return text or None


HOOK_HEADING = re.compile(r"^#{2,4}\s.*\b(hooks?|use[A-Z]\w*)\b", re.I)


def parse_tables(lines: List[str]) -> (Dict[str, Dict[str, object]], Dict[str, Dict[str, object]]):
    props: Dict[str, Dict[str, object]] = {}
    outputs: Dict[str, Dict[str, object]] = {}
    i, n = 0, len(lines)
    in_fence = False
    in_hook_section = False
    while i < n:
        line = lines[i]
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            i += 1
            continue
        if not in_fence and line.startswith("#"):
            # A hook's return value is not a component prop. `useStepper` returns
            # goToStep/isFirstStep/nextStep, and reading those tables as props
            # reported them as "documented but absent from source".
            in_hook_section = bool(HOOK_HEADING.match(line))
        if in_hook_section:
            i += 1
            continue
        if in_fence or "|" not in line:
            i += 1
            continue
        header = _cells(line)
        if len(header) < 2 or i + 1 >= n or not re.match(r"^\s*\|?[\s:-]*-[-\s:|]*\|?\s*$", lines[i + 1]):
            i += 1
            continue
        keys = [_plain(h).lower() for h in header]
        first = keys[0]
        bucket: Optional[Dict[str, Dict[str, object]]] = None
        if first in PROP_HEADERS:
            bucket = props
        elif first in OUTPUT_HEADERS:
            bucket = outputs
        if bucket is None:
            i += 2
            while i < n and "|" in lines[i] and not lines[i].lstrip().startswith("```"):
                i += 1
            continue
        type_idx = next((k for k, h in enumerate(keys) if h in TYPE_HEADERS), None)
        default_idx = next((k for k, h in enumerate(keys) if h in DEFAULT_HEADERS), None)
        i += 2
        while i < n and "|" in lines[i] and not lines[i].lstrip().startswith("```"):
            row = _cells(lines[i])
            name = _identifier(row[0]) if row else None
            if name:
                type_text, required = _type_and_required(row[type_idx]) if type_idx is not None and type_idx < len(row) else (None, False)
                default = _default(row[default_idx]) if default_idx is not None and default_idx < len(row) else None
                description_idx = next((k for k, h in enumerate(keys) if h.startswith("desc") or h in {"說明", "描述"}), None)
                if description_idx is not None and description_idx < len(row):
                    required = required or _required_from_description(row[description_idx])
                entry = {"type": type_text, "default": default, "required": required}
                # A later table (a "新增的 Inputs" section) refines an earlier row
                # rather than replacing it; keep the first non-empty values.
                previous = bucket.get(name)
                if previous is None:
                    bucket[name] = entry
                else:
                    for key in ("type", "default"):
                        if previous.get(key) is None:
                            previous[key] = entry[key]
                    previous["required"] = previous.get("required") or required
            i += 1
    return props, outputs


def _kebab(name: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", "-", name).lower()


def parse_imports(text: str, package: str) -> List[str]:
    """Value imports from the component's OWN package sub-path.

    `import type { BadgeVariant }` is a type-only import and never goes into an
    Angular `imports: []`, so it is excluded. Neither do symbols a usage example
    imports from a *different* sub-path: `Button.md` importing `MznIcon` from
    `@mezzanine-ui/ng/icon` says nothing about what `@mezzanine-ui/ng/button`
    exports, and counting them reported 22 phantom "documented but not exported"
    symbols across 17 components.
    """
    symbols: List[str] = []
    for m in re.finditer(r"^\s*import\s+(type\s+)?\{([^}]*)\}\s*from\s*'([^']+)'", text, re.M):
        if m.group(1):
            continue
        if m.group(3) != package:
            continue
        for raw in m.group(2).split(","):
            name = raw.strip().split(" as ")[0].strip()
            if re.fullmatch(r"Mzn[A-Za-z0-9]*", name) and not name.endswith("Service"):
                symbols.append(name)
    return sorted(set(symbols))


def parse_tokens(text: str) -> List[str]:
    """`MZN_*` tokens the doc presents as provided by this component.

    Only lines that talk about providing/injecting the token count; a token that
    merely appears in a code sample's import list is not a claim about the
    component's own providers.
    """
    tokens: List[str] = []
    for line in text.splitlines():
        if not re.search(r"MZN_[A-Z0-9_]+", line):
            continue
        if re.search(r"provide|提供|注入|inject|DI", line, re.I):
            tokens += re.findall(r"MZN_[A-Z0-9_]+", line)
    return sorted(set(tokens))


def parse_doc(path: str, framework: str) -> Dict[str, object]:
    with open(path, encoding="utf-8") as handle:
        text = handle.read()
    lines = text.splitlines()
    props, outputs = parse_tables(lines)
    component = os.path.basename(path)[:-3]
    package = (
        f"@mezzanine-ui/ng/{_kebab(component)}" if framework == "ng" else "@mezzanine-ui/react"
    )
    verified = None
    m = re.search(r"Verified\s+([0-9][\w.\-]*)", text)
    if m:
        verified = m.group(1)
    return {
        "props": props,
        "outputs": outputs,
        "standaloneImports": parse_imports(text, package) if framework == "ng" else [],
        "providesTokens": parse_tokens(text) if framework == "ng" else [],
        "verified": verified,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--framework", required=True, choices=("react", "ng"))
    parser.add_argument("--components-dir", required=True)
    parser.add_argument("--component", help="Single component; default is every .md in the folder")
    args = parser.parse_args()

    names = (
        [args.component]
        if args.component
        else sorted(f[:-3] for f in os.listdir(args.components_dir) if f.endswith(".md"))
    )
    out = {}
    for name in names:
        path = os.path.join(args.components_dir, f"{name}.md")
        if os.path.isfile(path):
            out[name] = parse_doc(path, args.framework)
    json.dump(out, sys.stdout, ensure_ascii=False, sort_keys=True)
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main())

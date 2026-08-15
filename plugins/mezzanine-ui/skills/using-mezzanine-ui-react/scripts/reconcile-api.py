#!/usr/bin/env python3
"""Diff what the docs claim (doc-api.py) against what the source says (extract-api.py).

Emits one JSON entry per component that differs, in the shape upgrade-version.sh
folds into the work manifest:

    {"component": "Select",
     "propsAdded": [...], "propsRemoved": [...],
     "typeMismatches":    [{"prop": "size", "doc": "string", "source": "number"}],
     "defaultMismatches": [{"prop": "size", "doc": "'medium'", "source": "'large'"}],
     "outputsAdded": [...], "outputsRemoved": [...],
     "selectorChanged": {...}, "cvaChange": "added"|"removed",
     "tokensAdded": [...], "tokensRemoved": [...],
     "importsAdded": [...], "importsRemoved": [...]}

Comparison rules that matter:

  * A type is only compared when both sides are comparable. `SelectMode` lives in
    @mezzanine-ui/core, so the extractor cannot expand it; a doc that spells out
    `'single' | 'multiple'` is *more* informative, not wrong. Those land in
    `typeUnverifiable`, never in `typeMismatches`.
  * A default the source sets and the doc omits is reported (`defaultMissing`),
    because consumers read the Default column as "no default".
  * Names present in source but absent from the doc are `propsAdded`; the reverse
    is `propsRemoved`. Neither is auto-actioned — RECONCILIATION.md's triage
    buckets apply, and a scanner limitation is recorded as an exception instead.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from typing import Dict, List, Optional, Tuple

# Props every React component inherits from the DOM typings; the docs document
# them per-component only when the component does something special with them.
REACT_DOM_PROPS = {"className", "style", "id", "children", "ref", "key"}


# A doc that abbreviates a type ("partial omit", `'a' | ...`) is documenting the
# shape, not asserting the exact declaration; comparing it literally would push
# the docs toward pasting 20-line Omit<> expressions into a table cell.
ABBREVIATED = ("...", "…", "partial", "省略", "等")


def normalize_type(text: Optional[str]) -> Optional[str]:
    if not text:
        return None
    out = text.strip()
    out = re.sub(r"\bReact\.", "", out)
    out = re.sub(r"\bOutputEmitterRef<(.*)>$", r"\1", out.strip())
    out = re.sub(r"\bEventEmitter<(.*)>$", r"\1", out.strip())
    out = re.sub(r"\bReadonlyArray<(.+)>", r"readonly \1[]", out)
    out = re.sub(r"\bArray<(.+)>", r"\1[]", out)
    out = out.replace('"', "'")
    out = re.sub(r"\s+", " ", out)
    out = re.sub(r"\s*\|\s*", " | ", out)
    out = re.sub(r";\s*\}", " }", out)
    out = re.sub(r",\s*\)", ")", out)
    out = re.sub(r"\{\s*", "{ ", out)
    out = re.sub(r"\s*\}", " }", out)
    out = out.strip().rstrip(";").lstrip("|").strip()
    # `string | undefined` and `string` describe the same optional prop: the doc
    # writes one, the source's `?:` implies the other.
    members = [m for m in (p.strip() for p in re.split(r"(?<![=<>|&])\|(?![|])", out)) if m and m != "undefined"]
    out = " | ".join(sorted(members)) if len(members) > 1 else (members[0] if members else "")
    return out or None


def is_opaque(text: Optional[str]) -> bool:
    """A bare imported identifier the extractor cannot expand."""
    if not text:
        return True
    return bool(re.fullmatch(r"[A-Za-z_$][\w$]*(<[^<>]*>)?(\[\])?", text)) and not text.islower()


def types_conflict(doc: Optional[str], source: Optional[str]) -> bool:
    if doc and any(marker in doc for marker in ABBREVIATED):
        return False
    a, b = normalize_type(doc), normalize_type(source)
    if a is None or b is None:
        return False
    if a == b:
        return False
    # `boolean` documented where the source says `number` is a real error;
    # `SelectMode` vs `'single' | 'multiple'` is an alias the extractor cannot
    # follow across packages.
    if is_opaque(a) != is_opaque(b):
        return False
    if is_opaque(a) and is_opaque(b):
        return a.replace("readonly ", "") != b.replace("readonly ", "")
    return True


def normalize_default(text: Optional[str]) -> Optional[str]:
    if text is None:
        return None
    out = " ".join(str(text).split()).strip().rstrip(";,")
    out = out.replace('"', "'")
    out = re.sub(r"^\(|\)$", "", out).strip()
    if out.lower() in {"", "undefined", "none", "—", "-", "n/a"}:
        return None
    return out


def defaults_conflict(doc: Optional[str], source: Optional[str]) -> bool:
    a, b = normalize_default(doc), normalize_default(source)
    if a is None or b is None:
        return False
    if a == b:
        return False
    # `'medium'` vs `medium`, `[]` vs `() => []`, `0` vs `0px`.
    return a.strip("'") != b.strip("'")


def compare(
    component: str,
    doc: Dict[str, object],
    src: Dict[str, object],
    framework: str,
) -> Optional[Dict[str, object]]:
    doc_props: Dict[str, Dict[str, object]] = doc.get("props", {})  # type: ignore[assignment]
    src_props: Dict[str, Dict[str, object]] = src.get("props", {})  # type: ignore[assignment]

    ignorable = REACT_DOM_PROPS if framework == "react" else set()
    added = sorted(p for p in src_props if p not in doc_props and p not in ignorable)
    removed = sorted(p for p in doc_props if p not in src_props)

    type_mismatches: List[Dict[str, object]] = []
    type_unverifiable: List[str] = []
    default_mismatches: List[Dict[str, object]] = []
    default_missing: List[Dict[str, object]] = []
    required_mismatches: List[Dict[str, object]] = []

    for name, doc_entry in sorted(doc_props.items()):
        src_entry = src_props.get(name)
        if src_entry is None:
            continue
        if types_conflict(doc_entry.get("type"), src_entry.get("type")):
            type_mismatches.append(
                {"prop": name, "doc": doc_entry.get("type"), "source": src_entry.get("type")}
            )
        elif normalize_type(doc_entry.get("type")) != normalize_type(src_entry.get("type")):
            type_unverifiable.append(name)
        if defaults_conflict(doc_entry.get("default"), src_entry.get("default")):
            default_mismatches.append(
                {"prop": name, "doc": doc_entry.get("default"), "source": src_entry.get("default")}
            )
        elif normalize_default(doc_entry.get("default")) is None and normalize_default(src_entry.get("default")) is not None:
            default_missing.append({"prop": name, "source": src_entry.get("default")})
        if bool(doc_entry.get("required")) != bool(src_entry.get("required")) and src_entry.get("required"):
            required_mismatches.append({"prop": name, "doc": bool(doc_entry.get("required")), "source": True})

    entry: Dict[str, object] = {
        "component": component,
        "propsAdded": added,
        "propsRemoved": removed,
        "typeMismatches": type_mismatches,
        "typeUnverifiable": sorted(type_unverifiable),
        "defaultMismatches": default_mismatches,
        "defaultMissing": default_missing,
        "requiredMismatches": required_mismatches,
    }

    if framework == "ng":
        doc_outputs = doc.get("outputs", {}) or {}
        src_outputs = src.get("outputs", {}) or {}
        entry["outputsAdded"] = sorted(o for o in src_outputs if o not in doc_outputs)
        entry["outputsRemoved"] = sorted(o for o in doc_outputs if o not in src_outputs)
        for name, doc_entry in sorted(doc_outputs.items()):
            src_entry = src_outputs.get(name)
            if src_entry and types_conflict(doc_entry.get("type"), src_entry.get("type")):
                type_mismatches.append(
                    {"output": name, "doc": doc_entry.get("type"), "source": src_entry.get("type")}
                )
        doc_tokens = set(doc.get("providesTokens", []) or [])
        src_tokens = set(src.get("providesTokens", []) or [])
        # One-directional on purpose: a token the component *provides* must be
        # documented, but a doc may legitimately name a token consumers provide
        # or inject (every picker doc mentions MZN_CALENDAR_CONFIG, which the
        # picker consumes rather than provides). Flagging those as "removed"
        # would push the docs toward deleting correct guidance.
        entry["tokensAdded"] = sorted(src_tokens - doc_tokens)
        entry["tokensRemoved"] = []
        doc_imports = set(doc.get("standaloneImports", []) or [])
        src_imports = set(src.get("standaloneImports", []) or [])
        entry["importsAdded"] = sorted(src_imports - doc_imports)
        entry["importsRemoved"] = sorted(doc_imports - src_imports)
        entry["cva"] = {"doc": doc.get("cva"), "source": src.get("cva")}

    interesting = any(
        entry.get(key)
        for key in (
            "propsAdded",
            "propsRemoved",
            "typeMismatches",
            "defaultMismatches",
            "defaultMissing",
            "requiredMismatches",
            "outputsAdded",
            "outputsRemoved",
            "tokensAdded",
            "tokensRemoved",
            "importsAdded",
            "importsRemoved",
        )
    )
    return entry if interesting else None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--framework", required=True, choices=("react", "ng"))
    parser.add_argument("--docs", required=True, help="doc-api.py output")
    parser.add_argument("--source", required=True, help="extract-api.py --batch output")
    parser.add_argument("--summary", action="store_true", help="human-readable summary on stderr")
    args = parser.parse_args()

    with open(args.docs, encoding="utf-8") as handle:
        docs = json.load(handle)
    with open(args.source, encoding="utf-8") as handle:
        sources = json.load(handle)

    entries = []
    for component in sorted(docs):
        src = sources.get(component)
        if src is None:
            continue
        result = compare(component, docs[component], src, args.framework)
        if result:
            entries.append(result)

    json.dump(entries, sys.stdout, ensure_ascii=False)
    print()

    if args.summary:
        for entry in entries:
            bits = []
            for key, label in (
                ("propsAdded", "+prop"),
                ("propsRemoved", "-prop"),
                ("typeMismatches", "type"),
                ("defaultMismatches", "default"),
                ("defaultMissing", "default-missing"),
                ("requiredMismatches", "required"),
                ("outputsAdded", "+output"),
                ("outputsRemoved", "-output"),
                ("tokensAdded", "+token"),
                ("tokensRemoved", "-token"),
                ("importsAdded", "+import"),
                ("importsRemoved", "-import"),
            ):
                value = entry.get(key) or []
                if value:
                    bits.append(f"{label}:{len(value)}")
            print(f"{entry['component']:24s} {' '.join(bits)}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())

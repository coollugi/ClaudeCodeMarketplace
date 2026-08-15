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


def is_untyped_shape(text: Optional[str]) -> bool:
    """A doc type that names members or parameters without typing them.

    `(cleanedOptions) => void` and `OutputEmitterRef<{ text, currentOptions }>`
    document the shape, not the signature; comparing them against the full
    declaration only pushes noise into the report.
    """
    if not text:
        return False
    params = re.search(r"\(([^()]*)\)\s*=>", text)
    if params and params.group(1).strip() and ":" not in params.group(1):
        return True
    body = re.search(r"\{([^{}]*)\}", text)
    return bool(body and body.group(1).strip() and ":" not in body.group(1))


# `export type RadioSize = InputCheckSize;` — populated from --aliases.
ALIASES: Dict[str, str] = {}


def _canonical(name: str, depth: int = 0) -> str:
    while depth < 8 and name in ALIASES:
        name = ALIASES[name]
        depth += 1
    return name


def normalize_type(text: Optional[str]) -> Optional[str]:
    if not text:
        return None
    out = text.strip()
    if ALIASES:
        out = re.sub(r"\b[A-Za-z_$][\w$]*\b", lambda m: _canonical(m.group(0)), out)
    out = re.sub(r"\bReact\.", "", out)
    out = re.sub(r"\bOutputEmitterRef<(.*)>$", r"\1", out.strip())
    # Docs sometimes print the declaration instead of the emitted type.
    out = re.sub(r"^(?:output|input(?:\.required)?)\s*<(.*)>\s*\(\s*\)$", r"\1", out.strip())
    out = re.sub(r"\bEventEmitter<(.*)>$", r"\1", out.strip())
    out = re.sub(r"\bReadonlyArray<(.+)>", r"readonly \1[]", out)
    out = re.sub(r"\bArray<(.+)>", r"\1[]", out)
    out = out.replace('"', "'")
    out = re.sub(r"\s+", " ", out)
    out = re.sub(r"\s*\|\s*", " | ", out)
    out = re.sub(r";\s*\}", " }", out)
    out = re.sub(r",\s*\)", ")", out)
    out = re.sub(r"\(\s+", "(", out)
    out = re.sub(r"\s+\)", ")", out)
    out = re.sub(r"<\s+", "<", out)
    out = re.sub(r"\s+>", ">", out)
    out = re.sub(r"<\s*\|\s*", "<", out)
    out = re.sub(r",\s*\|\s*", ", ", out)
    out = re.sub(r"\(\s*\|\s*", "(", out)
    out = re.sub(r"<any>", "", out)
    out = _expand_template_union(out)
    # Parameter NAMES are prose, not type identity: `(date: DateType) => boolean`
    # and `(firstDateOfWeek: DateType) => boolean` are the same type.
    if "=>" in out:
        out = re.sub(r"([(,]\s*)[A-Za-z_$][\w$]*\??\s*:\s*", r"\1", out)
    out = _strip_outer_parens(out)
    # Object types: `{ a: string, b: number }` and `{ a: string; b: number }`.
    if out.startswith("{"):
        out = re.sub(r",\s*", "; ", out)
    # `readonly T[]` vs `T[]` is a distinction the tables do not draw.
    out = re.sub(r"\breadonly\s+", "", out)
    out = re.sub(r"\{\s*", "{ ", out)
    out = re.sub(r"\s*\}", " }", out)
    out = out.strip().rstrip(";").lstrip("|").strip()
    # `string | undefined` and `string` describe the same optional prop: the doc
    # writes one, the source's `?:` implies the other.
    members: List[str] = []
    for member in (p.strip() for p in re.split(r"(?<![=<>|&])\|(?![|])", out)):
        member = _strip_outer_parens(member)
        # Merging discriminated-union arms produces the same member twice once
        # `React.` prefixes and whitespace are normalised away.
        if member and member != "undefined" and member not in members:
            members.append(member)
    if set(members) == {"true", "false"}:
        members = ["boolean"]
    out = " | ".join(sorted(members)) if len(members) > 1 else (members[0] if members else "")
    return out or None


def _expand_template_union(text: str) -> str:
    """`` `aria-${'a' | 'b'}` `` -> `'aria-a' | 'aria-b'`.

    Docs spell the members out; the source writes the template literal. Same type.
    """

    def expand(match: re.Match) -> str:
        prefix, body = match.group(1), match.group(2)
        members = [m.strip().strip("'\"") for m in body.split("|")]
        return " | ".join(f"'{prefix}{m}'" for m in members if m)

    return re.sub(r"`([^`$]*)\$\{([^{}`]*)\}`", expand, text)


def _strip_outer_parens(text: str) -> str:
    """`((d: DateType) => boolean)` -> `(d: DateType) => boolean`.

    Dropping `| undefined` from an optional callback leaves the wrapping parens
    the source needed to write the union; the docs never write them.
    """
    out = text.strip()
    while out.startswith("(") and out.endswith(")"):
        depth = 0
        balanced = True
        for i, ch in enumerate(out):
            depth += ch == "("
            depth -= ch == ")"
            if depth == 0 and i < len(out) - 1:
                balanced = False
                break
        if not balanced:
            break
        out = out[1:-1].strip()
    return out


def is_opaque(text: Optional[str]) -> bool:
    """A bare imported identifier the extractor cannot expand."""
    if not text:
        return True
    if re.fullmatch(r"[A-Z]{1,3}[0-9]?", text):
        # A generic type parameter (`T`, `VC`) — says nothing either way.
        return True
    return bool(re.fullmatch(r"[A-Za-z_$][\w$]*(<[^<>]*>)?(\[\])?", text)) and not text.islower()


def types_conflict(doc: Optional[str], source: Optional[str]) -> bool:
    if doc and any(marker in doc for marker in ABBREVIATED):
        return False
    if is_untyped_shape(doc):
        return False
    # Indexed access (`FormattedInputProps['errorMessages']`) points AT the source
    # declaration instead of copying it — the most accurate thing a table can do
    # for a type this long, and not expandable here.
    if (doc and "['" in doc) or (source and "['" in source):
        return False
    # A generic parameter on either side leaves nothing to compare.
    if re.fullmatch(r"[A-Z]{1,3}[0-9]?", (doc or "").strip()) or re.fullmatch(r"[A-Z]{1,3}[0-9]?", (source or "").strip()):
        return False
    a, b = normalize_type(doc), normalize_type(source)
    if a is None or b is None:
        return False
    if a == b:
        return False
    # `never` is how a discriminated union says "not applicable in this variant".
    # The extractor merges the arms, so the merged type can never show it.
    if a == "never" or b == "never":
        return False
    # The docs table one variant per row; the extractor merges every arm into one
    # union. A doc type that is a subset of the source union is documenting an arm.
    # Subset in either direction is an arm, not a defect: the table documents one
    # variant per row, and the extractor merges every arm into one union — so
    # either side can legitimately be the narrower one.
    doc_members = {m.strip() for m in a.split("|")}
    src_members = {m.strip() for m in b.split("|")}
    if doc_members and src_members and (doc_members < src_members or src_members < doc_members):
        return False
    # `boolean` against a single literal arm (`true`) is the same case.
    if {"boolean"} in (doc_members, src_members) and (doc_members | src_members) <= {"boolean", "true", "false"}:
        return False
    # `boolean` documented where the source says `number` is a real error;
    # `SelectMode` vs `'single' | 'multiple'` is an alias the extractor cannot
    # follow across packages.
    if is_opaque(a) != is_opaque(b):
        return False
    # An alias against its expansion, once `| null` is set aside: `ArrowConfig | null`
    # vs `{ enabled: boolean; ... } | null`.
    doc_core = [m for m in a.split("|") if m.strip() not in ("null", "undefined")]
    src_core = [m for m in b.split("|") if m.strip() not in ("null", "undefined")]
    if len(doc_core) == 1 and len(src_core) == 1 and is_opaque(doc_core[0].strip()) != is_opaque(src_core[0].strip()):
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


LITERAL_DEFAULT = re.compile(r"""^('[^']*'|"[^"]*"|-?\d+(\.\d+)?|true|false|\[\]|\{\})$""")


def defaults_conflict(doc: Optional[str], source: Optional[str]) -> bool:
    a, b = normalize_default(doc), normalize_default(source)
    if a is None or b is None:
        return False
    if a == b:
        return False
    # Only literal-vs-literal is a defect. A source default that is a ternary, a
    # call or an enum member (`hideSecond ? 'HH:mm' : defaultTimeFormat`,
    # `FormFieldLayout.HORIZONTAL`) and a doc cell that explains the rule in prose
    # ("From CalendarContext", "Auto-detect") describe the same behaviour at
    # different altitudes; reporting them pushes prose into the table.
    if not LITERAL_DEFAULT.match(a) or not LITERAL_DEFAULT.match(b):
        return False
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
        type_alternatives = [normalize_type(c) for c in (src_entry.get("typeCandidates") or [])]
        if type_alternatives and normalize_type(doc_entry.get("type")) in type_alternatives:
            pass
        elif types_conflict(doc_entry.get("type"), src_entry.get("type")):
            type_mismatches.append(
                {"prop": name, "doc": doc_entry.get("type"), "source": src_entry.get("type")}
            )
        elif normalize_type(doc_entry.get("type")) != normalize_type(src_entry.get("type")):
            type_unverifiable.append(name)
        # A family that declares the same name on two components has no single
        # "the" default; if the doc matches any of them it is documenting one of
        # them correctly, and only a per-directive comparison can say more.
        alternatives = [normalize_default(c) for c in (src_entry.get("defaultCandidates") or [])]
        doc_default = normalize_default(doc_entry.get("default"))
        if alternatives and doc_default in alternatives:
            pass
        elif src_entry.get("defaultFrom") == "jsdoc":
            # An inherited `@default` tag is not evidence about this component.
            pass
        elif defaults_conflict(doc_entry.get("default"), src_entry.get("default")):
            default_mismatches.append(
                {"prop": name, "doc": doc_entry.get("default"), "source": src_entry.get("default")}
            )
        elif doc_default is None and normalize_default(src_entry.get("default")) is not None and not alternatives:
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
        exported = set(src.get("exportedSymbols", []) or []) or src_imports
        entry["importsAdded"] = sorted(src_imports - doc_imports)
        # Only a symbol the package does not export at all is a defect; a service
        # or state class the doc tells you to inject is exported but undecorated.
        entry["importsRemoved"] = sorted(doc_imports - exported)
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
    parser.add_argument("--aliases", help="extract-api.py --alias-out map, used to canonicalise type names")
    parser.add_argument("--summary", action="store_true", help="human-readable summary on stderr")
    args = parser.parse_args()

    if args.aliases:
        try:
            with open(args.aliases, encoding="utf-8") as handle:
                ALIASES.update(json.load(handle))
        except (OSError, ValueError):
            pass

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

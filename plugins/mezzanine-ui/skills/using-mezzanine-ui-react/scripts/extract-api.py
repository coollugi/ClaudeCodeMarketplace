#!/usr/bin/env python3
"""Extract a component's public API (names, types, defaults) from its source files.

Called by upgrade-version.sh once per component, with a directory holding the
whole component *family* (React: packages/react/src/<Comp>/; Angular:
packages/ng/<folder>/). Emits one JSON object on stdout.

Why a separate extractor: the shell script used to compare prop NAMES only, so a
prop documented as `string` that is really `number` passed silently. Types and
defaults need the declaration text, not a grep, and the awk that produced names
had already caused wrong doc edits several times (see RECONCILIATION.md).

Output shape:

    {
      "props":   {"<name>": {"type": str|null, "default": str|null, "required": bool}},
      "outputs": {"<name>": {"type": str|null}},          # ng only
      "selector": str|null, "selectors": [str],           # ng only
      "cva": bool,
      "providesTokens": [str],                            # ng only
      "standaloneImports": [str],                         # ng only
      "unresolvedBases": [str]                            # types we could not follow
    }

Nothing here reaches across packages: `SelectMode` lives in @mezzanine-ui/core
and stays an opaque identifier. Callers must treat an unresolved identifier as
"unknown", never as "empty" — see compare_types() in reconcile-api.py.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from typing import Dict, List, Optional, Tuple

SKIP_SUFFIXES = (".spec.ts", ".spec.tsx", ".stories.ts", ".stories.tsx", ".mdx", ".test.ts", ".test.tsx")


# ── shared lexing helpers ─────────────────────────────────────────────────────


def strip_comments(text: str) -> str:
    """Remove // and /* */ comments, preserving string literals and line count."""
    out: List[str] = []
    i, n = 0, len(text)
    while i < n:
        ch = text[i]
        if ch in "'\"`":
            quote = ch
            out.append(ch)
            i += 1
            while i < n:
                out.append(text[i])
                if text[i] == "\\":
                    if i + 1 < n:
                        out.append(text[i + 1])
                        i += 2
                        continue
                elif text[i] == quote:
                    i += 1
                    break
                i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "*":
            j = text.find("*/", i + 2)
            block = text[i : (j + 2 if j != -1 else n)]
            out.append("\n" * block.count("\n"))
            i = j + 2 if j != -1 else n
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def match_block(text: str, open_idx: int, opener: str = "{", closer: str = "}") -> int:
    """Index just past the bracket that closes the one at open_idx (or len(text))."""
    depth = 0
    i, n = open_idx, len(text)
    while i < n:
        ch = text[i]
        if ch in "'\"`":
            quote = ch
            i += 1
            while i < n and text[i] != quote:
                i += 2 if text[i] == "\\" else 1
            i += 1
            continue
        if ch == opener:
            depth += 1
        elif ch == closer:
            # `input<((d: DateType) => boolean) | undefined>()`: the `>` of the
            # arrow is not the end of the generic. Closing on it truncated every
            # callback-typed input to `((d: DateType) =`.
            if closer == ">" and i > 0 and text[i - 1] == "=":
                i += 1
                continue
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return n


def split_top_level(text: str, seps: str) -> List[str]:
    """Split on separator chars that sit outside (), [], {}, <> and strings."""
    parts, buf = [], []
    depth_round = depth_square = depth_curly = depth_angle = 0
    i, n = 0, len(text)
    while i < n:
        ch = text[i]
        if ch in "'\"`":
            quote = ch
            buf.append(ch)
            i += 1
            while i < n:
                buf.append(text[i])
                if text[i] == quote:
                    i += 1
                    break
                i += 1
            continue
        if ch == "(":
            depth_round += 1
        elif ch == ")":
            depth_round -= 1
        elif ch == "[":
            depth_square += 1
        elif ch == "]":
            depth_square -= 1
        elif ch == "{":
            depth_curly += 1
        elif ch == "}":
            depth_curly -= 1
        elif ch == "<":
            depth_angle += 1
        elif ch == ">":
            # `=>` is not a closing angle bracket.
            if not buf or buf[-1] != "=":
                depth_angle = max(0, depth_angle - 1)
        if (
            ch in seps
            and depth_round == 0
            and depth_square == 0
            and depth_curly == 0
            and depth_angle == 0
        ):
            parts.append("".join(buf))
            buf = []
            i += 1
            continue
        buf.append(ch)
        i += 1
    parts.append("".join(buf))
    return [p.strip() for p in parts if p.strip()]


def read_sources(directory: str, recursive: bool = False) -> Dict[str, str]:
    """All non-test TypeScript sources in a component family folder."""
    sources: Dict[str, str] = {}
    if recursive:
        for base, _dirs, files in os.walk(directory):
            for name in sorted(files):
                if not (name.endswith(".ts") or name.endswith(".tsx")) or name.endswith(SKIP_SUFFIXES):
                    continue
                path = os.path.join(base, name)
                try:
                    with open(path, encoding="utf-8") as handle:
                        sources[os.path.relpath(path, directory)] = handle.read()
                except (OSError, UnicodeDecodeError):
                    continue
        return sources
    for name in sorted(os.listdir(directory)):
        path = os.path.join(directory, name)
        if not os.path.isfile(path):
            continue
        if not (name.endswith(".ts") or name.endswith(".tsx")):
            continue
        if name.endswith(SKIP_SUFFIXES):
            continue
        try:
            with open(path, encoding="utf-8") as handle:
                sources[name] = handle.read()
        except (OSError, UnicodeDecodeError):
            continue
    return sources


# ── React ─────────────────────────────────────────────────────────────────────

MEMBER_RE = re.compile(
    r"^\s*(?:readonly\s+)?(?P<name>[A-Za-z_$][\w$]*)(?P<opt>\?)?\s*(?P<sep>[:(])"
)


def _jsdoc_default(doc: str) -> Optional[str]:
    m = re.search(r"@default(?:Value)?\s+(?:`)?([^\n`*]+)", doc)
    return m.group(1).strip().rstrip(".") if m else None


def parse_object_members(body: str, raw_body: str) -> Dict[str, Dict[str, object]]:
    """Parse `{ name?: Type; ... }` at depth 1. `raw_body` keeps JSDoc for @default."""
    members: Dict[str, Dict[str, object]] = {}
    # Map member name -> preceding JSDoc block, taken from the uncommented text.
    docs: Dict[str, str] = {}
    for m in re.finditer(r"/\*\*(?P<doc>.*?)\*/\s*(?:readonly\s+)?(?P<name>[A-Za-z_$][\w$]*)\??\s*[:(]", raw_body, re.S):
        docs.setdefault(m.group("name"), m.group("doc"))

    i, n = 0, len(body)
    while i < n:
        ch = body[i]
        if ch in "{([":
            i = match_block(body, i, ch, {"{": "}", "(": ")", "[": "]"}[ch])
            continue
        if ch in "'\"`":
            quote = ch
            i += 1
            while i < n and body[i] != quote:
                i += 2 if body[i] == "\\" else 1
            i += 1
            continue
        # Candidate member start: beginning of a line-ish position.
        if ch in ";\n" or i == 0:
            start = i + 1 if ch in ";\n" else 0
            rest = body[start:]
            m = MEMBER_RE.match(rest)
            if m:
                name = m.group("name")
                optional = m.group("opt") == "?"
                after = start + m.end()
                if m.group("sep") == "(":
                    # method shorthand `onChange?(e): void;`
                    close = match_block(body, after - 1, "(", ")")
                    tail = body[close:]
                    tm = re.match(r"\s*:\s*", tail)
                    type_text = ""
                    if tm:
                        seg = tail[tm.end() :]
                        end = _member_end(seg)
                        type_text = "(" + body[after : close - 1].strip() + ") => " + seg[:end].strip()
                    members[name] = {
                        "type": _clean_type(type_text),
                        "required": not optional,
                        "default": _jsdoc_default(docs.get(name, "")),
                    }
                    i = close
                    continue
                seg = body[after:]
                end = _member_end(seg)
                members[name] = {
                    "type": _clean_type(seg[:end]),
                    "required": not optional,
                    "default": _jsdoc_default(docs.get(name, "")),
                }
                i = after + end
                continue
        i += 1
    return members



def _continues(before: str, after: str) -> bool:
    """Does a type declaration continue across this newline?"""
    head = before.rstrip()
    if head.endswith(("|", "&", ",", "<", "=", "extends", "(")):
        return True
    tail = after.lstrip()
    return bool(tail) and tail[0] in "|&>"


def _member_end(seg: str) -> int:
    """Length of a member's type text: up to the `;`/newline outside brackets."""
    depth_round = depth_square = depth_curly = depth_angle = 0
    i, n = 0, len(seg)
    while i < n:
        ch = seg[i]
        if ch in "'\"`":
            quote = ch
            i += 1
            while i < n and seg[i] != quote:
                i += 2 if seg[i] == "\\" else 1
            i += 1
            continue
        if ch in "([{":
            depth_round += ch == "("
            depth_square += ch == "["
            depth_curly += ch == "{"
        elif ch in ")]}":
            depth_round -= ch == ")"
            depth_square -= ch == "]"
            depth_curly -= ch == "}"
            if depth_curly < 0:
                return i
        elif ch == "<":
            depth_angle += 1
        elif ch == ">" and (i == 0 or seg[i - 1] != "="):
            depth_angle = max(0, depth_angle - 1)
        flat = depth_round == depth_square == depth_curly == depth_angle == 0
        if flat and ch == ";":
            return i
        if flat and ch == "\n":
            # A wrapped type continues when either side of the break is an
            # operator: `foo:\n  | A\n  | B` and `Omit<A, 'b'> &\n  C` both wrap.
            # Testing only the next line ended `type BadgeProps = Omit<...> &`
            # at the `&`, dropping every member of the intersection's second arm.
            if _continues(seg[:i], seg[i + 1 :]):
                i += 1
                continue
            return i
        i += 1
    return n


def _clean_type(text: str) -> Optional[str]:
    cleaned = " ".join(text.replace("\n", " ").split()).strip().rstrip(",;")
    return cleaned or None


class TypeIndex:
    """Every `interface`/`type` declaration in a component family, by name."""

    def __init__(self, sources: Dict[str, str], fallback: "Optional[TypeIndex]" = None) -> None:
        self.fallback = fallback
        self.interfaces: Dict[str, Tuple[str, str, str]] = {}  # name -> (heritage, body, raw body)
        self.aliases: Dict[str, str] = {}
        for text in sources.values():
            stripped = strip_comments(text)
            for m in re.finditer(r"\b(?:export\s+)?interface\s+([A-Za-z_$][\w$]*)", stripped):
                name = m.group(1)
                brace = stripped.find("{", m.end())
                if brace == -1:
                    continue
                heritage = stripped[m.end() : brace]
                end = match_block(stripped, brace)
                body = stripped[brace + 1 : end - 1]
                raw = _raw_slice(text, stripped, brace + 1, end - 1)
                self.interfaces.setdefault(name, (heritage, body, raw))
            for m in re.finditer(r"\b(?:export\s+)?type\s+([A-Za-z_$][\w$]*)", stripped):
                name = m.group(1)
                pos = m.end()
                # Type parameters are skipped by bracket matching, not by regex:
                # `type TableProps<T extends TableDataSource = TableDataSource> =`
                # carries an `=` inside the parameter list, so a `<[^=]*?>` pattern
                # never reached the assignment and Table extracted zero props.
                while pos < len(stripped) and stripped[pos].isspace():
                    pos += 1
                if pos < len(stripped) and stripped[pos] == "<":
                    pos = match_block(stripped, pos, "<", ">")
                    while pos < len(stripped) and stripped[pos].isspace():
                        pos += 1
                if pos >= len(stripped) or stripped[pos] != "=":
                    continue
                # Skip the whitespace after `=`, including a line break: an RHS
                # that starts on the next line otherwise measured as empty.
                seg = stripped[pos + 1 :].lstrip()
                end = _alias_end(seg)
                self.aliases.setdefault(name, seg[:end].strip())
        self.raw_sources = sources

    def resolve(self, name: str, seen: Optional[set] = None) -> Tuple[Dict[str, Dict[str, object]], List[str]]:
        seen = seen or set()
        if name in seen:
            return {}, []
        seen.add(name)
        if name in self.interfaces:
            heritage, body, raw = self.interfaces[name]
            members = parse_object_members(body, raw)
            unresolved: List[str] = []
            ext = re.search(r"\bextends\b(.*)$", heritage, re.S)
            if ext:
                for base in split_top_level(ext.group(1), ","):
                    inherited, missed = self.resolve_type_expr(base, seen)
                    unresolved += missed
                    for key, value in inherited.items():
                        members.setdefault(key, value)
            return members, unresolved
        if name in self.aliases:
            return self.resolve_type_expr(self.aliases[name], seen)
        # Cross-folder bases (`SelectProps extends TextFieldProps`) only resolve
        # when the caller supplied --root; over HTTP the identifier stays
        # unresolved and is reported, never silently treated as "no props".
        if self.fallback is not None:
            # `seen` already contains this name (added on entry to guard against
            # self-recursion); handing it to the fallback unchanged made every
            # cross-folder base resolve to zero members, silently.
            return self.fallback.resolve(name, seen - {name})
        return {}, [name]

    def resolve_type_expr(self, expr: str, seen: Optional[set] = None) -> Tuple[Dict[str, Dict[str, object]], List[str]]:
        """Union/intersection of object types → merged member map."""
        seen = seen or set()
        expr = expr.strip()
        members: Dict[str, Dict[str, object]] = {}
        unresolved: List[str] = []
        operands = split_top_level(expr, "&|")
        for operand in operands:
            operand = operand.strip().strip("()").strip()
            if not operand:
                continue
            if operand.startswith("{"):
                end = match_block(operand, 0)
                part = parse_object_members(operand[1 : end - 1], operand[1 : end - 1])
            else:
                util = re.match(r"^(Omit|Pick|Partial|Required|Readonly)\s*<(.*)>$", operand, re.S)
                if util:
                    args = split_top_level(util.group(2), ",")
                    inner, missed = self.resolve_type_expr(args[0], seen) if args else ({}, [])
                    unresolved += missed
                    keys = set()
                    if len(args) > 1:
                        keys = {k.strip().strip("'\"") for k in split_top_level(args[1], "|")}
                    if util.group(1) == "Omit":
                        part = {k: v for k, v in inner.items() if k not in keys}
                    elif util.group(1) == "Pick":
                        part = {k: v for k, v in inner.items() if k in keys}
                    else:
                        part = inner
                else:
                    ident = re.match(r"^([A-Za-z_$][\w$]*)", operand)
                    if not ident:
                        continue
                    part, missed = self.resolve(ident.group(1), seen)
                    unresolved += missed
            for key, value in part.items():
                existing = members.get(key)
                if existing is None:
                    members[key] = dict(value)
                    continue
                # Discriminated unions declare inapplicable keys as `never`
                # (Badge: `count?: never` in the dot arm). Prefer the real type,
                # and treat a key that is optional in any arm as optional.
                a, b = existing.get("type"), value.get("type")
                if a in (None, "never") and b not in (None, "never"):
                    existing["type"] = b
                elif b not in (None, "never") and a != b:
                    # Discriminated unions repeat the discriminant with a
                    # different literal in each arm (`type: 'action'`,
                    # `type: 'default'`, ...). Keeping only the first made the
                    # extractor claim Card.type was `'action'`.
                    parts = [p.strip() for p in str(a).split("|")] + [p.strip() for p in str(b).split("|")]
                    seen_parts: List[str] = []
                    for part in parts:
                        if part and part != "never" and part not in seen_parts:
                            seen_parts.append(part)
                    existing["type"] = " | ".join(seen_parts)
                if existing.get("default") is None and value.get("default") is not None:
                    existing["default"] = value.get("default")
                if not value.get("required"):
                    existing["required"] = False
        return members, unresolved


def _raw_slice(raw: str, stripped: str, start: int, end: int) -> str:
    """Best-effort mapping of a stripped-text span back to the raw text.

    strip_comments keeps every newline, so line numbers line up; that is enough
    to recover the JSDoc blocks that carry `@default`.
    """
    first_line = stripped.count("\n", 0, start)
    last_line = stripped.count("\n", 0, end)
    lines = raw.split("\n")
    return "\n".join(lines[max(0, first_line - 1) : last_line + 1])


def _alias_end(seg: str) -> int:
    depth_round = depth_square = depth_curly = depth_angle = 0
    i, n = 0, len(seg)
    while i < n:
        ch = seg[i]
        if ch in "'\"`":
            quote = ch
            i += 1
            while i < n and seg[i] != quote:
                i += 2 if seg[i] == "\\" else 1
            i += 1
            continue
        if ch in "([{":
            depth_round += ch == "("
            depth_square += ch == "["
            depth_curly += ch == "{"
        elif ch in ")]}":
            depth_round -= ch == ")"
            depth_square -= ch == "]"
            depth_curly -= ch == "}"
        elif ch == "<":
            depth_angle += 1
        elif ch == ">" and (i == 0 or seg[i - 1] != "="):
            depth_angle = max(0, depth_angle - 1)
        flat = depth_round == depth_square == depth_curly == depth_angle == 0
        if flat and ch == ";":
            return i
        if flat and ch == "\n":
            if _continues(seg[:i], seg[i + 1 :]):
                i += 1
                continue
            return i
        i += 1
    return n


def react_defaults(sources: Dict[str, str], component: str) -> Dict[str, str]:
    """Destructuring defaults in the component body: `const { size = 'medium' } = props`."""
    defaults: Dict[str, str] = {}
    for name, text in sources.items():
        stripped = strip_comments(text)
        for m in re.finditer(r"(?:const|let|var)?\s*\{", stripped):
            open_idx = m.end() - 1
            end = match_block(stripped, open_idx)
            tail = stripped[end : end + 40]
            if not re.match(r"\s*(?:=\s*props|\}?\s*[:=,)])", tail) and "=" not in tail[:4]:
                continue
            body = stripped[open_idx + 1 : end - 1]
            for part in split_top_level(body, ","):
                dm = re.match(r"^([A-Za-z_$][\w$]*)\s*=\s*(.+)$", part.strip(), re.S)
                if dm:
                    defaults.setdefault(dm.group(1), " ".join(dm.group(2).split()))
    return defaults


def extract_react(directory: str, component: str, fallback: "Optional[TypeIndex]" = None) -> Dict[str, object]:
    sources = read_sources(directory)
    index = TypeIndex(sources, fallback=fallback)
    props: Dict[str, Dict[str, object]] = {}
    unresolved: List[str] = []
    # `<Comp>Props`, plus conventional siblings (`<Comp>PropsBase`, ...) that the
    # main interface extends by convention.
    # Every `*Props` declared in the family folder, not just `<Comp>Props`.
    # React docs cover the family the way Angular docs do — Card.md documents
    # CardHeaderProps/CardActionsProps, Picker.md nine sub-component prop types —
    # and scanning only `<Comp>Props` reported all of those as removed (-77 on
    # Picker, -46 on NotificationCenter) purely because the extractor never
    # looked at the sibling declarations.
    names = [
        n
        for n in list(index.interfaces) + list(index.aliases)
        if re.search(r"Props(Base|Common|Shared|WithChildren)?$", n)
    ]
    for name in sorted(names, key=lambda n: (n != f"{component}Props", n)):
        members, missed = index.resolve(name)
        unresolved += missed
        for key, value in members.items():
            existing = props.get(key)
            if existing is None:
                props[key] = value
            elif existing.get("type") in (None, "never") and value.get("type") not in (None, "never"):
                props[key] = value
    defaults = react_defaults(sources, component)
    for key, value in props.items():
        if value.get("default") is None and key in defaults:
            value["default"] = defaults[key]
    return {
        "props": props,
        "outputs": {},
        "selector": None,
        "selectors": [],
        "cva": False,
        "providesTokens": [],
        "standaloneImports": [],
        "unresolvedBases": sorted(set(unresolved)),
    }


# ── Angular ───────────────────────────────────────────────────────────────────

SIGNAL_INPUT_RE = re.compile(
    r"^[ \t]*(?:public\s+|protected\s+|private\s+)?(?:readonly\s+)?"
    r"(?P<name>[A-Za-z_$][\w$]*)\s*(?::[^=]*?)?=\s*input(?P<required>\.required)?\s*(?P<generic><)?",
    re.M,
)
OUTPUT_RE = re.compile(
    r"^[ \t]*(?:public\s+|protected\s+|private\s+)?(?:readonly\s+)?"
    r"(?P<name>[A-Za-z_$][\w$]*)\s*(?::[^=]*?)?=\s*output\s*(?P<generic><)?",
    re.M,
)
MODEL_RE = re.compile(
    r"^[ \t]*(?:public\s+|protected\s+|private\s+)?(?:readonly\s+)?"
    r"(?P<name>[A-Za-z_$][\w$]*)\s*(?::[^=]*?)?=\s*model(?P<required>\.required)?\s*(?P<generic><)?",
    re.M,
)


def _generic_arg(text: str, angle_idx: int) -> Tuple[Optional[str], int]:
    end = match_block(text, angle_idx, "<", ">")
    return _clean_type(text[angle_idx + 1 : end - 1]), end


def extract_ng(directory: str, component: str) -> Dict[str, object]:
    sources = read_sources(directory)
    props: Dict[str, Dict[str, object]] = {}
    outputs: Dict[str, Dict[str, object]] = {}
    selectors: List[str] = []
    main_selector: Optional[str] = None
    cva = False
    tokens: List[str] = []
    imports: List[str] = []

    folder_base = os.path.basename(directory.rstrip("/"))
    # Classes carrying @Component/@Directive anywhere in the family, and the
    # names index.ts re-exports. The intersection is what a consumer can put in
    # `imports: []` — the contract the doc's Import block promises.
    decorated: set = set()
    exported: set = set()
    for filename in sorted(sources):
        text = strip_comments(sources[filename])

        for m in re.finditer(r"selector:\s*['\"]([^'\"]+)['\"]", text):
            selectors.append(m.group(1))
            if filename in (f"{folder_base}.component.ts", f"{folder_base}.directive.ts") and main_selector is None:
                main_selector = m.group(1)

        if re.search(r"implements[^{]*ControlValueAccessor|provideValueAccessor\s*\(", text):
            cva = True
        tokens += re.findall(r"provide:\s*(MZN_[A-Z0-9_]+)", text)

        for m in re.finditer(r"imports:\s*\[", text):
            end = match_block(text, m.end() - 1, "[", "]")
            imports += re.findall(r"\b([A-Z][A-Za-z0-9_]*)\b", text[m.end() : end - 1])

        for regex, bucket, is_output in ((SIGNAL_INPUT_RE, props, False), (MODEL_RE, props, False), (OUTPUT_RE, outputs, True)):
            for m in regex.finditer(text):
                name = m.group("name")
                pos = m.end()
                type_text: Optional[str] = None
                if m.group("generic"):
                    type_text, pos = _generic_arg(text, m.end() - 1)
                    paren = text.find("(", pos)
                else:
                    paren = text.find("(", m.end() - 1)
                if paren == -1:
                    continue
                call_end = match_block(text, paren, "(", ")")
                args = split_top_level(text[paren + 1 : call_end - 1], ",")
                required = bool(m.groupdict().get("required"))
                alias = None
                default = None
                if args:
                    options = args[-1]
                    am = re.search(r"alias:\s*['\"]([^'\"]+)['\"]", options)
                    if am:
                        alias = am.group(1)
                    if not required and not args[0].lstrip().startswith("{"):
                        default = " ".join(args[0].split())
                key = alias or name
                if is_output:
                    outputs[key] = {"type": type_text}
                else:
                    if type_text is None and default is not None:
                        type_text = _infer_type(default)
                    entry = {"type": type_text, "required": required, "default": default}
                    prev = props.get(key)
                    if prev is None or (prev.get("type") is None and entry["type"] is not None):
                        props[key] = entry

        for m in re.finditer(r"@Input\((?P<opts>[^)]*)\)\s*(?:readonly\s+)?(?P<name>[A-Za-z_$][\w$]*)\s*(?::\s*(?P<type>[^=;\n]+))?(?:=\s*(?P<default>[^;\n]+))?", text):
            alias = re.search(r"['\"]([^'\"]+)['\"]", m.group("opts") or "")
            key = alias.group(1) if alias else m.group("name")
            props.setdefault(
                key,
                {
                    "type": _clean_type(m.group("type") or ""),
                    "required": False,
                    "default": _clean_type(m.group("default") or ""),
                },
            )
        for m in re.finditer(r"@Output\([^)]*\)\s*(?:readonly\s+)?(?P<name>[A-Za-z_$][\w$]*)\s*=\s*new\s+EventEmitter\s*(?P<generic><)?", text):
            type_text = None
            if m.group("generic"):
                type_text, _ = _generic_arg(text, m.end() - 1)
            outputs.setdefault(m.group("name"), {"type": type_text})

    for filename, raw in sources.items():
        text = strip_comments(raw)
        for m in re.finditer(r"@(?:Component|Directive)\s*\(", text):
            end = match_block(text, m.end() - 1, "(", ")")
            cm = re.search(r"\bexport\s+class\s+([A-Za-z_$][\w$]*)", text[end : end + 400])
            if cm:
                decorated.add(cm.group(1))
        if filename == "index.ts":
            for m in re.finditer(r"\bexport\s+(type\s+)?\{([^}]*)\}", text, re.S):
                if m.group(1):
                    continue
                for raw_name in m.group(2).split(","):
                    name = raw_name.strip().split(" as ")[-1].strip()
                    if name:
                        exported.add(name)
            if re.search(r"\bexport\s+\*", text):
                exported |= decorated

    if main_selector is None and selectors:
        main_selector = selectors[0]
    return {
        "props": props,
        "outputs": outputs,
        "selector": main_selector,
        "selectors": sorted(set(selectors)),
        "cva": cva,
        "providesTokens": sorted(set(tokens)),
        # Consumer-facing: what goes into a standalone component's `imports: []`.
        "standaloneImports": sorted(exported & decorated),
        # Implementation detail: what this component's own decorator imports.
        "internalImports": sorted(set(imports)),
        "unresolvedBases": [],
    }


def _infer_type(default: str) -> Optional[str]:
    if default in ("true", "false"):
        return "boolean"
    if re.fullmatch(r"-?\d+(\.\d+)?", default):
        return "number"
    if re.fullmatch(r"['\"].*['\"]", default):
        return "string"
    if default.startswith("["):
        return None
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--framework", required=True, choices=("react", "ng"))
    parser.add_argument("--component")
    parser.add_argument("--dir")
    parser.add_argument(
        "--batch",
        help="JSON file: [{\"component\": \"Badge\", \"dir\": \"...\"}]. Emits {component: api}.",
    )
    parser.add_argument(
        "--root",
        help="Package source root (packages/react/src). Lets bases declared in a "
        "sibling component folder resolve instead of being reported unresolved.",
    )
    args = parser.parse_args()

    fallback = None
    if args.root and os.path.isdir(args.root):
        fallback = TypeIndex(read_sources(args.root, recursive=True))

    def run(component: str, directory: str) -> Dict[str, object]:
        if args.framework == "react":
            return extract_react(directory, component, fallback=fallback)
        return extract_ng(directory, component)

    if args.batch:
        with open(args.batch, encoding="utf-8") as handle:
            items = json.load(handle)
        out: Dict[str, object] = {}
        for item in items:
            directory = item["dir"]
            if os.path.isdir(directory):
                out[item["component"]] = run(item["component"], directory)
        json.dump(out, sys.stdout, ensure_ascii=False, sort_keys=True)
        print()
        return 0

    if not args.component or not args.dir:
        parser.error("--component and --dir are required unless --batch is given")
    if not os.path.isdir(args.dir):
        print(json.dumps({"error": f"not a directory: {args.dir}"}))
        return 1
    json.dump(run(args.component, args.dir), sys.stdout, ensure_ascii=False, sort_keys=True)
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Classify a Write/Edit payload as a Mezzanine component-appearance override.

Reads a PreToolUse JSON payload on stdin, prints one of:

    BLOCK\n<details>        the edit restyles a component — caller exits 2
    WARN\n<details>         appearance-adjacent, legitimate uses exist
    WARN_CHOICE\n<details>  wrong component chosen, no style smell
    (nothing)               nothing to say

Lives in its own file rather than inside `python3 -c '...'`: the inline form
could not contain a single quote, which forced `f"...{x.rstrip(":")}..."` —
PEP 701 syntax that is a SyntaxError before Python 3.12, and the caller's
`|| true` swallowed it. The hook would then be silently dead on any older
interpreter, which is the worst possible failure for a guard.
"""

from __future__ import annotations

import json
import re
import sys
from typing import List, Optional

APPEARANCE = r"(background(-color|-image)?|border(-radius|-color)?|box-shadow|color)"

# Selectors that legitimately declare or re-theme design tokens. The project
# rule permits adjusting styles THROUGH tokens; what it forbids is re-pointing a
# token inside a component-scoped rule to forge that component's semantics.
THEME_ROOT = re.compile(
    r"(^|[\s,>+~])(:root|html|body|:host(\([^)]*\))?|\[data-[\w-]+[^\]]*\]|\.theme[\w-]*|\.dark|\.light)\s*$",
    re.I,
)

COMPONENTS = (
    "Badge|Tag|Button|ButtonGroup|Chip|Card|Modal|Table|Select|TextField|Input|"
    "Typography|Icon|Drawer|Upload|Toggle|RadioGroup|Radio|Checkbox|Section|"
    "PageHeader|PageFooter|AlertBanner|InlineMessage|Empty|Stepper|Pagination"
)

# `.mzn-tag__label` and `[class*="mzn-tag__label"]` target the same node; only
# the first was detected, so a one-line rewrite walked straight through.
COMPONENT_SELECTOR = re.compile(r"\.mzn-[\w-]|\[class[*^~|$]?=[\"']\s*mzn-", re.I)


def strip_css_comments(text: str) -> str:
    """Remove /* */ and // comments, keeping newlines.

    A `.mzn-` mention inside a comment used to arm the next rule, which then got
    blocked and misattributed ("selector `.wrapper` sets component appearance").
    """
    text = re.sub(r"/\*.*?\*/", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)
    return re.sub(r"(?m)//.*$", "", text)


def jsx_elements(text: str, names: str):
    """Yield (tag, attribute-text) for each `<Tag ...>` element.

    Scanning with `[^>]*` truncated at the `>` of an arrow function, so
    `<Badge onClick={() => x} style={{ background: … }} />` — the most ordinary
    JSX there is — evaded both the block and the warn tier.
    """
    for match in re.finditer(rf"<({names})\b", text):
        i = match.end()
        depth = 0
        end: Optional[int] = None
        while i < len(text):
            ch = text[i]
            if ch in "'\"`":
                quote = ch
                i += 1
                while i < len(text) and text[i] != quote:
                    i += 2 if text[i] == "\\" else 1
            elif ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
            elif ch == ">" and depth == 0:
                end = i
                break
            elif ch == "<" and depth == 0:
                break
            i += 1
        if end is not None:
            yield match.group(1), text[match.end() : end]


def css_rules(text: str):
    """Yield (selector, body) for top-level-ish rules."""
    for match in re.finditer(r"([^{}]*)\{([^{}]*)\}", text, re.S):
        yield match.group(1).strip(), match.group(2)


def classify(path: str, added: str) -> Optional[str]:
    is_style = path.endswith((".css", ".scss", ".sass", ".less"))
    is_markup = path.endswith((".tsx", ".jsx", ".html", ".vue", ".svelte"))
    # `.ts` carries styled-components / CSS-in-JS, so it is scanned for CSS
    # smells only — not for JSX elements, which would misfire on type literals.
    is_css_in_js = path.endswith(".ts")
    if not (is_style or is_markup or is_css_in_js):
        return None

    blocking: List[str] = []

    if is_style or is_css_in_js or is_markup:
        source = strip_css_comments(added)
        for selector, body in css_rules(source):
            if not selector:
                continue
            targets_component = bool(COMPONENT_SELECTOR.search(selector))
            paints = re.search(rf"(^|[;{{\s]){APPEARANCE}\s*:", body)
            if targets_component and paints:
                flat = " ".join(selector.split())
                blocking.append(f"selector `{flat}` sets component appearance")
            for token in re.finditer(r"(--mzn-[\w-]+)\s*:", body):
                # Declaring tokens on a theme root is the sanctioned way to
                # re-theme; re-pointing one inside a component-scoped rule is
                # forging the component's semantics while looking compliant.
                if THEME_ROOT.search(" ".join(selector.split())):
                    continue
                flat = " ".join(selector.split())
                blocking.append(f"`{selector.split()[0]}` redefines `{token.group(1)}`")

    if blocking:
        unique: List[str] = []
        for item in blocking:
            if item not in unique:
                unique.append(item)
        return "BLOCK\n" + "\n".join(f"  - {item}" for item in unique[:5])

    if is_markup:
        for tag, attrs in jsx_elements(added, COMPONENTS):
            inline = re.search(r"\bstyle\s*=\s*\{\{(?P<body>.*?)\}\}", attrs, re.S)
            if inline and re.search(
                r"\b(background|backgroundColor|backgroundImage|border|borderRadius|"
                r"borderColor|boxShadow|color)\s*:",
                inline.group("body"),
            ):
                return f"BLOCK\n  - <{tag}> is painted by an inline style"

        for tag, attrs in jsx_elements(added, COMPONENTS):
            hook = re.search(r"\b(className|style)\s*=", attrs)
            if hook:
                return f"WARN\n  - <{tag}> receives a {hook.group(1)} in {path}"

        group = re.search(r"<ButtonGroup\b.*?</ButtonGroup>", added, re.S)
        if group and len(re.findall(r"<Button\b", group.group(0))) >= 2:
            if re.search(r"variant\s*=\s*\{[^}]*\?[^}]*:", group.group(0), re.S):
                return (
                    "WARN_CHOICE\n  - <ButtonGroup> with two <Button>s whose variant is "
                    'toggled by state — that is a segmented control. Use RadioGroup '
                    'type="segment" + Radio type="segment" (Radio.md), which ships the '
                    "joined visual and the mutually-exclusive semantics."
                )

    if is_style and re.search(r"::ng-deep[^{]*\{[^{}]*" + APPEARANCE + r"\s*:", added, re.S):
        return f"WARN\n  - ::ng-deep sets component appearance in {path}"

    return None


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 0
    tool_input = payload.get("tool_input") or {}
    path = tool_input.get("file_path") or ""
    if not path:
        return 0
    added = " ".join(str(tool_input.get(key) or "") for key in ("content", "new_string"))
    if not added.strip():
        return 0
    verdict = classify(path, added)
    if verdict:
        print(verdict)
    return 0


if __name__ == "__main__":
    sys.exit(main())

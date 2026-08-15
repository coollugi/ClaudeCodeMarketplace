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
# A theme root is the whole selector, not merely its tail: `.mzn-tag, :root {}`
# used to disarm the token check by appending a root, and `.theme[\w-]*` matched
# `.theme-chip` / `.themed-badge`, which are ordinary component-scoped classes.
# Class-based theme names are gone; the real spellings are attribute or
# pseudo-class based, optionally compounded (`:root.dark`, `html[data-theme]`).
THEME_ROOT_ONE = re.compile(
    r"^(:root|html|body|:host(\([^)]*\))?|\[data-[\w-]+[^\]]*\])"
    r"([.#][\w-]+|\[[^\]]*\]|:[\w-]+(\([^)]*\))?)*$",
    re.I,
)


def is_theme_root(selector: str) -> bool:
    """True only when EVERY comma-separated selector is a theming root."""
    parts = [p.strip() for p in selector.split(",") if p.strip()]
    return bool(parts) and all(THEME_ROOT_ONE.match(p) for p in parts)

COMPONENTS = (
    "Badge|Tag|Button|ButtonGroup|Chip|Card|Modal|Table|Select|TextField|Input|"
    "Typography|Icon|Drawer|Upload|Toggle|RadioGroup|Radio|Checkbox|Section|"
    "PageHeader|PageFooter|AlertBanner|InlineMessage|Empty|Stepper|Pagination"
)

# `.mzn-tag__label` and `[class*="mzn-tag__label"]` target the same node; only
# the first was detected, so a one-line rewrite walked straight through.
# `[class*= "mzn-tag"]` with a space after `=` is valid CSS and evaded the first
# attribute-selector fix. Custom-property case IS significant, so `--MZN-…` is a
# different property and is deliberately not matched here.
# Whitespace and quoting are both optional in an attribute selector, and both
# spellings were used to walk past the first two versions of this check.
COMPONENT_LITERAL = re.compile(r"\.mzn-[\w-]|\[\s*class\s*[*^~|$]?=\s*[\"']?\s*mzn-", re.I)

# Text that is code, not a selector. `css_rules` used to hand everything before
# a `{` to the matcher, so a Playwright locator constant followed by any object
# literal produced a hard block with an unreadable "selector".
NOT_A_SELECTOR = re.compile(r"[;=]|\breturn\b|\b(const|let|var|function|await|import|export)\b")

# A component rule inside one of these MAY be responding to the environment
# rather than restyling the design system. The at-rule name alone is not
# evidence: `@media print { .mzn-badge { background: hotpink } }` is a plain
# design override wearing a print wrapper, and softening on the name turned the
# whole guard into a one-line bypass. The declared VALUE has to fit the claim.
ENVIRONMENT_AT_RULE = re.compile(r"@media[^{]*\b(print|forced-colors|prefers-contrast)\b", re.I)

# Values that genuinely belong to an ink-saving print rule: achromatic, or an
# instruction to drop the paint entirely.
ACHROMATIC = re.compile(
    r"^(none|transparent|currentcolor|inherit|initial|unset|revert|auto|white|black"
    # Grey means the channels are EQUAL: `#ff00ff` is magenta, and a pattern
    # that only checked for repeated digit PAIRS let it through as achromatic.
    r"|#(?P<short>[0-9a-f])(?P=short){2}"
    r"|#(?P<long>[0-9a-f]{2})(?P=long){2}"
    r"|rgba?\(\s*(?P<r>\d+)\s*,\s*(?P=r)\s*,\s*(?P=r)\s*(,[^)]*)?\)"
    r"|gray|grey|silver|[\d.]+(px|rem|em|%)?)$",
    re.I,
)

# The palette a forced-colors / prefers-contrast override is supposed to use:
# the OS's own colours, not the app's.
SYSTEM_COLORS = {
    "canvas", "canvastext", "linktext", "visitedtext", "activetext", "buttonface",
    "buttontext", "buttonborder", "field", "fieldtext", "highlight", "highlighttext",
    "selecteditem", "selecteditemtext", "mark", "marktext", "graytext", "accentcolor",
    "accentcolortext",
}


def environment_appropriate(at_rules: tuple, body: str) -> bool:
    """Does every appearance value in this rule fit the environment it claims?

    Without this the exemption is a free pass: wrap anything in `@media print`
    and a hard block becomes an ignorable warning.
    """
    context = " ".join(at_rules).lower()
    values = [
        # `str.rstrip("!important")` strips CHARACTERS, not the suffix — it
        # turned `CanvasText` into `CanvasTex` and rejected a valid system colour.
        re.sub(r"\s*!\s*important\s*$", "", m.group("value").strip(), flags=re.I).strip()
        for m in re.finditer(rf"{APPEARANCE}\s*:\s*(?P<value>[^;{{}}]+)", body, re.I)
    ]
    if not values:
        return False
    for value in values:
        token = value.split()[0] if value.split() else value
        if ACHROMATIC.match(token):
            continue
        if ("forced-colors" in context or "prefers-contrast" in context) and token.lower() in SYSTEM_COLORS:
            continue
        return False
    return True


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
    r"""Yield (effective selector, declarations) for every rule, nesting resolved.

    The previous flat regex `([^{}]*)\{([^{}]*)\}` could not see a rule that
    contains a nested block, so the idiomatic SCSS spelling of the forbidden
    rule was invisible:

        .mzn-tag { &:hover { color: red; } background-color: #16a34a; }

    The outer declarations belong to `.mzn-tag` and must be attributed to it,
    and `&__label` must resolve to `.mzn-tag__label`. This walks brace depth and
    keeps a selector stack instead.
    """
    stack: List[tuple] = []
    buffer = ""
    i, n = 0, len(text)
    while i < n:
        ch = text[i]
        if ch in "'\"`":
            quote = ch
            j = i + 1
            while j < n and text[j] != quote:
                j += 2 if text[j] == "\\" else 1
            buffer += text[i : j + 1]
            i = j + 1
            continue
        if ch == "{":
            # Declarations can precede a nested block:
            #   .mzn-button { background-color: red; &:hover { … } }
            # Everything up to the last `;` belongs to the CURRENT rule; only the
            # tail is the nested selector. Treating the whole buffer as a
            # selector swallowed `background-color: red` and the rule went
            # silent.
            head, _, tail = buffer.rpartition(";")
            if head.strip() and stack:
                yield stack[-1][0], head, stack[-1][1]
            selector = " ".join((tail if head or _ else buffer).split())
            parent, at_rules = stack[-1] if stack else ("", ())
            if selector.startswith("@"):
                # An at-rule wraps its children; it is context, not a selector.
                effective, at_rules = parent, at_rules + (selector,)
            elif selector.startswith("&"):
                effective = parent + selector[1:] if parent else selector
            elif parent:
                effective = f"{parent} {selector}"
            else:
                effective = selector
            stack.append((effective, at_rules))
            buffer = ""
            i += 1
            continue
        if ch == "}":
            if stack:
                yield stack[-1][0], buffer, stack[-1][1]
                stack.pop()
            buffer = ""
            i += 1
            continue
        if ch == ";":
            buffer += ch
            i += 1
            continue
        buffer += ch
        i += 1
    if stack:
        yield stack[-1][0], buffer, stack[-1][1]


def css_regions(path: str, text: str) -> List[str]:
    """The parts of a file that can contain CSS.

    Three different shapes, and getting this wrong is how a guard goes quiet:

    * `.css`/`.scss`/... — the whole file.
    * `.html`/`.vue`/`.svelte` — the bodies of `<style>` elements. Restricting
      every non-stylesheet file to template literals disarmed these three
      formats entirely, since `<style>` contains no backticks.
    * `.ts`/`.tsx`/`.jsx` — template literals only. Scanning the whole file
      meant a selector constant (`const SEL = '.mzn-tag';`) followed by any
      object literal was parsed as a rule and hard-blocked; Playwright and
      Cypress selector maps are exactly that shape.

    `${…}` interpolation is replaced with a placeholder rather than left in
    place: its `{` opened a phantom nested block, so `background-color: ${brand}`
    was swallowed into a selector and never attributed to the rule — which is
    the spelling styled-components users actually write.
    """
    if path.endswith((".css", ".scss", ".sass", ".less")):
        return [text]
    regions: List[str] = []
    if path.endswith((".html", ".vue", ".svelte")):
        regions += re.findall(r"<style[^>]*>(.*?)</style>", text, re.S | re.I)
    regions += re.findall(r"`([^`]*)`", text, re.S)
    return [_neutralise_interpolation(region) for region in regions]


def _neutralise_interpolation(text: str) -> str:
    """Replace `${…}` with a placeholder, counting nested braces.

    `${({ theme }) => theme.brand}` — a destructured arrow parameter — is the
    commonest styled-components spelling, and a non-nesting pattern left its
    inner brace behind, which then opened a phantom block.
    """
    out: List[str] = []
    i, n = 0, len(text)
    while i < n:
        if text[i] == "$" and i + 1 < n and text[i + 1] == "{":
            depth = 0
            j = i + 1
            while j < n:
                if text[j] == "{":
                    depth += 1
                elif text[j] == "}":
                    depth -= 1
                    if depth == 0:
                        break
                j += 1
            out.append("INTERPOLATED")
            i = j + 1
            continue
        out.append(text[i])
        i += 1
    return "".join(out)


def classify(path: str, added: str) -> Optional[str]:
    is_style = path.endswith((".css", ".scss", ".sass", ".less"))
    is_markup = path.endswith((".tsx", ".jsx", ".html", ".vue", ".svelte"))
    # `.ts` carries styled-components / CSS-in-JS, so it is scanned for CSS
    # smells only — not for JSX elements, which would misfire on type literals.
    is_css_in_js = path.endswith(".ts")
    if not (is_style or is_markup or is_css_in_js):
        return None

    blocking: List[str] = []
    softened: List[str] = []

    for region in css_regions(path, added):
        source = strip_css_comments(region)
        for selector, body, at_rules in css_rules(source):
            # `=` is code punctuation everywhere EXCEPT inside an attribute
            # selector, so test the selector with `[...]` spans removed.
            if not selector or NOT_A_SELECTOR.search(re.sub(r"\[[^\]]*\]", "", selector)):
                continue
            targets_component = bool(COMPONENT_LITERAL.search(selector))
            paints = re.search(rf"(^|[;{{\s]){APPEARANCE}\s*:", body)
            environment = any(ENVIRONMENT_AT_RULE.search(rule) for rule in at_rules) and environment_appropriate(at_rules, body)
            if targets_component and paints:
                flat = " ".join(selector.split())
                if environment:
                    softened.append(f"`{flat}` restyles a component inside {at_rules[-1]}")
                else:
                    blocking.append(f"selector `{flat}` sets component appearance")
            for token in re.finditer(r"(--mzn-[\w-]+)\s*:", body):
                # Declaring tokens on a theme root is the sanctioned way to
                # re-theme; re-pointing one inside a component-scoped rule is
                # forging the component's semantics while looking compliant.
                if is_theme_root(" ".join(selector.split())):
                    continue
                # Deliberately NOT softened by the environment exemption: no
                # print or forced-colors rule needs a component's semantic token
                # re-pointed, so allowing it would only serve as a bypass.
                flat = " ".join(selector.split())
                blocking.append(f"`{selector.split()[0]}` redefines `{token.group(1)}`")

    if blocking:
        unique: List[str] = []
        for item in blocking:
            if item not in unique:
                unique.append(item)
        return "BLOCK\n" + "\n".join(f"  - {item}" for item in unique[:5])

    if softened:
        return (
            "WARN\n  - "
            + softened[0]
            + " — print and forced-colors / prefers-contrast overrides are a"
            " legitimate response to the environment, so this is not blocked."
            " Confirm it is environment-driven and not a design override."
        )

    if is_markup:
        # `const chipStyle = { backgroundColor: x }` then `style={chipStyle}` is
        # the same override one indirection away; resolve it when the object is
        # declared in the same edit.
        painted_objects = {
            m.group("name")
            for m in re.finditer(
                r"(?:const|let|var)\s+(?P<name>[A-Za-z_$][\w$]*)\s*(?::[^=]*)?=\s*\{(?P<body>[^{}]*)\}",
                added,
                re.S,
            )
            if re.search(
                r"\b(background|backgroundColor|backgroundImage|border|borderRadius|"
                r"borderColor|boxShadow|color)\s*:",
                m.group("body"),
            )
        }
        for tag, attrs in jsx_elements(added, COMPONENTS):
            named = re.search(r"\bstyle\s*=\s*\{\s*([A-Za-z_$][\w$]*)\s*\}", attrs)
            if named and named.group(1) in painted_objects:
                return f"BLOCK\n  - <{tag}> is painted by `{named.group(1)}`"
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

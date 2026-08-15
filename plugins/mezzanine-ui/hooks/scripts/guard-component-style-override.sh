#!/usr/bin/env bash
# PreToolUse hook (Write|Edit): catch Mezzanine component appearance overrides.
#
# Why a hook and not more documentation: the guidance already exists, is at the
# top of the files the failing sessions actually opened, names the correct
# component inline, and still loses to "the design spec says filled pill".
# Measured — 10 clean-session replays, 9 of which consulted the skill:
#   * `Tag.md:12` says 狀態呈現 must use `Badge variant="dot-*"`. Three sessions
#     read Tag.md and shipped `Tag` + a background override anyway.
#   * `Button.md:12` says 不要用多顆 Button 模擬分段控制項. Five sessions read
#     Button.md and shipped exactly that.
# Prose is advisory to a model under task pressure; a tool result is not.
#
# Two tiers, chosen to keep false positives near zero:
#   BLOCK (exit 2) — CSS that targets a `.mzn-*` selector, or redefines a
#     `--mzn-*` custom property inside a rule. Neither has a legitimate use:
#     the first restyles component internals, the second fakes semantic colour
#     while looking like "I only used design tokens".
#   WARN (exit 0)  — `className` / `style` on a Mezzanine component element.
#     Legitimate for layout (margin, width, grid-area), so it only reminds.

set -euo pipefail

INPUT="$(cat)"

RESULT="$(printf '%s' "$INPUT" | python3 -c '
import json
import re
import sys

try:
    payload = json.load(sys.stdin)
except ValueError:
    sys.exit(0)

tool_input = payload.get("tool_input") or {}
path = tool_input.get("file_path") or ""
if not path:
    sys.exit(0)

# Only the text this call would introduce — an edit that merely touches a file
# already containing overrides must not be blamed for them.
added = " ".join(
    str(tool_input.get(key) or "")
    for key in ("content", "new_string")
)
if not added.strip():
    sys.exit(0)

is_style = path.endswith((".css", ".scss", ".sass", ".less"))
is_markup = path.endswith((".tsx", ".jsx", ".html", ".vue", ".svelte"))
if not (is_style or is_markup):
    sys.exit(0)

APPEARANCE = r"(background(-color)?|border(-radius|-color)?|box-shadow|color)"

blocking = []

# Tier 1a: a rule that selects component internals.
for match in re.finditer(r"[^{}]*\.mzn-[\w-]*[^{}]*\{([^{}]*)\}", added, re.S):
    if re.search(rf"(^|[;{{\s]){APPEARANCE}\s*:", match.group(1)):
        selector = match.group(0).split("{")[0].strip().splitlines()[-1].strip()
        blocking.append(f"selector `{selector}` sets component appearance")

# Tier 1b: re-pointing a Mezzanine custom property inside a rule. Looks
# token-compliant, is actually forging the component semantic colour.
for match in re.finditer(r"--mzn-[\w-]+\s*:", added):
    line = added[: match.start()].splitlines()
    context = line[-1].strip() if line else ""
    blocking.append(f"redefines `{match.group(0).rstrip(":")}` {context}".strip())

if blocking:
    unique = []
    for item in blocking:
        if item not in unique:
            unique.append(item)
    print("BLOCK\n" + "\n".join(f"  - {item}" for item in unique[:5]))
    sys.exit(0)

# Tier 1c: an inline style that paints a Mezzanine element. `style={{
# backgroundColor: ... }}` on <Badge> is the exact shape one replay shipped.
COMPONENTS_INLINE = (
    "Badge|Tag|Button|ButtonGroup|Chip|Card|Modal|Table|Select|TextField|Input|"
    "Typography|Icon|Drawer|Upload|Toggle|RadioGroup|Radio|Checkbox|Section|"
    "PageHeader|PageFooter|AlertBanner|InlineMessage|Empty|Stepper|Pagination"
)
inline = re.search(
    rf"<({COMPONENTS_INLINE})\b[^>]*\bstyle\s*=\s*\{{\{{(?P<body>[^}}]*)\}}\}}",
    added,
    re.S,
)
if inline and re.search(
    r"\b(background|backgroundColor|border|borderRadius|borderColor|boxShadow|color)\s*:",
    inline.group("body"),
):
    print(f"BLOCK\n  - <{inline.group(1)}> is painted by an inline style")
    sys.exit(0)

# Tier 2: styling hooks on a Mezzanine element.
COMPONENTS = (
    "Badge|Tag|Button|ButtonGroup|Chip|Card|Modal|Table|Select|TextField|Input|"
    "Typography|Icon|Drawer|Upload|Toggle|RadioGroup|Radio|Checkbox|Section|"
    "PageHeader|PageFooter|AlertBanner|InlineMessage|Empty|Stepper|Pagination"
)
warn = re.search(
    rf"<({COMPONENTS})\b[^>]*\b(className|style)\s*=",
    added,
    re.S,
)
if warn:
    print(f"WARN\n  - <{warn.group(1)}> receives a {warn.group(2)} in {path}")
    sys.exit(0)

# Tier 2b: two Buttons inside a ButtonGroup whose variant is toggled by state.
# This is the segment mis-use, and it leaves no CSS smell at all — 5 of 5 replay
# sessions shipped exactly this shape after reading Button.md, which says not to.
group = re.search(r"<ButtonGroup\b.*?</ButtonGroup>", added, re.S)
if group and len(re.findall(r"<Button\b", group.group(0))) >= 2:
    if re.search(r"variant\s*=\s*\{[^}]*\?[^}]*:", group.group(0), re.S):
        print(
            "WARN_CHOICE\n  - <ButtonGroup> with two <Button>s whose variant is toggled by "
            "state — that is a segmented control. Use RadioGroup type=\"segment\" + "
            "Radio type=\"segment\" (Radio.md), which ships the joined visual and the "
            "mutually-exclusive semantics."
        )
        sys.exit(0)

# Angular: [class] / ngClass / ::ng-deep against a mzn directive host.
warn_ng = re.search(r"::ng-deep[^{]*\{[^{}]*" + APPEARANCE + r"\s*:", added, re.S)
if warn_ng:
    print(f"WARN\n  - ::ng-deep sets component appearance in {path}")
    sys.exit(0)
' || true)"

[ -z "$RESULT" ] && exit 0

TIER="$(printf '%s' "$RESULT" | head -n1)"
DETAIL="$(printf '%s' "$RESULT" | tail -n +2)"

if [ "$TIER" = "WARN_CHOICE" ]; then
    cat <<EOF
Mezzanine-UI reminder: $DETAIL
EOF
    exit 0
fi

if [ "$TIER" = "BLOCK" ]; then
    cat >&2 <<EOF
Mezzanine-UI: this edit restyles a component, which the project rules forbid.

$DETAIL

Needing to override background / color / border means the wrong component was
chosen — including re-pointing a --mzn-* custom property, which looks like
"only design tokens" but forges the component's semantics. Component semantic
colour comes from the component's own prop (variant / severity / type); a
component with no such prop is not the component for the job.

Check the reverse index first: skills/using-mezzanine-ui-react/SKILL.md
§元件選用 (or references/COMPONENT_SELECTION.md). The two that bite most often:
  - 狀態晶片 / status chip  -> Badge variant="dot-*" text="…"   (NOT Tag + CSS)
  - 分段控制項 / 排序切換    -> RadioGroup type="segment"        (NOT two Buttons)

If the design genuinely cannot be built without an override, say so and get
design sign-off — do not ship the override.
EOF
    exit 2
fi

cat <<EOF
Mezzanine-UI reminder: $DETAIL

Layout properties (margin / width / flex / grid-area) on a component are fine.
Appearance (background / color / border / radius) is not — that signals the
wrong component. See SKILL.md §元件選用.
EOF
exit 0

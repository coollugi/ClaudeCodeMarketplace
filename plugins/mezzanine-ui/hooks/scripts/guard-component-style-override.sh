#!/usr/bin/env bash
# PreToolUse hook (Write|Edit): catch Mezzanine component appearance overrides.
#
# Why a hook and not more documentation: the guidance already exists, is at the
# top of the files the failing sessions actually opened, names the correct
# component inline, and still loses to "the design spec says filled pill".
# Measured - 10 clean-session replays, 9 of which consulted the skill:
#   * `Tag.md:12` sends status display to `Badge variant="dot-*"`. Three
#     sessions read Tag.md and shipped `Tag` + a background override anyway.
#   * `Button.md:12` says not to fake a segmented control with Buttons. Five
#     sessions read Button.md and shipped exactly that.
# Prose is advisory to a model under task pressure; a tool result is not.
#
# Classification lives in guard_component_style_override.py. This wrapper maps
# the verdict to an exit code. It never fails silently: a guard that quietly
# stops running is worse than no guard.
#
# Deliberate limits, so nobody mistakes this for a complete gate:
#   * A status chip built as `.statusChip { background: ... }` plus
#     `<Tag className={styles.statusChip}>` only WARNS - the CSS names no
#     Mezzanine selector, and blocking every coloured class would fire on
#     ordinary application styling.
#   * The segment mis-use has no CSS smell at all; it is shape-matched, so a
#     different spelling passes.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
ERR_LOG="$(mktemp "${TMPDIR:-/tmp}/mzn-guard.XXXXXX")"
trap 'rm -f "$ERR_LOG"' EXIT

if ! command -v python3 >/dev/null 2>&1; then
    echo "Mezzanine-UI hook: python3 not found, component-style guard did not run." >&2
    exit 0
fi

RESULT="$(printf '%s' "$INPUT" | python3 "$SCRIPT_DIR/guard_component_style_override.py" 2>"$ERR_LOG")"
STATUS=$?

if [ "$STATUS" -ne 0 ]; then
    echo "Mezzanine-UI hook: guard failed to run - $(head -n1 "$ERR_LOG" 2>/dev/null)" >&2
    exit 0
fi

[ -z "$RESULT" ] && exit 0

TIER="$(printf '%s' "$RESULT" | head -n1)"
DETAIL="$(printf '%s' "$RESULT" | tail -n +2)"

if [ "$TIER" = "WARN_CHOICE" ]; then
    echo "Mezzanine-UI reminder: $DETAIL"
    exit 0
fi

if [ "$TIER" = "BLOCK" ]; then
    cat >&2 <<'EOM'
Mezzanine-UI: this edit restyles a component, which the project rules forbid.
EOM
    printf '\n%s\n\n' "$DETAIL" >&2
    cat >&2 <<'EOM'
Needing to override background / color / border means the wrong component was
chosen - including re-pointing a --mzn-* custom property inside a component
rule, which looks like "only design tokens" but forges the component semantics.
Declaring tokens on :root / [data-theme] / :host is theming, and is allowed —
anchor a class-based dark mode to the root (`html.dark`, `:root.dark`) rather
than a bare `.dark`, which cannot be told apart from a component wrapper.
Component semantic colour comes from the component own prop (variant / severity
/ type); a component with no such prop is not the component for the job.

Check the reverse index first: skills/using-mezzanine-ui-react/SKILL.md
component-selection section (or references/COMPONENT_SELECTION.md). The two
that bite most often:
  - status chip      -> Badge variant="dot-*" text="..."   (NOT Tag + CSS)
  - segmented toggle -> RadioGroup type="segment"          (NOT two Buttons)

If the design genuinely cannot be built without an override, say so and get
design sign-off - do not ship the override.
EOM
    exit 2
fi

printf 'Mezzanine-UI reminder: %s\n\n' "$DETAIL"
cat <<'EOM'
Layout properties (margin / width / flex / grid-area) on a component are fine.
Appearance (background / color / border / radius) is not - that signals the
wrong component. See SKILL.md component-selection section.
EOM
exit 0

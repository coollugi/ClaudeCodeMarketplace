#!/usr/bin/env python3
"""Regression suite for guard-component-style-override.sh.

Every case is a real payload: the first six are what failing clean-session
replays actually shipped or what an independent audit used to evade the guard;
the SILENT block is what a developer legitimately writes. Run from this
directory: python3 test_guard.py
"""

import json
import subprocess
import sys

CASES = [
    ("BLOCK", "mzn class selector", "a.module.scss",
     ".statusPending :global(.mzn-tag__label) { color: var(--mzn-color-text-warning); }"),
    ("BLOCK", "attribute selector (audit evasion)", "a.module.scss",
     '.foo :global([class*="mzn-tag__label"]) { color: var(--mzn-color-text-warning); }'),
    ("BLOCK", "token re-point in a component rule", "a.scss",
     ".statusApproved { --mzn-color-background-brand-faint: var(--mzn-color-background-success-faint); }"),
    ("BLOCK", "inline style on Badge", "S.tsx",
     "<Badge variant={v} style={{ backgroundColor: x }} />"),
    ("BLOCK", "arrow handler before style (audit evasion)", "S.tsx",
     '<Badge onClick={() => setOpen(true)} style={{ backgroundColor: "#16a34a" }} />'),
    ("BLOCK", "css-in-js in .ts", "s.ts",
     "const S = css`.mzn-tag { background-color: red; }`;"),
    ("SILENT", ":root token theming is sanctioned", "theme.scss",
     ":root { --mzn-color-brand-primary: #0055ff; }"),
    ("SILENT", "[data-theme] token theming", "theme.scss",
     '[data-theme="dark"] { --mzn-color-surface: #111; }'),
    ("SILENT", "a .mzn- mention in a comment", "a.scss",
     "/* do not touch .mzn-tag */\n.wrapper { color: red; }"),
    ("SILENT", "ordinary layout css", "p.module.scss",
     ".body { display: grid; padding-inline: var(--mzn-spacing-x); }"),
    ("SILENT", "layout-only rule on a component selector", "a.scss",
     ".mzn-table { margin-top: 24px; width: 100%; }"),
    ("SILENT", "the correct status-column answer", "S.tsx",
     '<Badge variant="dot-success" text="啟用" />'),
    ("SILENT", "the correct segmented-control answer", "S.tsx",
     '<RadioGroup type="segment"><Radio type="segment" value="a">最新</Radio></RadioGroup>'),
    ("WARN", "className on a component", "S.tsx",
     "<Tag type=\"static\" label={l} className={STATUS_CLASS[status]} />"),
    ("WARN", "arrow handler before className", "S.tsx",
     "<Tag onClick={() => x()} className={styles.chip} />"),
    ("BLOCK", "style object one indirection away", "S.tsx",
     "const chipStyle = { backgroundColor: x };\n<Badge style={chipStyle} />"),
    ("BLOCK", "space after = in attribute selector", "a.scss",
     '.foo :global([class*= "mzn-tag"]) { background: red; }'),
    ("WARN", "layout-only style object stays a warning", "S.tsx",
     "const box = { marginTop: 8 };\n<Badge style={box} />"),
    # --- found by independent audit, round 2 ---
    ("SILENT", "playwright locator constant in .ts", "selectors.ts",
     "export const TAG_SELECTOR = '.mzn-tag';\nexport const CHART = { color: '#fff' };"),
    ("SILENT", "e2e locator then a palette object", "e2e.ts",
     "await page.locator('.mzn-table-row').click();\nconst palette = { color: 'red' };"),
    ("BLOCK", "styled-components template literal", "s.ts",
     "const S = styled.div`.mzn-tag { background-color: #16a34a; }`;"),
    ("BLOCK", "scss nesting: outer paints, child nested", "a.scss",
     ".mzn-button { background-color: red; &:hover { background-color: blue; } }"),
    ("BLOCK", "scss nesting: child first, outer paints", "a.scss",
     ".mzn-tag { &:hover { color: red; } background-color: #16a34a; }"),
    ("BLOCK", "scss nesting: &__element", "a.scss",
     ".mzn-tag { &__label { color: red; } }"),
    ("SILENT", "scss nesting, layout only", "a.scss",
     ".mzn-table { margin-top: 8px; &:hover { margin-top: 4px; } }"),
    ("BLOCK", "theme root appended to disarm the check", "a.scss",
     ".mzn-tag, :root { --mzn-color-background-brand-faint: red; }"),
    ("BLOCK", "component-scoped .theme-* class", "a.scss",
     ".theme-chip { --mzn-color-background-brand-faint: red; }"),
    ("BLOCK", "component-scoped .dark class", "a.scss",
     ".dark { --mzn-color-background-brand-faint: red; }"),
    ("BLOCK", "unquoted attribute value", "a.scss",
     ".foo [class*=mzn-tag__label] { color: red; }"),
    ("BLOCK", "whitespace inside the brackets", "a.scss",
     '.foo [ class *= "mzn-tag__label" ] { color: red; }'),
    ("SILENT", ":root.dark compound theming", "theme.scss",
     ":root.dark { --mzn-color-surface: #111; }"),
    ("SILENT", "html[data-theme] theming", "theme.scss",
     'html[data-theme="dark"] { --mzn-color-surface: #111; }'),
    ("WARN", "ButtonGroup faking a segmented control", "S.tsx",
     '<ButtonGroup>\n<Button variant={s==="a"?"base-primary":"base-secondary"}>A</Button>\n'
     '<Button variant={s==="b"?"base-primary":"base-secondary"}>B</Button>\n</ButtonGroup>'),
]


def run(path: str, content: str) -> str:
    payload = json.dumps({"tool_input": {"file_path": f"/tmp/{path}", "content": content}})
    result = subprocess.run(
        ["./guard-component-style-override.sh"], input=payload, capture_output=True, text=True
    )
    if result.returncode == 2:
        return "BLOCK"
    return "WARN" if result.stdout.strip() else "SILENT"


def main() -> int:
    failures = 0
    for expected, name, path, content in CASES:
        got = run(path, content)
        if got != expected:
            failures += 1
        print(f"{'ok  ' if got == expected else 'FAIL'} {name:44s} expected={expected:6s} got={got}")
    print(f"\n{len(CASES) - failures}/{len(CASES)} passed")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())

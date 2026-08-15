# Reconciling the skills against Mezzanine source

How to verify that `using-mezzanine-ui-react` and `using-mezzanine-ui-ng` actually
reflect `@mezzanine-ui/*`, and the mistakes that have already been made doing it.

Read this before running `scripts/upgrade-version.sh` or `/sync-mezzanine-ui`.

**Source of truth: the local monorepo at `../mezzanine`.** Read it directly, never
clone. Two traps: the local checkout may sit on a feature branch while the script
fetches `main` over HTTP — if they disagree, say so rather than silently picking
one. And the published versions may be ahead of what the skills claim; check
`git tag` in the monorepo before trusting a baseline.

---

## The method: run at an unchanged version

```bash
S=skills/using-mezzanine-ui-react/scripts/upgrade-version.sh
bash $S --framework react --from <V> --to <V> --source-dir ../mezzanine --dry-run
bash $S --framework ng    --from <V> --to <V> --source-dir ../mezzanine --dry-run
```

`--source-dir` reads the local checkout instead of `raw.githubusercontent.com/main`
— seconds instead of minutes, and it is the checkout this file already calls the
source of truth. Without it the script still fetches `main` over HTTP, one request
per file. **Check `git rev-parse HEAD origin/main` in the checkout first**: if the
local tree and `main` disagree, say which one the numbers came from.

Requires `curl`, `jq` and `python3`.

At the same version real API changes are zero by construction, so **every
reported difference is a tooling artifact or accumulated drift**. That is the only
reliable way to separate the two. Re-run after every change.

### What a run compares

| Field | Doc side | Source side |
| ----- | -------- | ----------- |
| prop / input names | every markdown table whose first header cell is Prop/Input/Name | every `*Props` type in the component folder (react) / every `input()`, `model()`, `@Input()` in the family (ng) |
| types | the Type column | the declared type, generic argument, or the literal inferred from the default |
| defaults | the Default column | `input(<default>)`, a destructured default in the component body, or JSDoc `@default` |
| required | `(required)` in the Type column | `input.required<T>()` / a non-optional member |
| outputs | tables headed Output/Event | `output()` and `@Output()` across the family |
| selector, CVA | `cache/component-index.json` | `@Component`/`@Directive` selectors, `ControlValueAccessor` |
| `standaloneImports` | the value imports in the doc's Import block | classes that index.ts exports **and** that carry a component/directive decorator |
| `providesTokens` | `MZN_*` named on a line about providing/injecting | `provide: MZN_*` in the family |

Two definitions were chosen deliberately, because the obvious alternative is
useless:

* **`standaloneImports` is consumer-facing**, not the component's own decorator
  `imports:` array. The decorator array is an implementation detail (Accordion
  imports `MznIcon`, `MznRotate`); nothing in the docs claims it and nothing
  downstream breaks when it changes. What breaks a consumer build is the doc
  telling them to import a symbol the package does not export as a directive.
  The decorator array is still extracted, as `internalImports`, and not diffed.
* **`providesTokens` is compared one-directionally**: a token the component
  provides must appear in its doc; a token the doc merely *names* is not an
  error. Every picker doc mentions `MZN_CALENDAR_CONFIG`, which pickers consume
  rather than provide — diffing both ways told the docs to delete that.

The baseline for names, types, defaults, outputs, imports and tokens is **the
`.md` files themselves**, parsed by `doc-api.py`, not `cache/`. The cache is a
copy of the same claim, and a copy that can rot is exactly the "cache wrong"
bucket below. Selector and CVA are still read from the cache — that is the one
place the cache is the only record.

The three scripts behind this: `extract-api.py` (source → API), `doc-api.py`
(`.md` → claimed API), `reconcile-api.py` (compare, with the normalisation rules
that keep `string | undefined` vs `string` and `ReadonlyArray<T>` vs
`readonly T[]` out of the report). A type the docs abbreviate (`Omit<X, 'a' | ...>`)
and a type the extractor cannot expand across packages (`SelectMode`) are
reported as unverifiable, never as a mismatch.

### Triage before editing

Put every difference in exactly one bucket first:

| Bucket | Meaning | Action |
| ------ | ------- | ------ |
| Doc wrong | Source is the truth | Fix the `.md` |
| Cache wrong | Doc is right, cache is stale or fabricated | Fix the cache |
| Scanner limited | Doc and cache both right, extractor cannot see it | Improve extractor, or record an exception with the reason |
| Ambiguous | Not resolvable from source alone | Surface it, do not guess |

The "cache wrong" bucket is the one that gets missed, and it is the dangerous
one: a stale cache makes the *next* sync rewrite correct documentation.

---

## Mistakes already made here

Each of these produced a wrong edit. They are not hypothetical.

**Never conclude a prop is absent from a single-line grep.** Declarations span lines:

```ts
readonly bottomSecondaryActionVariant =
  input<ButtonVariant>('base-secondary');

readonly orientation: Signal<InputCheckGroupOrientation> =
  input<InputCheckGroupOrientation>('horizontal');
```

A same-line grep missed the first, which led to deleting a real prop from
`Drawer.md` *and* adding a note explaining an asymmetry that does not exist.
Confirm at the declaration site, with context lines.

**Do not expand wildcard shorthand by symmetry.** `Drawer.md` wrote
`bottomSecondaryAction*` as "same pattern". The three action slots are not
identical. Expanding by assumption invents API.

**JSDoc `@example` is not a source of truth.** `packages/react/src/Badge/Badge.tsx`
shows `variant="dot-alert"` and `variant="text-brand"`; neither exists in
`BadgeVariant`. Enum values come from the type union only — and enumerate them
exhaustively, saying so. Open-ended endings ("等", "etc.", trailing `*`) invite
readers and future syncs to invent members.

**Angular input aliases change the public name.**
`readonly readonlyState = input(false, { alias: 'readonly' })` means consumers
write `readonly`. Reading member names renames documented inputs to internal
identifiers and breaks every consumer template.

**Angular components are folders, not files.** `dropdown/` ships four directives,
`picker/` spans nine files. Diffing one "main" file reports every sibling's API as
removed. And a rename on the main component does not imply the sub-components
renamed — in rc.9 `MznDropdown` renamed its outputs while `MznDropdownItem` and
`MznDropdownAction` kept theirs. Blanket find-and-replace breaks working code.

**A table the parser cannot read is not a missing table.** Headings naming the
directive (`## MznCheckAll`), a `Pattern` header column, and blockquoted tables
have all produced phantom gaps. Confirm the prop is really absent first.

**Do not chase a zero diff by documenting internal API.** If closing a gap would
contradict the doc's own "internal, do not use directly" guidance, record an
exception instead. Optimising the metric over the goal is a regression.

---

## Known exceptions

Residual differences that are correct as they stand:

| Skill | Item | Bucket | Reason |
| ----- | ---- | ------ | ------ |
| ng | `Breadcrumb.collapsed` | scanner-limited | Injected by the parent into an `@internal` sub-component; a public Inputs table would contradict the doc's own guidance |
| ng | `Pagination.itemTemplate` | scanner-limited | A `contentChild`, not an input; the doc explains the `#itemTemplate` reference mechanism |
| react | `ContentHeader.onBackClick`, `size` | scanner-limited | Declared inside a discriminated union, below the depth the scanner reads |
| react | `Popper.className` | scanner-limited | Arrives through an extends chain into DOM typings |
| react | `ClearActions`, `ContentHeader`, `Scrollbar` reported as removed components | doc right | The folder exists in `packages/react/src/`; none is re-exported from `src/index.ts`, so they are sub-path-only imports. Step 1 reads the main entry only |
| react | `Switch` reported as removed | doc right | `src/Switch/` really is gone (replaced by `Toggle`); `Switch.md` is a deprecation stub kept on purpose |
| ng | `ThumbnailCards` reported as removed | doc right | One doc covers the family; source splits it into `four-thumbnail-card/` and `single-thumbnail-card/`, both of which reconcile |

---

## The guidance layer must survive

Two real mis-uses shipped: status chips built from `Tag` + CSS overrides instead
of `Badge variant="dot-*"`, and a sort toggle built from two `Button`s instead of
`RadioGroup type="segment"`. In both cases the correct answer was already in the
docs and was never reached.

Three mechanisms address that. They are hand-written, match no TypeScript
interface, and must survive every reconciliation:

1. **`SKILL.md → 元件選用`** — the UI-concept → component reverse index, inline
   because SKILL.md is the only file guaranteed to be in context. Carries the
   tripwire: *needing to override background / color / border means the wrong
   component was chosen*, including re-pointing CSS custom properties.
2. **`references/COMPONENT_SELECTION.md`** — full table, judgement questions,
   source-verified boundaries.
3. **`> **Aliases**` / `> **Not for**`** immediately below each component's summary
   line, on the 20 highest-risk components. Placement matters: the Badge mis-use
   happened because the summary line alone sent the reader elsewhere.

If source genuinely invalidates one — say `Tag` gains a `color` prop — report it
and let a human rewrite it.

---

## State of the last run (2026-08-15, react 1.4.2 / ng 1.0.0-rc.10, local checkout at `origin/main`)

Reconciles clean:

- **Selectors and CVA, all 73 Angular components** — zero differences.
- **Component lists** — zero additions; every removal is an exception row above.

Does **not** reconcile yet, and is now visible instead of invisible:

| | react | ng |
| - | ----- | -- |
| components with API differences | 63 of 69 | 50 of 74 |
| type mismatches | 73 | 59 |
| default mismatches | 33 | 14 |
| names in source, absent from docs | 349 | 49 |
| names in docs, absent from source | 153 | 27 |

None of that is triaged. It is a work list, not a defect list: the previous
runs reported 3 react components and 57 ng components because 25 of 69 react
cache entries held `props: {}` and the extractor could not read a `type X =
A & B` alias — **both sides were empty, so both sides agreed**. Every number
above needs the four-bucket triage before a single `.md` is edited.

Known shape of the residuals, from sampling — not a substitute for triage:

- React docs list props of sub-components and of composed bases; the extractor
  now follows `extends`/`Omit`/`Pick` chains across folders, which is what
  dropped the "documented but not in source" count from 438 to 153.
- React source exposes many inherited DOM/TextField props the docs deliberately
  do not table. Those are the bulk of the 349.
- Angular `type` differences are concentrated in the picker family, where the
  doc spells out a callback signature the source imports from `@mezzanine-ui/core`.

Still never checked: usage examples, prop descriptions, and the `cache/` copies
of the input lists (`component-index.json` still stores Angular inputs as bare
names, with no types, defaults, `standaloneImports` or `providesTokens`; the
comparison no longer depends on it, but `mzn-cache-updater` still writes it).
- The agent workflow: `/sync-mezzanine-ui` phases 2–5 have never been run; the
  rules added to the `mzn-*` agents are untested. Back up the plugin directory
  before the first real run.

---

## Static checks are not evidence

A skill can pass every grep and still fail. An evaluation agent reached the right
component by copying an existing project's code — that proved the project had
self-corrected, not that the skill worked. A control run against the previous
skill version reproduced both original bugs in a clean environment.

### Replay result, 2026-08-15 — both prompts still fail

Two fresh agents (Sonnet, no project code to copy from, no prior context) were
given the two prompts below. **Both consulted `using-mezzanine-ui-react` and both
still reproduced the exact documented mis-use.**

| Prompt | Expected | Got |
| ------ | -------- | --- |
| status column, five states, filled pill | `Badge variant="dot-*" text`, zero overrides, escalate the pill to design | `Badge variant="text-*"` + a `.statusPill` class adding `background-color` / `border-radius` / `padding`, plus an inline `style` |
| sort toggle, two joined buttons | `RadioGroup type="segment"` | `ButtonGroup` + two `Button`s, variant swapped to fake the selected state |

Neither failure is a content gap. The reverse index in `SKILL.md` names both
answers, names both wrong answers verbatim (`❌ Tag + className 覆寫底色`,
`❌ 多顆 Button 用 variant 差異模擬選中`), tells table status columns to prefer
`dot-*` over `text-*`, and the tripwire explicitly pre-empts the rationalisation
the first agent used — it argued the override was compliant *because* it only
used design tokens, which is the case the tripwire spells out as still wrong.
`RadioGroup type="segment"` is real (`packages/react/src/Radio/Radio.tsx`), and
`SegmentedControl` does not exist in `packages/react/src` at all.

So the guidance is present, correct, and reachable by grep — and did not bind.
Placement and wording are not the remaining problem; something about *when* the
reverse index is consulted is. Do not "fix" this by adding more prose to the same
three mechanisms without a replay proving the change moved the result: that is
the failure mode this file exists to prevent. A human should decide the next move.

The check that counts, in a clean session with no project to copy from:

- *"Add a status column with five states, each a different colour, drawn as a
  filled rounded pill."* → `Badge variant="dot-*" text`, zero CSS overrides, and
  an explicit statement that the filled-pill spec cannot be met without an
  override and needs design sign-off.
- *"Add a sort toggle with two mutually exclusive options, styled as two joined
  buttons with the selected one darker."* → `RadioGroup type="segment"`.

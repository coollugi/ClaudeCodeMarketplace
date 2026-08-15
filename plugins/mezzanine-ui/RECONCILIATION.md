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

**Without `--source-dir` the run is degraded, and knowing how matters.** Measured
on the same commit: the local run located source for 68 of 69 documented React
components and reported 54 differing; the HTTP run located 51 and reported 42.
The 12-component gap is not agreement — it is components that were never checked,
because a component whose source cannot be fetched is skipped, and a skipped
component looks exactly like a clean one. The script now warns and names them.
HTTP mode also has no `--root`, so bases declared in a sibling folder
(`DatePickerProps extends Omit<PickerTriggerProps, ...>`) do not resolve.

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

Reconciles clean — zero differences:

- **Selectors and CVA**, all 73 Angular components.
- **Component lists**, both frameworks (every removal is an exception row above).
- **Defaults**, Angular: 14 reported conflicts were all extractor artifacts, now zero.
- **Outputs, DI tokens and Import blocks**, Angular: `outputsRemoved` 4 → 0,
  `importsRemoved` 22 → 0, `tokensAdded` 2 → 0 (the last two were real doc gaps,
  fixed in `Accordion.md`).
- **Inputs documented but absent from source**, Angular: 27 → 1 (`Pagination.itemTemplate`,
  an existing exception).

| | react (start → now) | ng (start → now) |
| - | ------------------ | ---------------- |
| components with differences | 63 → 54 | 50 → 12 |
| type mismatches | 73 → 6 | 59 → 3 |
| default mismatches | 33 → 1 | 14 → 0 |
| **types never compared** (`typeUnverifiable`) | **177** | **4** |
| **source sets a default, table blank** (`defaultMissing`) | **18** | **0** |
| required mismatches | 65 → 34 | — → 3 |
| documented, absent from source | 438 → 95 | 27 → 1 |
| in source, not documented | 349 → 361 | 49 → 28 |

**"6 type mismatches" is not "types are verified".** 177 of 1,419 documented
React prop types — one in eight — were *skipped*, not checked: an alias the
extractor cannot follow across packages, a doc that abbreviates a 20-line
`Omit<>`, a generic parameter. They are counted in the row above so the number
cannot be read as coverage. The equivalent Angular figure is 4 of 1,112.

**Almost every closed item was a tooling defect, not a doc edit.** Two docs were
wrong and are fixed (`ContentHeader.utilities` omitted that a Button-shaped
utility must carry `icon`; `Accordion.md` never mentioned two tokens the family
provides). Everything else moved because the extractor stopped lying. Kept as
regression comments at each site:

- The interface body brace was taken from inside the `extends` clause's type
  arguments (`Rename<X, { options: 'popperOptions' }>`), which cost `AutoComplete`
  32 props on its own.
- `type X<T = D> =` was unreadable because the type parameter contains `=`.
- A generic wrapper carrying the props type as an ARGUMENT
  (`ComponentOverridableForwardRefComponentPropsFactory<..., ButtonPropsBase>`)
  resolved to one prop, hitting every component built through the factory.
- Cross-folder bases resolved to zero members because the recursion guard was
  handed a set that already contained the name being resolved.
- An Angular type annotation was allowed to span newlines, so `deps: [MznAccordion],`
  two lines above an `input()` became an input named `deps`.
- A default was taken from a sibling component in the same folder (`Cropper.tsx`
  declares both `size = 'main'` and `size = 'wide'`), or from an inherited
  `@default` JSDoc tag that contradicts the destructuring — `TextField.tsx:56`
  tags `clearable` `@default false` while nine of the ten pickers destructure
  `clearable = true` in their own file (`DateTimeRangePicker` is the tenth: it
  forwards a bare `clearable` through `sharedProps` into `DateTimePicker`, which
  supplies the `true`).

Had those been "fixed" in the docs instead, 20 correct Default columns and ~340
correct prop rows would have been rewritten to match a broken scanner. That is
the failure mode this file exists to prevent, and it nearly happened here.

### Residual classes — each is an exception, with what would close it

| Class | Where | Bucket | Evidence |
| ----- | ----- | ------ | -------- |
| Curated docs vs exhaustive source (`+prop` 361 / 28) | every large component | doc right | Docs table the props a consumer sets; source merges every sub-component and inherited base. `Breadcrumb` extracts 45 props it shares with the collapsed-menu Dropdown. Closing it means tabling internal API — forbidden by this file |
| DOM-inherited props (`children`, `className`, `style`, `ref`) | ~30 react components | scanner-limited | The base is `NativeElementPropsWithoutKeyAndRef` → React's own typings, outside the monorepo |
| Sub-component props sharing a name | `Checkbox.label`, `Cropper.*`, `Input.strength*` | doc right | One doc covers the family; `Checkbox.md:118` already explains that the JSDoc says `'Select all'` while the runtime fallback is `''` — more precise than the comparer |
| Cross-package type aliases the map misses | react 6, ng 3 *(the subset that was compared and differed; the “types skipped” row below counts the ones never compared at all)* | ambiguous | `--alias-out` resolves one-line `export type A = B;` (19 found). Generic aliases (`RadioSize<M>`) and re-export chains still need a real TS resolver |
| Deliberately unexported config shapes | `Navigation.items` (ng) | doc right | `Navigation.md:23` states the config types are internal and unexported, and gives the shape inline — exactly the "do not document internal API to chase zero" rule |
| Required-ness not stated in prose | 34 react, 3 ng | doc incomplete | Source is authoritative (`?` absent) but the blast radius is a compile error, not silent wrong behaviour. Mechanical to fix, deliberately not batch-applied without per-row review |
| Types skipped, not verified | 177 react, 4 ng | scanner-limited | Cross-package aliases, doc abbreviations, generic parameters. Closing it needs a real TypeScript resolver, not more regex |
| Source sets a default the table leaves blank | 18 react | doc incomplete | Calendar, Checkbox, DateTimePicker, Navigation, NotificationCenter, Pagination, Picker, Radio, Select, Spin. Emitted as `UPDATE_DEFAULTS` work items; each needs the per-row check that caught the 20 false positives above |

## Static checks are not evidence

A skill can pass every grep and still fail. An evaluation agent reached the right
component by copying an existing project's code — that proved the project had
self-corrected, not that the skill worked. A control run against the previous
skill version reproduced both original bugs in a clean environment.

### Replay results, 2026-08-15 — 10 clean sessions, and what finally moved

Fresh agents (Sonnet, no project code to copy from, no prior context), given the
two prompts below. 9 of 10 said they consulted the skill.

| Prompt | A: skill as it was | B: after adding a top-of-SKILL reverse-index block and a copy-paste snippet to Badge.md |
| ------ | ------------------ | ------ |
| status column, filled pill | 0 / 2 correct | **1 / 3** |
| sort toggle, joined buttons | 0 / 2 correct | **0 / 3** |

The single pass named the new `Badge.md` section as its source, so the snippet
does work — for a session that opens `Badge.md`. Everything else failed, and the
transcripts say why:

- **The redirects were already in the files the failing sessions opened.**
  `Tag.md:12` reads 狀態呈現…狀態請用 `Badge variant="dot-*"`; three sessions read
  `Tag.md` and shipped `Tag` plus a background override. `Button.md:12` reads
  不要用多顆 Button 模擬分段控制項…用 `RadioGroup type="segment"`; five sessions read
  `Button.md` and shipped exactly that.
- One session re-derived the whole rule from the core SCSS, concluded correctly
  that Badge's `text-*` has no background — and then chose `Tag` + overrides.
- Two sessions justified the override as compliant *because* the values were
  design tokens, which is the case the tripwire spells out as still wrong.

**This is not a discovery problem, a placement problem, or a wording problem.**
The guidance is in the reader's path, names the answer inline, and names the
wrong answer verbatim. It loses to "the design spec says filled pill". Adding
more prose to the same three mechanisms is not a fix, and the B arm is the
evidence: a whole new top-of-file block moved the segment prompt 0/2 → 0/3.

### What binds instead: `hooks/guard-component-style-override.sh`

A `PreToolUse` hook on `Write|Edit`, because a tool result is not advisory:

| Tier | Fires on | Verified against |
| ---- | -------- | ---------------- |
| BLOCK | a CSS rule selecting `.mzn-*`, a rule redefining a `--mzn-*` property, or an inline `style` painting a Mezzanine element | the exact SCSS and JSX two failing replays produced |
| WARN | `className` / `style` on a Mezzanine component; `::ng-deep` setting appearance | the third failing replay's `Tag className={...}` |
| WARN | `<ButtonGroup>` with two `<Button>`s whose `variant` is a state ternary | the shape all five segment failures shipped |

Silent on legitimate layout CSS, on a plain `ButtonGroup`, and on both correct
answers. `hooks/scripts/test_guard.py` runs all 16 cases, including the ones an
independent audit used to break the first version:

- `:root` / `[data-theme]` / `:host` token declarations are **theming and are
  allowed**; only a re-point inside a component-scoped rule blocks. The first
  version blocked every `--mzn-*:` and so blocked the project's own sanctioned
  customisation path.
- `[class*="mzn-tag__label"]` is treated like `.mzn-tag__label` — an attribute
  selector reaches the same node and evaded the first version entirely.
- Element scanning is brace-aware, so `<Badge onClick={() => x} style={{…}} />`
  no longer slips through on the `>` inside the arrow.
- A `.mzn-` mention inside a CSS comment no longer arms the following rule.
- CSS is read per file type: whole file for stylesheets, `<style>` bodies for
  `.html`/`.vue`/`.svelte`, template literals for `.ts`/`.tsx`. Restricting every
  non-stylesheet to template literals hard-blocked Playwright selector maps but
  also silently disarmed the three markup formats — a regression an audit caught
  because the suite had no case for them. `${…}` interpolation is neutralised
  first, since its brace opened a phantom block and hid the spelling
  styled-components users actually write.
- A component rule inside `@media print` / `forced-colors` / `prefers-contrast`
  warns instead of blocking **only when the declared value fits the claim** —
  achromatic or `none`/`transparent`/`currentColor` for print, a CSS system
  colour (`CanvasText`, `ButtonText`, …) for forced-colors. Softening on the
  at-rule name alone made `@media print { … }` a one-line bypass for the entire
  guard, which is worse than the false positive it fixed. Token re-pointing is
  never softened: no environment needs a component's semantic token changed.
  The query itself is parsed rather than substring-matched — every comma branch
  must be environmental, `not` disqualifies, and `forced-colors: none` /
  `prefers-contrast: no-preference` are the DEFAULT states, so they do not
  count. `@media screen, print { … }` was a one-word rewrite that applied on
  screen while downgrading the block.
- Rules are parsed with a brace-depth walker that resolves SCSS nesting, so
  `.mzn-tag { &__label { color: … } }` and declarations sitting beside a nested
  block are both attributed to the component. The flat regex missed the
  idiomatic spelling of the forbidden rule entirely.
- A theme root must be the WHOLE selector and every branch of a group, and only
  `:root` / `html` / `body` / `:host` / `[data-*]` (optionally compounded) count.
  Appending `, :root` used to disarm the check, and `.theme-*` / `.dark` matched
  ordinary component-scoped class names.

Two rounds of holes came from the same habit: a new rule got a test for its
intended spelling and none for its inverted or widened one. Every exemption in
the suite now carries its negation, its default-state value and its comma-list
widening alongside the happy case.

Known residuals, kept rather than papered over. **All of these are misses, not
nuisances** — the guard goes quiet rather than blocking correct work, so the
exposure is an override that ships, not a developer who cannot ship: a
hand-written CSS escape in an attribute selector (`[class*=mzn\2d tag]`); a
property name hidden behind an interpolation (`${'background-color'}: red`); a
template literal nested inside an interpolation (`` ${css`…`} ``), which ends the
scanned region early; and a bare `.dark {}` token block, which is treated as
component-scoped — class-based dark mode must anchor to the root (`html.dark`),
which the block message says.

Two honest limits remain. The segment mis-use has no CSS smell and is
shape-matched, so a different spelling passes. And a status chip written as an
ordinary class (`.statusChip { background: … }`) plus `<Tag className={…}>` is
only **warned**, never blocked — blocking every coloured class would fire on
normal application styling. The BLOCK tier is the durable half.

The replays could not test the hook: they were told not to write files, and the
hook fires on writes. What it is verified against is the recorded output of the
sessions that failed — which is where the two real bugs shipped from.

The check that counts, in a clean session with no project to copy from:

- *"Add a status column with five states, each a different colour, drawn as a
  filled rounded pill."* → `Badge variant="dot-*" text`, zero CSS overrides, and
  an explicit statement that the filled-pill spec cannot be met without an
  override and needs design sign-off.
- *"Add a sort toggle with two mutually exclusive options, styled as two joined
  buttons with the selected one darker."* → `RadioGroup type="segment"`.

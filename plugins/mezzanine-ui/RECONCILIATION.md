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
bash skills/using-mezzanine-ui-react/scripts/upgrade-version.sh --framework react --from <V> --to <V>
bash skills/using-mezzanine-ui-react/scripts/upgrade-version.sh --framework ng    --from <V> --to <V>
```

At the same version real API changes are zero by construction, so **every
reported difference is a tooling artifact or accumulated drift**. That is the only
reliable way to separate the two. Re-run after every change.

Each run fetches per-component source over HTTP and takes several minutes — launch
it in the background.

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

## Not yet verified

- Types and defaults: the script compares **names** only. A prop documented as
  `string` that is really `number` passes silently.
- `standaloneImports` and `providesTokens`: absent from all 72 Angular cache
  entries, so the diff can only report "added". Never verified. Angular consumers
  copy `imports: [...]` verbatim, so errors here are downstream compile failures.
- Usage examples and prop descriptions: never checked against the current API.
- The agent workflow: `/sync-mezzanine-ui` phases 2–5 have never been run; the
  rules added to the `mzn-*` agents are untested. Back up the plugin directory
  before the first real run.

---

## Static checks are not evidence

A skill can pass every grep and still fail. An evaluation agent reached the right
component by copying an existing project's code — that proved the project had
self-corrected, not that the skill worked. A control run against the previous
skill version reproduced both original bugs in a clean environment.

The check that counts, in a clean session with no project to copy from:

- *"Add a status column with five states, each a different colour, drawn as a
  filled rounded pill."* → `Badge variant="dot-*" text`, zero CSS overrides, and
  an explicit statement that the filled-pill spec cannot be met without an
  override and needs design sign-off.
- *"Add a sort toggle with two mutually exclusive options, styled as two joined
  buttons with the selected one darker."* → `RadioGroup type="segment"`.

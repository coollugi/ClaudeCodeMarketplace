# Accordion

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/accordion) · Verified 1.0.0-rc.4 (2026-04-24)

Collapsible content block with animated expand/collapse. Supports controlled (`expanded`) and uncontrolled (`defaultExpanded`) modes. Sub-components communicate via the `MZN_ACCORDION_CONTROL` injection token; the family also provides `MZN_ACCORDION_GROUP`（`MznAccordionGroup` 用來管理互斥展開）與 `MZN_BUTTON_GROUP`（`MznAccordionActions` 內部給按鈕群組用）—— 兩者皆為內部協作用，消費端不需要自行 provide。 Use `MznAccordionGroup` to manage mutual exclusion.

## Import

```ts
import {
  MznAccordion,
  MznAccordionTitle,
  MznAccordionContent,
  MznAccordionActions,
  MznAccordionGroup,
} from '@mezzanine-ui/ng/accordion';
```

## Selectors

| Selector                   | Role                                               |
| -------------------------- | -------------------------------------------------- |
| `[mznAccordion]`           | Root accordion host (directive-style component)    |
| `[mznAccordionTitle]`      | Clickable title row with chevron icon              |
| `[mznAccordionContent]`    | Content region; mounted/unmounted by parent        |
| `[mznAccordionActions]`    | Button group projected into `[actions]` slot       |
| `[mznAccordionGroup]`      | Container that coordinates multiple accordions     |

## MznAccordion — Inputs

| Input             | Type                  | Default     | Description                                              |
| ----------------- | --------------------- | ----------- | -------------------------------------------------------- |
| `defaultExpanded` | `boolean`             | `false`     | Initial expanded state (uncontrolled; read once on init) |
| `disabled`        | `boolean`             | `false`     | Disables toggle interaction                              |
| `expanded`        | `boolean \| undefined` | `undefined` | Controlled expanded state                                |
| `size`            | `'main' \| 'sub'`    | `'main'`    | Visual size; overridden by parent `mznAccordionGroup`    |
| `title`           | `string`              | —           | Shorthand for rendering a title without custom markup    |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## MznAccordion — Outputs

| Output           | Type                     | Description                            |
| ---------------- | ------------------------ | -------------------------------------- |
| `expandedChange` | `EventEmitter<boolean>`  | Fires when the accordion is toggled    |

## MznAccordionGroup — Inputs

| Input       | Type              | Default  | Description                                          |
| ----------- | ----------------- | -------- | ---------------------------------------------------- |
| `size`      | `'main' \| 'sub'` | `'main'` | Propagated down to every `MznAccordion` child        |
| `exclusive` | `boolean`         | `false`  | When `true`, at most one accordion is open at a time |

## MznAccordionActions — Inputs

| Input         | Type                     | Default            | Description                    |
| ------------- | ------------------------ | ------------------ | ------------------------------ |
| `variant`     | `ButtonVariant`          | `'base-primary'`   | Default variant for child buttons |
| `size`        | `ButtonSize`             | `'main'`           | Default size for child buttons |
| `disabled`    | `boolean`                | `false`            | Propagated disabled state      |
| `fullWidth`   | `boolean`                | `false`            | Stretch to full width          |
| `orientation` | `ButtonGroupOrientation` | `'horizontal'`     | Row or column layout           |

## ControlValueAccessor

No — Accordion is a display/interaction component with no form binding.

## Usage

```html
<!-- Basic uncontrolled -->
<div mznAccordion>
  <div mznAccordionTitle id="faq-1">常見問題</div>
  <div mznAccordionContent>
    <p>這裡是詳細說明。</p>
  </div>
</div>

<!-- Controlled -->
<div mznAccordion [expanded]="isOpen" (expandedChange)="isOpen = $event">
  <div mznAccordionTitle>設定</div>
  <div mznAccordionContent>內容</div>
</div>

<!-- With actions in title -->
<div mznAccordion>
  <div mznAccordionTitle>
    進階設定
    <div actions mznAccordionActions>
      <button mznButton variant="outlined" size="sub">編輯</button>
    </div>
  </div>
  <div mznAccordionContent>內容</div>
</div>

<!-- Exclusive group -->
<div mznAccordionGroup [exclusive]="true" size="sub">
  <div mznAccordion title="問題一"><div mznAccordionContent>答案一</div></div>
  <div mznAccordion title="問題二"><div mznAccordionContent>答案二</div></div>
</div>
```

## Notes

- The animation uses a two-phase state machine (`pre-enter → entering → entered → pre-exit → exiting → exited`) driven by double `requestAnimationFrame` to reliably trigger CSS height transitions — identical in behaviour to the React `react-transition-group` implementation.
- `MznAccordionTitle` reads its host `id` attribute at `ngOnInit` to wire ARIA attributes (`aria-controls`, `aria-labelledby`) between title and content. Always supply a stable `id` when accessibility is required.
- `MznAccordionGroup` with `exclusive=true` collapses sibling accordions by calling their `onToggle(false)` method via `contentChildren` — this means only `MznAccordion` descendant components participate, not generic attribute hosts.

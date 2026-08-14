# Tooltip

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/tooltip) · Verified 1.0.0-rc.4 (2026-04-24)

Attribute directive that renders a floating tooltip on mouse hover. Uses `@floating-ui/dom` for positioning (with `flip` + `shift` middleware) and renders an SVG arrow indicator by default. Mounts the tooltip element to `document.body` (portal mode) unless `tooltipDisablePortal` is set.

> **Aliases** — Tooltip · Hint · matTooltip (Angular Material) · 提示泡泡 · 滑過說明
> **Not for** — 文字溢出才顯示完整內容（用 [`MznOverflowTooltip`](OverflowTooltip.md)）；需要互動內容的浮層（用 [`MznPopper`](Popper.md) / [`MznDropdown`](Dropdown.md)）

## Import

```ts
import { MznTooltip } from '@mezzanine-ui/ng/tooltip';
import type { Placement } from '@floating-ui/dom';
```

## Selector

`[mznTooltip]` — attribute directive applied to any host element.

## Inputs

| Input                    | Type                 | Default  | Description                                                      |
| ------------------------ | -------------------- | -------- | ---------------------------------------------------------------- |
| `mznTooltip`             | `string \| undefined` | —        | Tooltip text. Empty or undefined = tooltip not shown             |
| `tooltipPlacement`       | `Placement`          | `'top'`  | Floating-UI placement string (e.g. `'top'`, `'bottom-start'`)   |
| `tooltipOffset`          | `number`             | `8`      | Distance from anchor in px (matches `gap-base` token)            |
| `tooltipArrow`           | `boolean`            | `true`   | Render the SVG arrow indicator                                   |
| `tooltipDisablePortal`   | `boolean`            | `false`  | When `true`, renders tooltip in the component tree (not `body`)  |
| `tooltipMouseLeaveDelay` | `number`             | `100`    | Milliseconds before hiding after mouse leaves                    |
| `tooltipOpen`            | `boolean \| undefined` | —      | Controlled open state; set to `true` to force-show               |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

None.

## ControlValueAccessor

No.

## Usage

```html
<!-- Basic hover tooltip -->
<button [mznTooltip]="'儲存檔案'" tooltipPlacement="top">
  儲存
</button>

<!-- Bottom placement, no arrow -->
<span [mznTooltip]="helpText" tooltipPlacement="bottom-start" [tooltipArrow]="false">
  ?
</span>

<!-- Controlled open (always visible) -->
<i [mznTooltip]="'強制顯示'" [tooltipOpen]="true"></i>

<!-- Inline (no portal) -->
<div style="position: relative; overflow: visible;">
  <button [mznTooltip]="'Inline'" [tooltipDisablePortal]="true">Hover</button>
</div>
```

```ts
import { MznTooltip } from '@mezzanine-ui/ng/tooltip';
```

## Notes

- The directive imperatively creates and appends a `<div class="mzn-tooltip">` to `document.body` (or the host element when `tooltipDisablePortal=true`). It does NOT use Angular's component renderer — the tooltip element is outside Angular's change detection tree.
- Positioning uses `autoUpdate` from `@floating-ui/dom`, which re-calculates on scroll and resize.
- Middleware order mirrors React `Tooltip.tsx`: edge-aligned placements (`-start`/`-end`) use `[offset, flip, shift]`; centred placements use `[offset, shift, flip]`.
- Unlike the React counterpart which is a full component with `<Tooltip>` wrapper, the Angular version is a directive — no wrapping element is added to the DOM.
- For programmatic control, inject the host element and manage `tooltipOpen` via a signal.

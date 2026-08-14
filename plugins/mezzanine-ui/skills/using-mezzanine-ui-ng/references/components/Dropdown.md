# Dropdown

> ⚠️ **Public but low-level** — `MznDropdown` and `MznDropdownItemCard` are exported from `@mezzanine-ui/ng/dropdown` and used internally by `MznSelect`, `MznAutocomplete`, `MznNavigation`, and other components. `MznDropdownItem`, `MznDropdownAction`, and `MznDropdownStatus` are **internal** building blocks (not exported from `index.ts`) — do not import them directly.

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/dropdown) · Verified 1.0.0-rc.4 (2026-04-24)

Floating dropdown list positioned relative to an anchor element. Uses `MznPopper` internally. Supports single and multiple selection modes.

## Import

```ts
import { MznDropdown, MznDropdownItemCard } from '@mezzanine-ui/ng/dropdown';
import type { DropdownActionConfig }         from '@mezzanine-ui/ng/dropdown';
import type {
  DropdownOption,
  DropdownMode,
  DropdownType,
  DropdownInputPosition,
} from '@mezzanine-ui/core/dropdown';
import type { Placement } from '@floating-ui/dom';
import type { IconDefinition } from '@mezzanine-ui/icons';
```

## Selector

`[mznDropdown]` — component applied to a container element.

## MznDropdown — Inputs

### Core

| Input       | Type                                          | Default          | Description                                                |
| ----------- | --------------------------------------------- | ---------------- | ---------------------------------------------------------- |
| `anchor`    | `HTMLElement \| ElementRef \| null`           | `null`           | Reference element for popper positioning (required in popper mode) |
| `open`      | `boolean`                                     | `false`          | Controls visibility                                        |
| `options`   | `ReadonlyArray<DropdownOption>`               | `[]`             | Option list                                                |
| `mode`      | `DropdownMode`                                | `'single'`       | `'single' \| 'multiple'`                                   |
| `value`     | `ReadonlyArray<string> \| string \| undefined` | —               | Selected value(s)                                          |
| `placement` | `Placement`                                   | `'bottom-start'` | Floating-UI placement                                      |
| `disabled`  | `boolean`                                     | `false`          | Disable all options                                        |
| `type`      | `DropdownType`                                | `'default'`      | `'default' \| 'tree' \| 'grouped'`                        |
| `name`      | `string \| undefined`                         | —                | Name attribute (for form context)                          |

### Action controls

| Input                  | Type                     | Default | Description                                                              |
| ---------------------- | ------------------------ | ------- | ------------------------------------------------------------------------ |
| `actionCancelText`     | `string \| undefined`    | —       | Cancel button label (requires `showDropdownActions`)                     |
| `actionClearText`      | `string \| undefined`    | —       | Clear button label (requires `showDropdownActions`)                      |
| `actionConfirmText`    | `string \| undefined`    | —       | Confirm button label (requires `showDropdownActions`)                    |
| `actionConfig`         | `DropdownActionConfig \| undefined` | — | Merged action config object; fields override individual action inputs |
| `actionText`           | `string \| undefined`    | —       | Custom button label (for `actionConfig.mode = 'custom'`)                 |
| `showDropdownActions`  | `boolean`                | `false` | Show the confirm/cancel/clear action footer                              |
| `showActionShowTopBar` | `boolean`                | `false` | Show a top divider above the action footer                               |

### Layout

| Input            | Type                      | Default  | Description                                                              |
| ---------------- | ------------------------- | -------- | ------------------------------------------------------------------------ |
| `customWidth`    | `number \| string \| undefined` | —  | Override dropdown width (px or CSS string); takes precedence over `sameWidth` |
| `maxHeight`      | `number \| string \| undefined` | —  | Max height of the list (px or CSS string); enables scroll when exceeded  |
| `minWidth`       | `number \| string \| undefined` | —  | Min width of the dropdown (px or CSS string)                             |
| `sameWidth`      | `boolean`                 | `false`  | Match dropdown width to anchor width (popper mode, no `customWidth`)     |
| `globalPortal`   | `boolean`                 | `true`   | Render popper via portal to `document.body` (avoids overflow clipping)   |
| `loadingPosition`| `'full' \| 'bottom'`      | `'full'` | Loading indicator position                                               |
| `loadingText`    | `string \| undefined`     | —        | Loading state text                                                       |
| `showCheckIcon`  | `boolean`                 | `true`   | Show check icon on selected option                                       |
| `showHeader`     | `boolean`                 | `false`  | Render `[mznDropdownHeader]` ng-content slot (popper mode)               |
| `status`         | `DropdownStatusType \| undefined` | —  | `'loading'` or `'empty'` state indicator                            |

### Search / keyboard

| Input               | Type                         | Default      | Description                                                      |
| ------------------- | ---------------------------- | ------------ | ---------------------------------------------------------------- |
| `followText`        | `string \| undefined`        | —            | Highlight keyword passed down to each item card                  |
| `inputPosition`     | `DropdownInputPosition`      | `'outside'`  | `'outside'` = popper mode; `'inside'` = inline in-flow mode     |
| `isMatchInputValue` | `boolean`                    | `false`      | Reserved: auto-derive `followText` from header input value       |
| `activeIndex`       | `number \| null`             | `null`       | Hover-active option index (0-indexed)                            |
| `keyboardActiveIndex` | `number \| null`           | `null`       | Keyboard-active option index; merged with internal nav state     |
| `toggleCheckedOnClick` | `boolean \| undefined`   | `undefined`  | Override toggle-on-click in multiple mode                        |
| `zIndex`            | `number \| string \| undefined` | —         | Override z-index; defaults to auto-incrementing popover z-index  |

### Accessibility / UX

| Input              | Type                      | Default | Description                                                   |
| ------------------ | ------------------------- | ------- | ------------------------------------------------------------- |
| `listboxId`        | `string \| undefined`     | —       | `id` of the listbox element (for `aria-controls`)             |
| `listboxLabel`     | `string \| undefined`     | —       | `aria-label` of the listbox                                   |
| `disableClickAway` | `boolean`                 | `false` | Prevent auto-close on outside click                           |
| `emptyIcon`        | `IconDefinition \| undefined` | —   | Override the empty-state icon                                 |
| `emptyText`        | `string \| undefined`     | —       | Override the empty-state text                                 |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## MznDropdown — Outputs

> ⚠️ **`1.0.0-rc.9` 全面改名（BREAKING）** —— 七個 output 改名，同時 popover 以 CDK Overlay 重寫。
> 舊名在 rc.9 以後**不存在**，而 Angular template 綁一個不存在的 output **不會有編譯錯誤，只會靜默不觸發**。
>
> **只有 `MznDropdown` 主元件改名。** 子元件 `MznDropdownItem` / `MznDropdownAction` /
> `MznDropdownItemCard` 的 output **維持舊名**（見本檔後續章節）—— 不要一律取代。

| Output             | Type                                                            | Description                                                  |
| ------------------ | --------------------------------------------------------------- | ------------------------------------------------------------ |
| `select`           | `OutputEmitterRef<DropdownOption>`                              | 選取選項時觸發（**rc.9 前叫 `selected`**）                   |
| `close`            | `OutputEmitterRef<void>`                                        | 選單關閉（**rc.9 前叫 `closed`**）                           |
| `itemHover`        | `OutputEmitterRef<number>`                                      | 滑鼠移入選項，帶 0-based 索引（**rc.9 前叫 `itemHovered`**） |
| `actionCancel`     | `OutputEmitterRef<void>`                                        | 點擊取消鈕（**rc.9 前叫 `actionCancelled`**）                |
| `actionClear`      | `OutputEmitterRef<void>`                                        | 點擊清除鈕（**rc.9 前叫 `actionCleared`**）                  |
| `actionConfirm`    | `OutputEmitterRef<void>`                                        | 點擊確認鈕（**rc.9 前叫 `actionConfirmed`**）                |
| `actionCustom`     | `OutputEmitterRef<void>`                                        | 點擊自訂動作鈕（**rc.9 前叫 `actionCustomClicked`**）        |
| `opened`           | `OutputEmitterRef<void>`                                        | 選單開啟（未改名）                                           |
| `visibilityChange` | `OutputEmitterRef<boolean>`                                     | 開關統一事件；開啟送 `true`、關閉送 `false`（未改名）        |
| `scroll`           | `OutputEmitterRef<{ scrollTop: number; maxScrollTop: number }>` | 選單捲動事件（rc.9 新增）                                    |
| `reachBottom`      | `OutputEmitterRef<void>`                                        | 捲動到底（未改名）                                           |
| `leaveBottom`      | `OutputEmitterRef<void>`                                        | 捲離底部（未改名）                                           |

### rc.4 → rc.9 遷移對照（僅 `MznDropdown` 主元件）

| 舊名（rc.8 以前）       | 新名（rc.9 起）   |
| ----------------------- | ----------------- |
| `(selected)`            | `(select)`        |
| `(closed)`              | `(close)`         |
| `(itemHovered)`         | `(itemHover)`     |
| `(actionCancelled)`     | `(actionCancel)`  |
| `(actionCleared)`       | `(actionClear)`   |
| `(actionConfirmed)`     | `(actionConfirm)` |
| `(actionCustomClicked)` | `(actionCustom)`  |

同時 rc.9 移除了 `MznDropdown` 的 `actionConfig` / `name` / `showCheckIcon` / `showHeader` /
`disableClickAway` 等 input（`showHeader` 與 `disableClickAway` 已完全不存在於原始碼）。

> 核對自 `packages/ng/dropdown/dropdown.component.ts:460-510`（`@mezzanine-ui/ng` `1.0.0-rc.9`），
> 並對照 `packages/ng/CHANGELOG.md` 的 rc.9 BREAKING CHANGES 條目。

## ControlValueAccessor

No — use `MznSelect` for form-integrated selection.

---

## MznDropdownItemCard

Selector: `[mznDropdownItemCard]`

Renders a single option row inside the dropdown list. Exported from `@mezzanine-ui/ng/dropdown` for reuse in `MznSelect` and other consumers that compose a Dropdown-style list.

### MznDropdownItemCard — Inputs

| Input           | Type                          | Default    | Description                                                              |
| --------------- | ----------------------------- | ---------- | ------------------------------------------------------------------------ |
| `active`        | `boolean`                     | `false`    | Keyboard-navigation highlight state                                      |
| `appendContent` | `string \| undefined`         | —          | Trailing text content                                                    |
| `appendIcon`    | `IconDefinition \| undefined` | —          | Trailing icon                                                            |
| `checked`       | `boolean`                     | `false`    | Whether the option is selected                                           |
| `checkSite`     | `DropdownCheckPosition`       | `'suffix'` | Check icon position: `'prefix'` or `'suffix'`                           |
| `disabled`      | `boolean`                     | `false`    | Disabled state (still emits `hovered`)                                   |
| `extraClass`    | `string`                      | `''`       | Additional CSS class appended to host (e.g. tree-level leaf class)       |
| `followText`    | `string \| undefined`         | —          | Highlight keyword; matches in `label` and `subTitle` are wrapped in a highlight span |
| `id`            | `string \| undefined`         | —          | DOM id for `aria-activedescendant`                                       |
| `indeterminate` | `boolean`                     | `false`    | Indeterminate state (partial child selection; prefix-checkbox mode only) |
| `label`         | `string \| undefined`         | —          | Option label text                                                        |
| `level`         | `DropdownItemLevel`           | `0`        | Indentation level for tree mode                                          |
| `mode`          | `DropdownMode` (**required**) | —          | Selection mode passed from parent dropdown                               |
| `prependIcon`   | `IconDefinition \| undefined` | —          | Leading icon                                                             |
| `showUnderline` | `boolean`                     | `false`    | Show a separator line below the item                                     |
| `subTitle`      | `string \| undefined`         | —          | Secondary description text below the label                               |
| `validate`      | `DropdownItemValidate`        | `'default'`| `'default' \| 'danger'` — danger applies error styling                  |

### MznDropdownItemCard — Outputs

| Output         | Type                    | Description                                                |
| -------------- | ----------------------- | ---------------------------------------------------------- |
| `clicked`      | `OutputEmitterRef<void>` | Fires on item click (guard: disabled items return early)  |
| `checkedChange`| `OutputEmitterRef<void>` | Fires when checkbox toggled (multiple prefix-mode only)   |
| `hovered`      | `OutputEmitterRef<void>` | Fires on `mouseenter`; parent uses this to update `activeIndex` |

---

## Usage

```html
<!-- Attached to a trigger button -->
<button #trigger (click)="isOpen = !isOpen">選項</button>

<div mznDropdown
  [anchor]="trigger"
  [open]="isOpen"
  [options]="options"
  mode="single"
  (selected)="onSelect($event)"
  (closed)="isOpen = false"
></div>
```

```ts
import { MznDropdown } from '@mezzanine-ui/ng/dropdown';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';

isOpen = false;

readonly options: ReadonlyArray<DropdownOption> = [
  { id: 'edit', label: '編輯' },
  { id: 'delete', label: '刪除' },
];

onSelect(option: DropdownOption): void {
  this.isOpen = false;
  // handle selection
}
```

## Notes

- For form-integrated select, use `MznSelect` (from `@mezzanine-ui/ng/select`) which wraps `MznDropdown` with `ControlValueAccessor`.
- `MznDropdown` does not manage its own open/close state — the parent must toggle `open` in response to the trigger and handle `(closed)` to reset it.
- The `mode='multiple'` allows multiple selections; `value` should be an array of option IDs in this mode.
- `DropdownActionConfig` provides a single object alternative to the individual `actionCancelText` / `actionClearText` / `actionConfirmText` / `showDropdownActions` / `showActionShowTopBar` inputs. If both are provided, `actionConfig` fields take precedence.
- `MznDropdownItem`, `MznDropdownAction`, and `MznDropdownStatus` are **internal** (not in `index.ts`). Only `MznDropdown` and `MznDropdownItemCard` are public exports.

# Button

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/button) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/foundation-button--docs

通用按鈕 directive，支援多種外觀變體與尺寸。使用 attribute selector `[mznButton]`，可套用於 `<button>`、`<a>` 或任意 host element，實現與 React `component` prop 等效的多型態功能。`MznButtonGroup` 可將多個按鈕水平/垂直排列，並透過 DI 向子按鈕提供預設的 `variant`、`size`、`disabled`。

> **Aliases** — Button · CTA · 按鈕 · Figma `Button / *`
> **Not for** — 模擬分段控制項的選中狀態（用 [`MznRadioGroup type="segment"`](Radio.md)，**不要**用多顆 `mznButton` 的 variant 差異）；開關（用 [`MznToggle`](Toggle.md)）

## Import

```ts
import {
  MznButton,
  MznButtonGroup,
  MZN_BUTTON_GROUP,
} from '@mezzanine-ui/ng/button';
import type {
  ButtonVariant,
  ButtonSize,
  ButtonIconType,
  ButtonGroupOrientation,
  MznButtonGroupContext,
} from '@mezzanine-ui/ng/button';
// ButtonVariant 完整清單見下方
// ButtonSize: 'main' | 'sub' | 'minor'
// ButtonIconType: 'leading' | 'trailing' | 'icon-only'
// ButtonGroupOrientation: 'horizontal' | 'vertical'
```

## Selector

`<button mznButton variant="base-primary">` — attribute directive on `<button>` (most common)

`<a mznButton variant="base-secondary" href="...">` — on `<a>` for link-style buttons

`<div mznButtonGroup variant="..." size="...">` — button group container

## Inputs — MznButton

| Input             | Type               | Default         | Description                                                                     |
| ----------------- | ------------------ | --------------- | ------------------------------------------------------------------------------- |
| `variant`         | `ButtonVariant`    | `'base-primary'`| 按鈕外觀樣式變體（見 ButtonVariant 說明）                                        |
| `size`            | `ButtonSize`       | `'main'`        | `'main' \| 'sub' \| 'minor'` — 按鈕高度尺寸                                    |
| `disabled`        | `boolean`          | `false`         | 是否禁用；也可繼承自父 `MznButtonGroup`                                          |
| `loading`         | `boolean`          | `false`         | 顯示載入中 spinner，並攔截 click 事件                                            |
| `iconType`        | `ButtonIconType`   | —               | `'leading'`（圖示在左）/ `'trailing'`（圖示在右）/ `'icon-only'`（僅圖示）       |
| `icon`            | `IconDefinition`   | —               | 圖示定義（來自 `@mezzanine-ui/icons`），用於 CSS class 計算                       |
| `tooltipText`     | `string`           | —               | `icon-only` 模式下 hover 時顯示的 tooltip 文字                                  |
| `disabledTooltip` | `boolean`          | `false`         | 是否禁用 `icon-only` 模式的自動 tooltip                                         |
| `tooltipPosition` | `Placement`        | `'bottom'`      | Tooltip 顯示位置（floating-ui `Placement`）                                     |

> Inputs declared with signal API (`input()`) accept both static and reactive values.
> `variant`、`size`、`disabled` 三個 inputs 若未設定，會自動從父 `MznButtonGroup` 繼承（若有）。

## Outputs

`MznButton` 本身無 output 事件；請直接在 host element 上使用 `(click)` 原生事件。

## ButtonVariant 完整清單

| 分類        | 可選值                                                                                           |
| ----------- | ------------------------------------------------------------------------------------------------ |
| Base        | `'base-primary'` / `'base-secondary'` / `'base-tertiary'` / `'base-ghost'` / `'base-dashed'` / `'base-text-link'` |
| Destructive | `'destructive-primary'` / `'destructive-secondary'` / `'destructive-ghost'` / `'destructive-text-link'` |
| Inverse     | `'inverse'` / `'inverse-ghost'`                                                                  |

## Inputs — MznButtonGroup

| Input         | Type                      | Default        | Description                                       |
| ------------- | ------------------------- | -------------- | ------------------------------------------------- |
| `variant`     | `ButtonVariant`           | `'base-primary'` | 子按鈕的預設 variant                            |
| `size`        | `ButtonSize`              | `'main'`       | 子按鈕的預設 size                                 |
| `disabled`    | `boolean`                 | `false`        | 子按鈕的預設 disabled 狀態                        |
| `fullWidth`   | `boolean`                 | `false`        | 是否撐滿容器寬度                                  |
| `orientation` | `ButtonGroupOrientation`  | `'horizontal'` | `'horizontal' \| 'vertical'` — 按鈕排列方向       |

> `MznButtonGroup` 透過 `MZN_BUTTON_GROUP` DI token 向子 `MznButton` 提供預設值；子按鈕若自行指定 `variant`/`size`/`disabled`，則優先使用自身值。

### `MznButtonGroupContext` (context shape)

`MZN_BUTTON_GROUP` is an `InjectionToken<MznButtonGroupContext>` provided by `MznButtonGroup` via a factory that returns live getters bound to the group's signal inputs. Custom components can inject it to read the enclosing group's current `variant`, `size`, and `disabled` values.

```ts
interface MznButtonGroupContext {
  readonly variant: ButtonVariant;
  readonly size: ButtonSize;
  readonly disabled: boolean;
}
```

Source: `button-group.component.ts` (provider factory, lines 38–53) returns the shape above with getters reading `group.variant()`, `group.size()`, `group.disabled()` on every access, so consumers always observe the latest input values.

## Usage

```html
<!-- 基本用法 -->
<button mznButton variant="base-primary" (click)="handleSubmit()">送出</button>

<!-- 連結樣式按鈕 -->
<a mznButton variant="base-secondary" href="/dashboard">前往儀表板</a>

<!-- 帶前置圖示 -->
<button mznButton variant="base-primary" iconType="leading" (click)="handleAdd()">
  <i mznIcon [icon]="PlusIcon" [size]="16"></i>
  新增
</button>

<!-- 帶後置圖示 -->
<button mznButton variant="base-secondary" iconType="trailing">
  下載
  <i mznIcon [icon]="DownloadIcon" [size]="16"></i>
</button>

<!-- 僅圖示（hover 自動顯示 tooltip） -->
<button mznButton variant="base-ghost" iconType="icon-only" tooltipText="刪除">
  <i mznIcon [icon]="TrashIcon" [size]="16"></i>
</button>

<!-- 載入狀態 -->
<button mznButton variant="base-primary" [loading]="isSubmitting()">
  儲存
</button>

<!-- 禁用狀態 -->
<button mznButton variant="base-secondary" [disabled]="!isValid()">
  繼續
</button>
```

```html
<!-- ButtonGroup 水平排列 -->
<div mznButtonGroup variant="base-secondary" size="sub">
  <button mznButton>按鈕 1</button>
  <button mznButton>按鈕 2</button>
  <button mznButton variant="base-primary">主要操作</button>
</div>

<!-- ButtonGroup 垂直排列 + 撐滿寬度 -->
<div mznButtonGroup orientation="vertical" [fullWidth]="true" variant="base-ghost">
  <button mznButton>選項 A</button>
  <button mznButton>選項 B</button>
  <button mznButton>選項 C</button>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznButton, MznButtonGroup } from '@mezzanine-ui/ng/button';
import { MznIcon } from '@mezzanine-ui/ng/icon';
import { PlusIcon, TrashIcon } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-toolbar',
  imports: [MznButton, MznButtonGroup, MznIcon],
  template: `
    <div mznButtonGroup variant="base-secondary" size="sub">
      <button mznButton iconType="leading" (click)="add()">
        <i mznIcon [icon]="plusIcon" [size]="14"></i>
        新增
      </button>
      <button mznButton iconType="icon-only" tooltipText="刪除" [disabled]="!hasSelection()">
        <i mznIcon [icon]="trashIcon" [size]="14"></i>
      </button>
    </div>
  `,
})
export class ToolbarComponent {
  readonly plusIcon = PlusIcon;
  readonly trashIcon = TrashIcon;
  readonly hasSelection = signal(false);

  add(): void { /* ... */ }
}
```

## Notes

- **Angular 指令多型 vs React JSX 多型**：React `<Button component="a" href="...">` 使用 `component` prop 動態切換 root element。Angular 版改用 attribute directive — 將 `[mznButton]` 直接掛在 `<button>` 或 `<a>` 上，不需要 `component` prop；Host element 決定了最終 DOM 標籤。
- **圖示放置**：不使用 React 的 `prefix`/`suffix` slot，而是將 `<i mznIcon>` 直接放在 `<button>` 內容中，配合 `iconType` 決定 CSS 佈局方式。
- **icon-only tooltip**：`iconType="icon-only"` + `tooltipText="..."` 時，hover 會自動顯示使用 floating-ui 定位的 tooltip，等效於 React 版將 `children`（文字）作為 tooltip 的行為。
- **loading 攔截**：`loading` 為 `true` 時，click 事件在 capture phase 被攔截，防止重複提交。
- **DI 繼承**：`MznButtonGroup` 透過 `MZN_BUTTON_GROUP` token 向子按鈕注入預設值；這是 Angular 版特有的 DI 機制，React 版沒有對應概念。
- **注意**：不要將 `mznButton` 套用在 `<div>` 上作為按鈕使用；請使用 `<button>` 以確保鍵盤可及性。

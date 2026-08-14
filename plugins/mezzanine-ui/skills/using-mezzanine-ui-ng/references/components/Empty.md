# Empty

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/empty) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-display-empty--docs

空狀態元件，用於資料為空時的佔位提示。透過 `type` 自動選擇對應的預設圖示，搭配 `title` 及 `description` 傳遞訊息。提供兩種操作按鈕 API：`actions` input（物件設定，自動套用 `size`）與 `<ng-content select="[actions]">` content projection。支援 `pictogram` 傳入自訂圖形 TemplateRef 取代預設圖示。

> **Aliases** — Empty State · No Data · Blank Slate · 空狀態 · 無資料 · Figma `Empty / *`
> **Not for** — 操作完成／失敗的結果頁（用 [`MznResultState`](ResultState.md)）

## Import

```ts
import { MznEmpty } from '@mezzanine-ui/ng/empty';
import type { EmptyType } from '@mezzanine-ui/ng/empty';
// EmptyType: 'initial-data' | 'notification' | 'result' | 'system' | 'custom'
// EmptySize from core: 'main' | 'sub' | 'minor'

// Note: EmptyActions and EmptyActionConfig are NOT re-exported from the public API.
// Use inline type definitions or type inference when typing actions locally:
//
//   const emptyActions = { primaryButton: { children: '新增', onClick: () => {} } };
//   // TypeScript infers the shape automatically — no explicit type import needed.
```

## Selector

`<div mznEmpty title="..." [type]="...">` — attribute-directive component

## Inputs

| Input         | Type                                  | Default         | Description                                                                        |
| ------------- | ------------------------------------- | --------------- | ---------------------------------------------------------------------------------- |
| `title`       | `string` (required)                   | —               | 空狀態的標題文字                                                                    |
| `type`        | `EmptyType`                           | `'initial-data'`| 決定預設圖示：`'initial-data'` / `'notification'` / `'result'` / `'system'` / `'custom'` |
| `size`        | `'main' \| 'sub' \| 'minor'`          | `'main'`        | 元件尺寸；`'minor'` 時不渲染操作按鈕                                                |
| `description` | `string`                              | —               | 描述文字，顯示在標題下方                                                            |
| `actions`     | `EmptyActions`                        | —               | 操作按鈕設定（見下方 `EmptyActions` 說明）                                          |
| `pictogram`   | `TemplateRef<unknown> \| undefined`   | `undefined`     | 自訂圖形 TemplateRef，設定後取代預設 icon                                           |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs

`MznEmpty` 無 output 事件；操作按鈕回呼透過 `EmptyActionConfig.onClick` 傳入。

## EmptyActions 型別

`actions` input 接受以下兩種形態：

```ts
// 1. 單一物件 → 視為 secondary 按鈕
actions: EmptyActionConfig

// 2. 雙按鈕物件
actions: { primaryButton?: EmptyActionConfig; secondaryButton: EmptyActionConfig }

// EmptyActionConfig 欄位：
interface EmptyActionConfig {
  children?: string;   // 按鈕文字
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
}
```

## Usage

```html
<!-- 基本使用（僅標題） -->
<div mznEmpty type="initial-data" title="尚無資料"></div>

<!-- 帶描述與 actions input -->
<div
  mznEmpty
  type="result"
  title="搜尋無結果"
  description="請嘗試不同的關鍵字"
  size="sub"
  [actions]="emptyActions"
></div>

<!-- 雙按鈕 -->
<div mznEmpty type="system" title="系統異常" [actions]="dualActions"></div>

<!-- content projection（需自行設定按鈕 size） -->
<div mznEmpty type="notification" title="暫無通知" size="sub">
  <button mznButton variant="base-secondary" size="sub" actions>設定通知</button>
</div>

<!-- 自訂 pictogram -->
<ng-template #customPic>
  <img src="/assets/empty-custom.svg" alt="" width="120" height="120" />
</ng-template>
<div mznEmpty [pictogram]="customPic" title="自訂圖示狀態"></div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznEmpty } from '@mezzanine-ui/ng/empty';
import { MznButton } from '@mezzanine-ui/ng/button';

// EmptyActions is not publicly exported — use type inference instead
const createEmptyActions = (onCreate: () => void) => ({
  primaryButton: { children: '新增項目', onClick: onCreate },
});

@Component({
  selector: 'app-data-list',
  imports: [MznEmpty, MznButton],
  template: `
    @if (items().length === 0) {
      <div
        mznEmpty
        type="initial-data"
        title="尚無項目"
        description="點擊新增按鈕以建立第一筆資料"
        size="sub"
        [actions]="emptyActions"
      ></div>
    }
  `,
})
export class DataListComponent {
  readonly items = signal<unknown[]>([]);

  // Type is inferred — no explicit EmptyActions import needed
  readonly emptyActions = {
    primaryButton: { children: '新增項目', onClick: () => this.createItem() },
  };

  createItem(): void { /* ... */ }
}
```

## Notes

- `size="main"` 時使用大型 SVG 圖示（`MznEmptyMain*Icon`）；`size="sub"` 或 `size="minor"` 時使用來自 `@mezzanine-ui/icons` 的小型圖示。
- `size="minor"` 時操作按鈕區域不渲染（無論 `actions` 設定或 content projection）。
- 當 `actions` input 提供時，會忽略 `<ng-content select="[actions]">` 的投射內容；兩者不能同時使用。
- 使用 `actions` input 時，Empty 元件會統一套用 `size` 和按鈕 `variant`，確保風格一致；使用 content projection 時，需要自行在 `<button mznButton>` 上指定 `size` 和 `variant`。
- `type="custom"` 時不渲染任何預設圖示；通常配合 `pictogram` 一起使用。

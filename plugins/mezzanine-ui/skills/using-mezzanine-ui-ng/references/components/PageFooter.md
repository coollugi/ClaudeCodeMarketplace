# PageFooter

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/page-footer) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/layout-page-footer--docs

頁面頁腳元件，包含操作按鈕與可選的輔助訊息。支援三種類型：`standard`（左側支援操作按鈕）、`overflow`（左側圖示按鈕，通常配合下拉選單）、`information`（左側純文字說明）。中間區域可顯示警示訊息，右側透過 `[actions]` 插槽投射主要操作按鈕。

## Import

```ts
import { MznPageFooter } from '@mezzanine-ui/ng/page-footer';
import type { PageFooterType } from '@mezzanine-ui/ng/page-footer';
// PageFooterType: 'standard' | 'overflow' | 'information'
import type { ButtonVariant } from '@mezzanine-ui/core/button';
```

## Selector

`<div mznPageFooter [type]="...">` — attribute-directive component

## Inputs

| Input                       | Type                              | Default        | Description                                                     |
| --------------------------- | --------------------------------- | -------------- | --------------------------------------------------------------- |
| `type`                      | `PageFooterType`                  | `'standard'`   | 頁腳類型，決定左側內容渲染邏輯                                   |
| `annotation`                | `string`                          | —              | 純文字說明（僅在 `type="information"` 時生效）                   |
| `supportingActionName`      | `string`                          | —              | 支援操作按鈕文字（僅在 `type="standard"` 時生效）                |
| `supportingActionIcon`      | `IconDefinition`                  | —                   | 支援操作圖示；在 `type="overflow"` 時作為圖示按鈕圖示，在 `type="standard"` 時作為按鈕的 leading icon |
| `supportingActionType`      | `'button' \| 'submit' \| 'reset'` | `'button'`     | 支援操作按鈕的 HTML type（僅在 `type="standard"` 時生效）        |
| `supportingActionVariant`   | `ButtonVariant`                   | `'base-ghost'` | 支援操作按鈕的 variant（僅在 `type="standard"` 時生效）          |
| `warningMessage`            | `string`                          | —              | 中間區域的警示訊息文字                                           |
| `hostClass`                 | `string`                          | `''`           | 附加到 host element 的額外 CSS class                             |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output                  | Type                          | Description                                          |
| ----------------------- | ----------------------------- | ---------------------------------------------------- |
| `supportingActionClick` | `OutputEmitterRef<MouseEvent>`| 支援操作按鈕點擊事件（僅在 `type="standard"` 時發出）|

## Content Projection

`<ng-content select="[actions]" />` — 右側主要操作按鈕插槽，傳入帶有 `actions` attribute 的元素

## Usage

```html
<!-- standard type：左側支援操作按鈕 + 右側主要按鈕 -->
<div
  mznPageFooter
  type="standard"
  supportingActionName="查看發佈紀錄"
  warningMessage="部分內容未通過驗證，請確認後再發佈"
  (supportingActionClick)="viewHistory()"
>
  <div actions style="display: flex; gap: 8px;">
    <button mznButton variant="base-secondary" (click)="saveDraft()">儲存草稿</button>
    <button mznButton variant="base-primary" (click)="publish()">發佈</button>
  </div>
</div>

<!-- information type：左側純文字說明 -->
<div
  mznPageFooter
  type="information"
  annotation="發佈後將無法編輯，請確認內容無誤"
>
  <div actions>
    <button mznButton variant="base-primary" (click)="publish()">確認發佈</button>
  </div>
</div>

<!-- overflow type：左側圖示下拉按鈕 -->
<div mznPageFooter type="overflow">
  <div actions>
    <button mznButton variant="base-primary" (click)="save()">儲存</button>
  </div>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznPageFooter } from '@mezzanine-ui/ng/page-footer';
import { MznButton } from '@mezzanine-ui/ng/button';

@Component({
  selector: 'app-edit-page',
  imports: [MznPageFooter, MznButton],
  template: `
    <div
      mznPageFooter
      type="standard"
      supportingActionName="查看記錄"
      [warningMessage]="validationWarning()"
      (supportingActionClick)="openHistory()"
    >
      <div actions style="display: flex; gap: 8px;">
        <button mznButton variant="base-secondary" [loading]="isSaving()" (click)="save()">
          儲存
        </button>
        <button mznButton variant="base-primary" [loading]="isPublishing()" (click)="publish()">
          發佈
        </button>
      </div>
    </div>
  `,
})
export class EditPageComponent {
  readonly isSaving = signal(false);
  readonly isPublishing = signal(false);
  readonly validationWarning = signal('');

  save(): void { /* ... */ }
  publish(): void { /* ... */ }
  openHistory(): void { /* ... */ }
}
```

## Notes

- 三種 `type` 的左側內容互斥：`standard` 顯示按鈕、`overflow` 顯示圖示按鈕、`information` 顯示純文字。`warningMessage` 中間區域在三種類型下均可設定。
- `supportingActionIcon` 在 input 層面沒有預設值。`DotHorizontalIcon` 的 fallback 僅在 `overflow` 渲染時由內部的 `resolvedSupportingActionIcon` computed 補上，不會透過 signal 傳遞。在 `standard` 模式下，若設定了 `supportingActionIcon`，圖示會渲染在按鈕文字左側（leading icon）。
- `overflow` 模式通常搭配下拉選單使用，下拉選單需自行在 `(click)` 事件中開啟。
- 右側 `[actions]` 插槽不受 `type` 影響，三種類型均可投射操作按鈕。

## 版面 padding 契約 (重要)

`MznPageFooter` 內建 `padding: vertical-base horizontal-spacious`（預設 `8px / 16px`、compact `4px / 14px`）、`width: 100%`、`border-top` 與底色。因此：

- **必須與 `mznPageHeader` 同層**，放在頁面最外層 column，才能讓 `border-top` 與底色滿版。
- **不可放進套了 `padding-inline` 的 body wrapper**，否則兩側各縮一個 gutter，分隔線會浮在半空中。
- **不需要也不應該再外加 padding** — 內距由元件自己提供。

詳見 [PATTERNS.md → Page Body Alignment with MznPageHeader](../PATTERNS.md#page-body-alignment-with-mznpageheader-重要--容易忽略)。

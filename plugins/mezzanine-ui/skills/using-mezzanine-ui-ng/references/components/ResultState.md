# ResultState

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/result-state) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/feedback-result-state--docs

結果狀態元件，用於操作結果或狀態頁面的顯示。根據 `type` 自動選擇對應的語意圖示（information、success、help、warning、error、failure），搭配 `title` 及 `description` 傳遞訊息。操作按鈕透過 `<ng-content select="[actions]">` 投射。

> **Aliases** — Result (Ant Design) · Status Page · Success / Error Page · 結果頁 · 404 / 500 頁
> **Not for** — 列表沒有資料時的佔位（用 [`MznEmpty`](Empty.md)）

## Import

```ts
import { MznResultState } from '@mezzanine-ui/ng/result-state';
// ResultStateType and ResultStateSize from core:
import type { ResultStateType, ResultStateSize } from '@mezzanine-ui/core/result-state';
// ResultStateType: 'information' | 'success' | 'help' | 'warning' | 'error' | 'failure'
// ResultStateSize: 'main' | 'sub'
```

## Selector

`<div mznResultState title="..." [type]="...">` — attribute-directive component

## Inputs

| Input         | Type                     | Default         | Description                                               |
| ------------- | ------------------------ | --------------- | --------------------------------------------------------- |
| `title`       | `string` (required)      | —               | 結果狀態的標題文字                                         |
| `type`        | `ResultStateType`        | `'information'` | 決定圖示與色彩（見下方 ResultStateType 說明）              |
| `size`        | `ResultStateSize`        | `'main'`        | `'main' \| 'sub'` — 元件尺寸                              |
| `description` | `string`                 | —               | 描述文字，顯示在標題下方                                   |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs

`MznResultState` 無 output 事件；操作按鈕回呼透過 content projection 傳入。

## ResultStateType 與對應圖示

| Type          | 圖示                    | 使用場景                           |
| ------------- | ----------------------- | ---------------------------------- |
| `information` | `InfoFilledIcon`        | 一般資訊提示                        |
| `success`     | `CheckedFilledIcon`     | 操作成功                            |
| `help`        | `QuestionFilledIcon`    | 說明或協助頁面                      |
| `warning`     | `WarningFilledIcon`     | 警告狀態                            |
| `error`       | `ErrorFilledIcon`       | 一般錯誤                            |
| `failure`     | `DangerousFilledIcon`   | 嚴重失敗                            |

## Content Projection

`<ng-content select="[actions]" />` — 操作按鈕插槽，傳入帶有 `actions` attribute 的元素（內部以 `MznButtonGroup` 包裝）

## Usage

```html
<!-- 成功狀態 -->
<div mznResultState type="success" title="操作成功" description="您的資料已儲存完成"></div>

<!-- 錯誤狀態含操作按鈕 -->
<div mznResultState type="error" title="操作失敗" description="請稍後再試" size="sub">
  <button mznButton variant="base-primary" actions (click)="retry()">重試</button>
</div>

<!-- 帶雙按鈕 -->
<div mznResultState type="information" title="確認刪除" description="此操作無法復原">
  <ng-container actions>
    <button mznButton variant="base-secondary" (click)="cancel()">取消</button>
    <button mznButton variant="destructive-primary" (click)="confirm()">確認刪除</button>
  </ng-container>
</div>

<!-- 幫助頁面 -->
<div
  mznResultState
  type="help"
  title="找不到頁面"
  description="您要訪問的頁面不存在或已被移除"
>
  <button mznButton variant="base-primary" actions routerLink="/">回到首頁</button>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznResultState } from '@mezzanine-ui/ng/result-state';
import { MznButton } from '@mezzanine-ui/ng/button';
import type { ResultStateType } from '@mezzanine-ui/core/result-state';

@Component({
  selector: 'app-submit-result',
  imports: [MznResultState, MznButton],
  template: `
    <div
      mznResultState
      [type]="resultType()"
      [title]="resultTitle()"
      [description]="resultDescription()"
    >
      @if (resultType() === 'error') {
        <button mznButton variant="base-primary" actions (click)="retry()">
          重新提交
        </button>
      } @else {
        <button mznButton variant="base-secondary" actions routerLink="/list">
          返回列表
        </button>
      }
    </div>
  `,
})
export class SubmitResultComponent {
  readonly resultType = signal<ResultStateType>('success');
  readonly resultTitle = signal('提交成功');
  readonly resultDescription = signal('您的申請已送出，請等待審核通知。');

  retry(): void {
    this.resultType.set('success');
    // retry logic...
  }
}
```

## Notes

- 操作按鈕 `[actions]` 插槽內部以 `MznButtonGroup` 包裝，按鈕會水平排列；`size` 不會自動傳遞給 `MznButtonGroup`，需在按鈕上手動設定 `size`。
- 不同於 React `<ResultState>` 接受 `buttons` prop 物件，Angular 版使用 content projection，彈性更高。
- `size="sub"` 適合側邊欄或半頁面的結果狀態顯示；`size="main"` 適合全頁面結果展示。

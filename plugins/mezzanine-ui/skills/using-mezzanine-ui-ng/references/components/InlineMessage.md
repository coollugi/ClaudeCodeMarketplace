# InlineMessage

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/inline-message) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/feedback-inline-message--docs

行內訊息元件，用於表單欄位旁的即時回饋。支援 `info`、`warning`、`error` 三種語意；`info` 模式可附帶關閉按鈕。`MznInlineMessageGroup` 將多則訊息集中顯示，支援透過 `items` 陣列傳入並統一監聽關閉事件。

> **Aliases** — Alert (MUI) · Callout · Inline Alert · Helper Text · 區塊說明 · 警語 · 表單提示
> **Not for** — 頁面級／系統級公告（用 [`MznAlertBanner`](AlertBanner.md)）；一閃即逝的操作回饋（用 [`MznMessage`](Message.md)）

## Import

```ts
import { MznInlineMessage, MznInlineMessageGroup } from '@mezzanine-ui/ng/inline-message';
import type { InlineMessageGroupItem } from '@mezzanine-ui/ng/inline-message';
// InlineMessageSeverity: 'info' | 'warning' | 'error' (from @mezzanine-ui/core/inline-message)
```

## Selector

`<div mznInlineMessage severity="..." content="...">` — attribute-directive component

`<div mznInlineMessageGroup [items]="...">` — group component

## Inputs — MznInlineMessage

| Input      | Type                       | Default | Description                                             |
| ---------- | -------------------------- | ------- | ------------------------------------------------------- |
| `severity` | `InlineMessageSeverity` (required) | — | `'info' \| 'warning' \| 'error'` — 決定圖示與色彩 |
| `content`  | `string` (required)        | —       | 訊息文字                                                |
| `icon`     | `IconDefinition`           | auto    | 自訂圖示；未設定時依 severity 自動選擇                   |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs — MznInlineMessage

| Output   | Type                     | Description                                   |
| -------- | ------------------------ | --------------------------------------------- |
| `closed` | `OutputEmitterRef<void>` | 關閉按鈕被點擊後觸發（僅 `severity="info"` 時顯示關閉按鈕） |

## Inputs — MznInlineMessageGroup

| Input   | Type                                     | Default | Description                         |
| ------- | ---------------------------------------- | ------- | ------------------------------------ |
| `items` | `ReadonlyArray<InlineMessageGroupItem>`  | `[]`    | 訊息項目陣列                          |

## Outputs — MznInlineMessageGroup

| Output      | Type                              | Description                      |
| ----------- | --------------------------------- | -------------------------------- |
| `itemClose` | `OutputEmitterRef<string \| number>` | 某項訊息被關閉時，發送該項目的 `key` |

## InlineMessageGroupItem 介面

| 欄位       | Type                    | Description          |
| ---------- | ----------------------- | -------------------- |
| `key`      | `string \| number`      | 唯一識別碼（必填）    |
| `severity` | `InlineMessageSeverity` | 嚴重程度（必填）      |
| `content`  | `string`                | 訊息文字（必填）      |
| `icon`     | `IconDefinition`        | 自訂圖示（選填）      |

## Usage

```html
<!-- 單一行內訊息 -->
<div mznInlineMessage severity="error" content="此欄位為必填"></div>

<!-- info 模式含關閉按鈕 -->
<div
  mznInlineMessage
  severity="info"
  content="設定已儲存，重新整理後生效"
  (closed)="hideInfo()"
></div>

<!-- 與表單欄位搭配 -->
<div mznFormField name="email" label="Email">
  <input mznInput formControlName="email" />
</div>
<div
  mznInlineMessage
  severity="error"
  [content]="emailErrorMessage()"
  *ngIf="showEmailError()"
></div>

<!-- 群組顯示多則訊息 -->
<div
  mznInlineMessageGroup
  [items]="validationMessages()"
  (itemClose)="dismissMessage($event)"
></div>
```

```ts
import { Component, computed, signal } from '@angular/core';
import {
  MznInlineMessage,
  MznInlineMessageGroup,
} from '@mezzanine-ui/ng/inline-message';
import type { InlineMessageGroupItem } from '@mezzanine-ui/ng/inline-message';
import { FormControl, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-form',
  imports: [MznInlineMessage, MznInlineMessageGroup, ReactiveFormsModule],
  template: `
    <div
      mznInlineMessage
      severity="error"
      [content]="emailError() ?? ''"
      *ngIf="emailError()"
    ></div>

    <div
      mznInlineMessageGroup
      [items]="messages()"
      (itemClose)="closeMessage($event)"
    ></div>
  `,
})
export class FormComponent {
  readonly emailCtrl = new FormControl('', Validators.email);

  readonly emailError = computed((): string | null => {
    if (this.emailCtrl.invalid && this.emailCtrl.touched) {
      return '請輸入有效的 Email 地址';
    }
    return null;
  });

  private readonly _messages = signal<InlineMessageGroupItem[]>([
    { key: 'warn1', severity: 'warning', content: '密碼強度不足' },
    { key: 'info1', severity: 'info', content: '請確認 Email 已驗證' },
  ]);

  readonly messages = this._messages.asReadonly();

  closeMessage(key: string | number): void {
    this._messages.update((items) => items.filter((i) => i.key !== key));
  }
}
```

## Notes

- `MznInlineMessage` 的 `closed` output 僅在 `severity="info"` 時有效；`warning` 和 `error` 不渲染關閉按鈕。
- `MznInlineMessage` 帶有 `role="status"` 和 `aria-live="polite"`；`MznInlineMessageGroup` 帶有 `role="region"` 和 `aria-live="polite"`。兩者的 ARIA role 不同。
- `MznInlineMessage` 的 `closed` output 觸發後，元件內部的 `visible` signal 會設為 `false`，元件自行隱藏。不需要在模板中搭配 `*ngIf` 控制可見性。
- 不同於 React 版直接在 `<FormField>` 中傳入 `hintText`，Angular 版的 `MznInlineMessage` 作為獨立元件，通常搭配 `MznFormField` 的 `hintText` input 使用（`MznFormField` 會渲染 `MznFormHintText`），兩種都是合法使用方式。

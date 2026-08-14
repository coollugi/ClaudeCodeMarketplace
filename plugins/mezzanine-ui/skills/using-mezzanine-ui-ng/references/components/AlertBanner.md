# AlertBanner

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/alert-banner) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/feedback-alert-banner--docs

橫幅通知元件，用於全域性重要訊息提示。支援 `info`、`warning`、`error` 三種嚴重程度，可附帶最多 2 個操作按鈕與關閉按鈕，並內建入場/離場高度動畫。通常搭配 `MznAlertBannerService` 以命令式 API 呼叫，並配合 `MznAlertBannerContainer` 統一渲染所有浮動橫幅。

> **Aliases** — Alert · Banner · System Banner · 系統警示 · 頁面級橫幅 · Figma `Alert Banner`
> **Not for** — 區塊內的說明／警語（用 [`MznInlineMessage`](InlineMessage.md)）。`MznAlertBanner` 走 Portal 的 `alert` 層（`position: sticky; top: 0`），**不會待在你放它的位置**，而是浮到頁面頂端蓋住 `mznPageHeader`。

## Import

```ts
import {
  MznAlertBanner,
  MznAlertBannerContainer,
  MznAlertBannerService,
  AlertBannerSeverity,
} from '@mezzanine-ui/ng/alert-banner';
import type { AlertBannerAction, AlertBannerData } from '@mezzanine-ui/ng/alert-banner';
// AlertBannerSeverity = 'info' | 'warning' | 'error'
```

## Selector

`<div mznAlertBanner severity="..." message="...">` — attribute-directive component

`<mzn-alert-banner-container />` — container component for service-driven banners

## Inputs — MznAlertBanner

| Input           | Type                               | Default     | Description                                                                  |
| --------------- | ---------------------------------- | ----------- | ---------------------------------------------------------------------------- |
| `severity`      | `AlertBannerSeverity` (required)   | —           | `'info' \| 'warning' \| 'error'` — 決定圖示與色彩                            |
| `message`       | `string` (required)                | —           | 顯示的訊息文字                                                                |
| `actions`       | `ReadonlyArray<AlertBannerAction>` | `[]`        | 操作按鈕（最多 2 個）；超出部分被截斷並輸出 console 警告                       |
| `closable`      | `boolean`                          | `true`      | 是否顯示關閉按鈕                                                              |
| `icon`          | `IconDefinition`                   | auto        | 自訂圖示；未設定時依 `severity` 自動選擇                                       |
| `disablePortal` | `boolean`                          | `false`     | 設為 `true` 時橫幅渲染在原位，不 portal 至全域 alert layer                    |
| `reference`     | `string \| number \| undefined`    | `undefined` | 唯一 key，用於 `MznAlertBannerService.remove(key)` 程式化關閉                 |
| `createdAt`     | `number \| undefined`              | —           | 建立時間戳（毫秒），由 `MznAlertBannerService` 自動填入，用於多橫幅排序        |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs — MznAlertBanner

| Output   | Type                      | Description              |
| -------- | ------------------------- | ------------------------ |
| `closed` | `OutputEmitterRef<void>`  | 關閉動畫完成後觸發        |

## Sub-components / Exports

| Export                    | Purpose                                                                    |
| ------------------------- | -------------------------------------------------------------------------- |
| `MznAlertBanner`          | 單一橫幅通知 component（attribute directive on `<div>`）                    |
| `MznAlertBannerContainer` | 讀取 `MznNotifierService` signal 並渲染所有 banners；根元件放置一次即可     |
| `MznAlertBannerService`   | Injectable service，提供 `.info()` / `.warning()` / `.error()` / `.remove(key: string)` |
| `AlertBannerSeverity`     | 型別別名：`'info' \| 'warning' \| 'error'`                                  |
| `AlertBannerAction`       | 介面：`{ content?: string; onClick: (event: MouseEvent) => void }`         |
| `AlertBannerData`         | `MznAlertBannerService.add()` 的完整輸入資料形狀                            |

## Usage

```html
<!-- 宣告式使用（不透過 service） -->
<div
  mznAlertBanner
  severity="warning"
  message="系統將於 30 分鐘後進行維護"
  [closable]="true"
  [actions]="bannerActions"
  (closed)="onClose()"
></div>

<!-- 服務驅動（推薦）：在 root component template 放一次容器 -->
<mzn-alert-banner-container />
```

```ts
import { Component, inject, DestroyRef } from '@angular/core';
import {
  MznAlertBannerContainer,
  MznAlertBannerService,
  AlertBannerAction,
} from '@mezzanine-ui/ng/alert-banner';

@Component({
  selector: 'app-root',
  imports: [MznAlertBannerContainer],
  template: `
    <mzn-alert-banner-container />
    <router-outlet />
  `,
})
export class AppComponent {
  private readonly alertBanner = inject(MznAlertBannerService);

  constructor() {
    inject(DestroyRef).onDestroy(() => this.alertBanner.destroy());
  }
}

// 在任意元件中觸發橫幅：
@Component({ /* ... */ })
export class SomeFeatureComponent {
  private readonly alertBanner = inject(MznAlertBannerService);

  readonly bannerActions: ReadonlyArray<AlertBannerAction> = [
    { content: '了解更多', onClick: () => console.log('clicked') },
  ];

  showWarning(): void {
    this.alertBanner.warning('帳號即將到期，請儘快更新付款資訊。');
  }

  showError(): void {
    const key = this.alertBanner.error('伺服器連線中斷，請稍後再試。');
    // 程式化移除
    setTimeout(() => this.alertBanner.remove(key), 5000);
  }
}
```

## Notes

- `MznAlertBanner` 預設透過 `MznPortal` 渲染至全域 `alert` layer，與 React `<AlertBanner>` 的 `<Portal>` 行為一致。若需要 inline 使用，設定 `[disablePortal]="true"`。
- `actions` 最多接受 2 個按鈕；超出部分會被靜默截斷並在 console 輸出警告。
- `MznAlertBannerContainer` 依非 info 優先、建立時間逆序排列橫幅，對齊 React `sortAlertNotifiers` 演算法。
- 不同於 React 版使用靜態方法（`AlertBanner.info()`），Angular 版透過 `inject(MznAlertBannerService)` 取得服務實例。
- `AlertBannerData` 介面有一個選用欄位 `key?: string`。傳入時作為通知的唯一識別鍵；未傳入時由 `MznNotifierService` 自動產生。`MznAlertBannerService.remove(key: string)` 的參數即為此 `key`（`add()` 回傳值，或 `info()`/`warning()`/`error()` 回傳值均為此字串）。
- 動畫使用 CSS 高度補間；SSR 環境下 `afterNextRender` 確保動畫只在瀏覽器端執行。

# Progress

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/progress) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/feedback-progress--docs

進度條元件，支援百分比文字與狀態圖示兩種顯示類型。`percent` 介於 0~100；未達 100 時狀態自動為 `enabled`，達到 100 時自動切換為 `success`（可強制指定 `status="error"`）。`tick` 可在進度條上標記特定位置（如目標值）。

> **Aliases** — ProgressBar · mat-progress-bar (Angular Material) · 進度條 · 百分比進度
> **Not for** — 不知道進度的載入（用 [`MznSpin`](Spin.md)）；有版面結構的載入佔位（用 [`MznSkeleton`](Skeleton.md)）

## Import

```ts
import { MznProgress } from '@mezzanine-ui/ng/progress';
import type { ProgressPercentProps } from '@mezzanine-ui/ng/progress';
// ProgressStatus: 'enabled' | 'success' | 'error' (from @mezzanine-ui/core/progress)
// ProgressType: 'progress' | 'percent' | 'icon' (from @mezzanine-ui/core/progress)
```

## Selector

`<div mznProgress [percent]="60">` — attribute-directive component

## Inputs

| Input          | Type                                       | Default      | Description                                                                   |
| -------------- | ------------------------------------------ | ------------ | ----------------------------------------------------------------------------- |
| `percent`      | `number`                                   | `0`          | 進度百分比（0～100），超出範圍會被 clamp 至 0 或 100                           |
| `type`         | `ProgressType`                             | `'progress'` | `'progress'`（純進度條）/ `'percent'`（進度條 + 百分比文字）/ `'icon'`（進度條 + 狀態圖示）|
| `status`       | `ProgressStatus`                           | auto         | 強制指定狀態；未設定時依 `percent` 自動判斷（`< 100` → `enabled`，`= 100` → `success`）|
| `tick`         | `number`                                   | `0`          | 進度條上的標記位置（0～100），設 0 不顯示                                       |
| `percentProps` | `ProgressPercentProps`                     | —            | 百分比文字的排版屬性（`type="percent"` 時生效）                                 |
| `icons`        | `{ error?: IconDefinition; success?: IconDefinition }` | — | 自訂狀態圖示（`type="icon"` 時生效）；未設定時使用預設圖示                    |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznProgress` 無 output 事件。

## ProgressPercentProps 介面

| 欄位       | Type               | Description                           |
| ---------- | ------------------ | ------------------------------------- |
| `variant`  | `TypographySemanticType` | 文字排版類型，預設 `'input'`        |
| `align`    | `TypographyAlign`  | 文字對齊                              |
| `color`    | `TypographyColor`  | 文字顏色                              |
| `display`  | `TypographyDisplay`| CSS display 值                        |
| `ellipsis` | `boolean`          | 單行截斷省略號                         |
| `noWrap`   | `boolean`          | 禁止換行                              |

## Usage

```html
<!-- 基本進度條 -->
<div mznProgress [percent]="uploadProgress()"></div>

<!-- 帶百分比文字 -->
<div mznProgress type="percent" [percent]="60"></div>

<!-- 帶狀態圖示 -->
<div mznProgress type="icon" [percent]="taskProgress()"></div>

<!-- 強制 error 狀態 -->
<div mznProgress type="icon" [percent]="40" status="error"></div>

<!-- 帶標記線（如達標線） -->
<div mznProgress [percent]="65" [tick]="80"></div>

<!-- 自訂百分比文字樣式 -->
<div
  mznProgress
  type="percent"
  [percent]="75"
  [percentProps]="{ color: 'text-secondary', variant: 'caption' }"
></div>
```

```ts
import { Component, signal, computed } from '@angular/core';
import { MznProgress } from '@mezzanine-ui/ng/progress';

@Component({
  selector: 'app-upload',
  imports: [MznProgress],
  template: `
    <div mznProgress type="icon" [percent]="uploadPercent()"></div>
    <p>{{ uploadPercent() }}% 完成</p>

    <!-- 多個任務進度 -->
    @for (task of tasks(); track task.id) {
      <div mznProgress
        type="percent"
        [percent]="task.progress"
        [status]="task.error ? 'error' : undefined"
      ></div>
    }
  `,
})
export class UploadComponent {
  readonly uploadPercent = signal(0);

  readonly tasks = signal([
    { id: 1, progress: 100, error: false },
    { id: 2, progress: 45, error: false },
    { id: 3, progress: 30, error: true },
  ]);
}
```

## Notes

- `percent` 超出 0~100 範圍時，元件內部使用 `Math.max(0, Math.min(100, percent))` 保護，不需呼叫端自行 clamp。
- `type="icon"` 且 `status="success"` 時顯示 `CheckedFilledIcon`；`status="error"` 時顯示 `DangerousFilledIcon`；可透過 `icons` input 覆蓋。
- `tick` 位置使用 `ResizeObserver` 動態計算，會隨容器寬度自動更新。
- `type="progress"`（預設）不顯示圖示或文字，僅顯示進度條本身；`percent` 和 `type="percent"` 搭配時才顯示右側百分比數字。
- 元件使用 `AfterViewInit` 時序進行 tick 位置的初始計算，確保 DOM 已渲染。

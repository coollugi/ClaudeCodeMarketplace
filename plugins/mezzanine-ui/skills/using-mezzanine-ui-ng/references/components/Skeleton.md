# Skeleton

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/skeleton) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/feedback-skeleton--docs

骨架屏佔位元件，用於載入中狀態的視覺提示。支援兩種模式：**strip mode**（設定 `variant` 且未指定 `height` / `circle` 時，以對應文字排版高度呈現長條形）與 **block mode**（指定 `width` / `height` / `circle` 時以指定尺寸呈現方形或圓形）。

> **Aliases** — Skeleton Screen · Placeholder · Shimmer · Ghost Loading · 骨架屏 · 載入佔位
> **Not for** — 不知道版面結構的載入（用 [`MznSpin`](Spin.md)）；有百分比的進度（用 [`MznProgress`](Progress.md)）

## Import

```ts
import { MznSkeleton } from '@mezzanine-ui/ng/skeleton';
import type { TypographySemanticType } from '@mezzanine-ui/core/typography';
// TypographySemanticType 涵蓋所有語意排版類型：'h1' | 'h2' | ... | 'body' | 'caption' 等
```

## Selector

`<div mznSkeleton [variant]="'h3'">` — attribute-directive component

## Inputs

| Input     | Type                     | Default  | Description                                                                          |
| --------- | ------------------------ | -------- | ------------------------------------------------------------------------------------ |
| `variant` | `TypographySemanticType` | —        | 排版類型；設定時以對應文字高度呈現長條形（strip mode），未設定時為 block mode          |
| `width`   | `number \| string`       | —        | 元件寬度；數字型自動加 `px`（如 `200` → `'200px'`），字串型直接使用（如 `'50%'`）；未設定時不套用 inline style（寬度繼承自 host CSS） |
| `height`  | `number \| string`       | —        | 元件高度；設定後進入 block mode（忽略 `variant` 的高度計算）；未設定時不套用 inline style |
| `circle`  | `boolean`                | `false`  | 是否為圓形；設定後進入 block mode                                                    |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznSkeleton` 無 output 事件。

## 兩種模式說明

| 模式        | 觸發條件                            | 行為                                          |
| ----------- | ----------------------------------- | --------------------------------------------- |
| Strip mode  | 設定 `variant`，且無 `height`/`circle` | 以對應文字排版的高度顯示長條形，帶波紋動畫     |
| Block mode  | 設定 `height` 或 `circle`           | 以指定尺寸顯示方塊或圓形，帶波紋動畫           |

## Usage

```html
<!-- Strip mode：以 h3 字高呈現標題骨架 -->
<div mznSkeleton variant="h3"></div>
<div mznSkeleton variant="body"></div>
<div mznSkeleton variant="caption"></div>

<!-- Block mode：指定寬高 -->
<div mznSkeleton width="200px" height="16px"></div>
<div mznSkeleton width="100%" height="120px"></div>

<!-- 圓形頭像骨架 -->
<div mznSkeleton [circle]="true" width="40px" height="40px"></div>
<div mznSkeleton [circle]="true" [width]="48" [height]="48"></div>

<!-- 卡片骨架 -->
<div style="display: flex; gap: 12px; align-items: center;">
  <div mznSkeleton [circle]="true" width="40px" height="40px"></div>
  <div style="flex: 1; display: flex; flex-direction: column; gap: 4px;">
    <div mznSkeleton variant="label-primary"></div>
    <div mznSkeleton variant="caption" width="60%"></div>
  </div>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznSkeleton } from '@mezzanine-ui/ng/skeleton';

@Component({
  selector: 'app-user-card',
  imports: [MznSkeleton],
  template: `
    @if (isLoading()) {
      <div style="display: flex; gap: 12px; padding: 16px;">
        <div mznSkeleton [circle]="true" width="48px" height="48px"></div>
        <div style="flex: 1;">
          <div mznSkeleton variant="label-primary-highlight" style="margin-bottom: 6px;"></div>
          <div mznSkeleton variant="caption" width="70%"></div>
        </div>
      </div>
    } @else {
      <div>{{ user()?.name }}</div>
    }
  `,
})
export class UserCardComponent {
  readonly isLoading = signal(true);
  readonly user = signal<{ name: string } | null>(null);
}
```

## Notes

- Strip mode 的高度由 `@mezzanine-ui/core/skeleton` 的 `classes.type(variant)` CSS class 決定，對應各 typography variant 的 `line-height`。
- `width` / `height` 接受數字（自動轉換為 `px`）或任意 CSS 字串（`'50%'`、`'calc(100% - 32px)'` 等）。
- `circle` 模式需同時設定 `width` 和 `height` 為相同值才能得到正圓形。
- 骨架屏的閃爍動畫由 CSS animation 控制（`@mezzanine-ui/core/skeleton` 的 CSS class），不需額外設定。

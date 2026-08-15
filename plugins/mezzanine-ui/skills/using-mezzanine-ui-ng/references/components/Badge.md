# Badge

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/badge) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-display-badge--docs

徽章元件，用於標記狀態、數量或提示訊息。

**四種型態**：`dot-*`（狀態圓點）、`dot-*` + `text`（圓點 + 狀態文字，**表格狀態欄最常用**）、`text-*`（純文字狀態）、`count-*`（數字氣泡）。計數型徽章可設定 `overflowCount` 限制最大顯示數值；`count` 為 `0` 時徽章自動隱藏。

**狀態標籤（「已核准」「失敗」「停用」）用 `dot-*` + `text`，不要用 [`MznTag`](Tag.md)。**

> **Aliases** — matBadge (Angular Material) · Badge (MUI・Ant Design・Bootstrap) · status chip · 狀態晶片 · 狀態標籤 · 紅點 · 未讀數字 · Figma `Badge / Dot With Text`
> **Not for** — 分類標籤（用 [`MznTag`](Tag.md)）；有底色的膠囊狀態晶片（`dot-*` / `text-*` **沒有背景色**，見下方〈沒有膠囊底色〉）

---

## 沒有膠囊底色（重要）

核對自 `packages/core/src/badge/_badge-styles.scss`：

| variant   | 實際樣式                                                               | 有膠囊底嗎                                    |
| --------- | ---------------------------------------------------------------------- | --------------------------------------------- |
| `dot-*`   | `color` + `column-gap` + 一顆 `::before` 圓點                          | ❌ 無 background、無 radius、無 padding        |
| `text-*`  | `color` + `column-gap`                                                 | ❌ 只有文字顏色                                |
| `count-*` | `color` + `background-color` + `border-radius` + `padding-inline` | ✅ 但它的 input 是 `count: number`，塞不了文字 |

> `count-*` 的圓角**不是一致的**：`count-alert` / `count-inactive` / `count-inverse` / `count-brand` 是 `radius.variable(full)`（膠囊），但 **`count-info` 是 `radius.variable(tiny)`**（近乎方角）。核對自 `packages/core/src/badge/_badge-styles.scss` 的 `$count-type-config`。

**結論：設計稿上「有底色的圓角膠囊 + 狀態文字」這種晶片，在 Mezzanine 裡零覆寫做不出來。**

遇到這種稿子的正解是改用 `dot-*` + `text`，或回頭與設計確認 —— **不是**自己補 `background`。

---

## 表格狀態欄用 `dot-*`，不要用 `text-*`

實測（放大對照）：表格狀態欄用 `text-success` 時，「啟用」與同一列操作欄的 `base-text-link`「編輯」**幾乎無法分辨** —— 同色系、同字重、同字級，狀態看起來像可點的連結。`dot-*` 多的那顆 6px 圓點提供了「這是狀態指示器」的**形狀記號**，一眼分開，不靠顏色。

```html
<!-- ❌ 表格狀態欄：與同列的 text-link 操作按鈕難以分辨 -->
<div mznBadge variant="text-success" text="啟用"></div>

<!-- ✅ 圓點提供形狀記號 -->
<div mznBadge variant="dot-success" text="啟用"></div>
```

**無障礙補充**（`packages/system/src/palette/typings.ts`）：`TextTone` 有 `error-strong` / `warning-strong` / `info-strong`，**但沒有 `success-strong`**（只有 `IconTone` 有）。所以純文字綠固定卡在 `text/success` = green-500 `#139F62`，對白底對比 **3.41:1**，低於 WCAG AA 的 4.5:1，**在型別範圍內換不掉**。

---

## Import

```ts
import { MznBadge } from '@mezzanine-ui/ng/badge';
// @deprecated — 請改用 MznBadge 的 content projection 模式
import { MznBadgeContainer } from '@mezzanine-ui/ng/badge';
import type {
  BadgeVariant,
  BadgeTextSize,
  BadgeCountVariant,
  BadgeDotVariant,
  BadgeTextVariant,
} from '@mezzanine-ui/ng/badge';
```

## Selector

`<div mznBadge variant="..." ...>` — component，selector 限定 `div[mznBadge]`（host element 必須為 `<div>`）

## Inputs

| Input           | Type                   | Default | Description                                                                                 |
| --------------- | ---------------------- | ------- | ------------------------------------------------------------------------------------------- |
| `variant`       | `BadgeVariant` (required) | —    | 視覺變體，見下方 BadgeVariant 說明                                                           |
| `count`         | `number`               | —       | 計數型徽章的數字（`count-*` 型 variant）                                                    |
| `overflowCount` | `number`               | —       | 計數上限；超過時顯示 `{overflowCount}+`                                                      |
| `size`          | `BadgeTextSize`        | —       | 文字型/圓點帶文字徽章的尺寸（`text-*` 和部分 `dot-*` 型）                                    |
| `text`          | `string`               | —       | 文字型徽章的顯示文字（`text-*` 型）                                                          |
| `className`     | `string`               | —       | 附加到內層 badge `<span>` 的自訂 CSS class                                                   |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## BadgeVariant 說明

三組 variant 各**恰好五個值**，沒有其他成員（核對自 `packages/core/src/badge/badge.ts`）：

| 分類   | 可選值（窮舉，無其他）                                                                          |
| ------ | ----------------------------------------------------------------------------------------------- |
| 圓點型 | `'dot-success'` / `'dot-error'` / `'dot-warning'` / `'dot-info'` / `'dot-inactive'`              |
| 文字型 | `'text-success'` / `'text-error'` / `'text-warning'` / `'text-info'` / `'text-inactive'`         |
| 計數型 | `'count-alert'` / `'count-inactive'` / `'count-inverse'` / `'count-brand'` / `'count-info'`      |

> ⚠️ **沒有** `dot-brand` / `dot-neutral` / `text-brand` / `text-neutral` / `text-alert` 這些值。
> 灰色（停用／無狀態）是 `dot-inactive` 與 `text-inactive`，藍色（資訊）是 `dot-info` 與 `text-info`。
> `brand` 只存在於計數型（`count-brand`）。

## Sub-components / Exports

| Export              | Purpose                                                                        |
| ------------------- | ------------------------------------------------------------------------------ |
| `MznBadge`          | 主要徽章元件                                                                    |
| `MznBadgeContainer` | **已棄用**（`@deprecated`）；請改用 `MznBadge` 的 content projection 模式取代  |

## Usage

```html
<!-- 計數型徽章（單獨使用） -->
<div mznBadge variant="count-alert" [count]="5"></div>

<!-- 計數型徽章（含溢出上限） -->
<div mznBadge variant="count-brand" [count]="120" [overflowCount]="99"></div>

<!-- 圓點型徽章覆蓋在圖示上（content projection） -->
<div mznBadge variant="dot-error">
  <i mznIcon [icon]="BellIcon"></i>
</div>

<!-- 狀態標籤：圓點 + 文字（表格狀態欄的正解） -->
<div mznBadge variant="dot-success" text="已核准"></div>
<div mznBadge variant="dot-error" text="退回補正"></div>
<div mznBadge variant="dot-inactive" text="草稿"></div>

<!-- 文字型徽章（無圓點） -->
<div mznBadge variant="text-success" text="NEW"></div>

<!-- 與 Tab 搭配（計數為 0 時自動隱藏） -->
<div mznBadge variant="count-inactive" [count]="0"></div>
<!-- → 徽章不顯示 -->
```

```ts
import { Component, signal } from '@angular/core';
import { MznBadge } from '@mezzanine-ui/ng/badge';
import { BellIcon } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-notification',
  imports: [MznBadge],
  template: `
    <div mznBadge variant="count-alert" [count]="unreadCount()"></div>
    <div mznBadge variant="dot-error">
      <i mznIcon [icon]="bellIcon"></i>
    </div>
  `,
})
export class NotificationComponent {
  readonly bellIcon = BellIcon;
  readonly unreadCount = signal(3);
}
```

## Notes

- 當投射了子元素時，徽章會以 `position: absolute` 覆疊方式出現在子元素右上角（`container` mode）；無子元素時，徽章為 `inline` 模式。是否有子元素由元件使用 `MutationObserver` 自動偵測，不需手動設定。
- `MznBadgeContainer` 已標記為 `@deprecated`，請改用 `<div mznBadge variant="dot-*">...</div>` 的 content projection 模式。
- 計數型 variant：`count` 為 `0` 時 badge 自動加上 `hide` class 不顯示；需要始終顯示零值時應改用文字型 variant。
- **`text` input 在所有非 `count-*` 的 variant 下都生效**，包含 `dot-*` —— `<div mznBadge variant="dot-success" text="已核准">` 會渲染「圓點 + 文字」，這正是表格狀態欄的正解。實作上 `displayText()` 只在 `count-*` 時回傳數字，其餘一律回傳 `text()`（`packages/ng/badge/badge.component.ts`）。`count` input 則僅在 `count-*` 型 variant 下生效。
- 狀態呈現一律用 `MznBadge`，不要用 `MznTag` + class 覆寫底色 —— `MznTag` 沒有語意色，見 [Tag.md](Tag.md)。

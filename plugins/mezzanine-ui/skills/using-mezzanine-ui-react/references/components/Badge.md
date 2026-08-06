# Badge Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Badge`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Badge) · Verified 1.4.1 (2026-07-01)

Badge component for marking status, quantity, or hint messages. Supports dot and count modes.

## Import

```tsx
import { Badge, BadgeContainer } from '@mezzanine-ui/react';
import type { BadgeProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-badge--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

> **Note**: `BadgeContainer` is deprecated (`@deprecated`), use the `Badge` component directly. `BadgeContainerProps` is equivalent to `NativeElementPropsWithoutKeyAndRef<'span'>`.

`BadgeProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'span'>, 'children'>` and unions with `BadgeVariantProps`.

---

## Badge Variant Types

### Dot Variants

| Variant         | Description    | Usage                    |
| --------------- | -------------- | ------------------------ |
| `dot-success`   | Success green  | Online/success status    |
| `dot-error`     | Error red      | Error/offline status     |
| `dot-warning`   | Warning yellow | Warning/attention status |
| `dot-info`      | Info blue      | Information hint         |
| `dot-inactive`  | Gray           | Inactive/idle status     |

### Count Variants

| Variant          | Description    | Usage                    |
| ---------------- | -------------- | ------------------------ |
| `count-alert`    | Alert red bg   | Important notification count |
| `count-inactive` | Gray bg        | Secondary notification count |
| `count-inverse`  | Dark bg        | Inverted color scheme    |
| `count-brand`    | Brand color bg | Brand-related count      |
| `count-info`     | Info blue bg   | General info count       |

### Text Variants

| Variant         | Description    | Usage                    |
| --------------- | -------------- | ------------------------ |
| `text-success`  | Success text   | Inline text status       |
| `text-error`    | Error text     | Inline error indicator   |
| `text-warning`  | Warning text   | Inline warning           |
| `text-info`     | Info text      | Inline info              |
| `text-inactive` | Inactive text  | Inline inactive          |

---

## Badge Props

Badge props are divided into mutually exclusive structures based on `variant` type.

### Count Badge (`variant: BadgeCountVariant`)

| Property        | Type                | Default | Description                    |
| --------------- | ------------------- | ------- | ------------------------------ |
| `variant`       | `BadgeCountVariant` | -       | Required, count variant        |
| `count`         | `number`            | -       | Required, number to display    |
| `overflowCount` | `number`            | -       | Shows `99+` when exceeded      |

> Count badge does not support `children`, `text`, and `size`.

### Dot Badge with Text (`variant: BadgeDotVariant`)

| Property  | Type              | Default  | Description                      |
| --------- | ----------------- | -------- | -------------------------------- |
| `variant` | `BadgeDotVariant` | -        | Required, dot variant            |
| `text`    | `string`          | -        | Text next to the dot (optional)  |
| `size`    | `BadgeTextSize`   | -        | Size of the dot and text         |

> Dot badge with text does not support `children`.

### Dot Badge with Children (`variant: BadgeDotVariant`)

| Property   | Type              | Default | Description                            |
| ---------- | ----------------- | ------- | -------------------------------------- |
| `variant`  | `BadgeDotVariant` | -       | Required, dot variant                  |
| `children` | `ReactNode`       | -       | Children, dot appears at top-right     |

> Dot badge with children does not support `text` and `size`.

### Text Badge (`variant: BadgeTextVariant`)

| Property  | Type               | Default | Description                    |
| --------- | ------------------ | ------- | ------------------------------ |
| `variant` | `BadgeTextVariant` | -       | Required, text variant         |
| `text`    | `string`           | -       | Required, text to display      |
| `size`    | `BadgeTextSize`    | -       | Size of the text               |

> Text badge does not support `children`, `count`, and `overflowCount`.

---

## Usage Examples

### Dot Badge

```tsx
import { Badge } from '@mezzanine-ui/react';

// Standalone dot
<Badge variant="dot-success" />
<Badge variant="dot-error" />
<Badge variant="dot-warning" />
<Badge variant="dot-info" />
<Badge variant="dot-inactive" />

// With text
<Badge variant="dot-success" text="Online" />
<Badge variant="dot-error" text="Offline" />
```

### Dot Badge with Children

```tsx
import { Badge, Icon } from '@mezzanine-ui/react';
import { NotificationIcon } from '@mezzanine-ui/icons';

// Dot appears at top-right of icon
<Badge variant="dot-error">
  <Icon icon={NotificationIcon} />
</Badge>
```

### Count Badge

```tsx
// Count badge
<Badge variant="count-alert" count={5} />
<Badge variant="count-info" count={10} />
<Badge variant="count-inactive" count={0} />

// With overflow limit
<Badge variant="count-alert" count={120} overflowCount={99} />
// Displays "99+"
```

### Text Badge

```tsx
// Text variant badges (inline status indicators)
<Badge variant="text-success" text="Active" />
<Badge variant="text-error" text="Failed" />
<Badge variant="text-warning" text="Pending" />
<Badge variant="text-info" text="Processing" />
<Badge variant="text-inactive" text="Disabled" />

// Sub size
<Badge variant="text-success" text="Active" size="sub" />
```

### Status List

```tsx
function StatusList() {
  const statuses = [
    { name: 'System A', variant: 'dot-success' as const },
    { name: 'System B', variant: 'dot-error' as const },
    { name: 'System C', variant: 'dot-warning' as const },
  ];

  return (
    <ul>
      {statuses.map((status) => (
        <li key={status.name}>
          <Badge variant={status.variant} text={status.name} />
        </li>
      ))}
    </ul>
  );
}
```

### Notification Icon

```tsx
function NotificationBadge({ hasNotification }: { hasNotification: boolean }) {
  return (
    <Badge variant="dot-error">
      <Icon icon={NotificationIcon} size={24} />
    </Badge>
  );
}
```

---

## count = 0 Behavior

When `count` is 0, count variant badges are automatically hidden.

```tsx
// Badge will not display
<Badge variant="count-alert" count={0} />
```

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `Badge / Dot Success`        | `variant="dot-success"`                  |
| `Badge / Dot Error`          | `variant="dot-error"`                    |
| `Badge / Dot Warning`        | `variant="dot-warning"`                  |
| `Badge / Dot Info`           | `variant="dot-info"`                     |
| `Badge / Dot Inactive`       | `variant="dot-inactive"`                 |
| `Badge / Dot With Text`      | `variant="dot-*" text="..."`             |
| `Badge / Count Alert`        | `variant="count-alert"`                  |
| `Badge / Count Inactive`     | `variant="count-inactive"`               |
| `Badge / Count Inverse`      | `variant="count-inverse"`                |
| `Badge / Count Brand`        | `variant="count-brand"`                  |
| `Badge / Count Info`         | `variant="count-info"`                   |
| `Badge / Text Success`       | `variant="text-success"`                 |
| `Badge / Text Error`         | `variant="text-error"`                   |
| `Badge / Text Warning`       | `variant="text-warning"`                 |
| `Badge / Text Info`          | `variant="text-info"`                    |
| `Badge / Text Inactive`      | `variant="text-inactive"`                |

---

## Type Definitions

```ts
// Variant types exported from @mezzanine-ui/core/badge
type BadgeDotVariant =
  | 'dot-success'
  | 'dot-error'
  | 'dot-warning'
  | 'dot-info'
  | 'dot-inactive';

type BadgeCountVariant =
  | 'count-alert'
  | 'count-inactive'
  | 'count-inverse'
  | 'count-brand'
  | 'count-info';

type BadgeTextVariant =
  | 'text-success'
  | 'text-error'
  | 'text-warning'
  | 'text-info'
  | 'text-inactive';

type BadgeTextSize = 'main' | 'sub';

type BadgeVariant = BadgeDotVariant | BadgeCountVariant | BadgeTextVariant;

// BadgeVariantProps is a discriminated union
type BadgeVariantProps = BadgeCountProps | BadgeDotWithTextProps | BadgeDotProps | BadgeTextProps;

// BadgeCountProps
interface BadgeCountProps {
  variant: BadgeCountVariant;
  count: number;
  overflowCount?: number;
  children?: never;
  size?: never;
  text?: never;
}

// BadgeDotWithTextProps
interface BadgeDotWithTextProps {
  variant: BadgeDotVariant;
  text?: string;
  size?: BadgeTextSize;
  children?: never;
  count?: never;
  overflowCount?: never;
}

// BadgeDotProps (with children)
interface BadgeDotProps {
  variant: BadgeDotVariant;
  children?: ReactNode;
  size?: never;
  text?: never;
  count?: never;
  overflowCount?: never;
}

// BadgeTextProps
interface BadgeTextProps {
  variant: BadgeTextVariant;
  text: string;
  size?: BadgeTextSize;
  children?: never;
  count?: never;
  overflowCount?: never;
}
```

> `BadgeCountVariant` and `BadgeDotVariant` are defined in `@mezzanine-ui/core/badge` and must be imported from that package. `BadgeProps` is exported from `@mezzanine-ui/react`.

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 狀態指示 | `variant="dot-*"` | 視覺標記狀態（在線/離線） |
| 通知計數 | `variant="count-*"` + `count={num}` | 顯示未讀數量 |
| 內聯狀態文字 | `variant="text-*"` + `text="..."` | 文字形式的狀態 |
| 大於 99 | `overflowCount={99}` | 防止數字過長 |
| 狀態點配圖示 | `<Badge><Icon/></Badge>` | 圖示右上角顯示狀態 |
| 計數為 0 | `count={0}` | 自動隱藏（不顯示） |
| 成功 | `variant="dot-success"` 或 `count-brand` | 綠色，正面語義 |
| 警告 | `variant="dot-warning"` 或 `count-alert` | 黃色，需注意 |
| 錯誤/離線 | `variant="dot-error"` | 紅色，立即關注 |
| 次要/灰色 | `variant="dot-inactive"` | 無狀態或已禁用 |

### 常見錯誤

#### ❌ count=0 仍顯示
```tsx
// 不好：count=0 時不應顯示
<Badge variant="count-alert" count={0} />
{/* 實際上會隱藏，設計符合預期 */}
```

#### ✅ 預期行為：count=0 自動隱藏
```tsx
{/* count=0 時不顯示，這是預期的 */}
<Badge variant="count-alert" count={notifications.length} />
{/* 沒有通知時，Badge 完全隱藏 */}
```

#### ❌ 數字過大導致版面擠壓
```tsx
// 不好：9999 會很長
<Badge variant="count-alert" count={9999} />
```

#### ✅ 正確做法：設定 overflowCount
```tsx
<Badge
  variant="count-alert"
  count={notifications.length}
  overflowCount={99}  {/* 超過 99 顯示 "99+" */}
/>
```

#### ❌ 混淆點 Badge 和文字 Badge
```tsx
// 不夠清晰：當需要文字時用錯了類型
<Badge variant="dot-success">  {/* 是點，不是文字 */}
  <Icon />
</Badge>
```

#### ✅ 正確做法：區分類型
```tsx
// 點 + 圖示
<Badge variant="dot-success">
  <Icon />
</Badge>

// 點 + 文字
<Badge variant="dot-success" text="Online" />

// 純文字
<Badge variant="text-success" text="Active" />
```

#### ❌ 狀態顏色意義不一致
```tsx
// 不好：不同地方使用不同顏色表示相同狀態
// 系統 A 用綠色表示「成功」
// 系統 B 用藍色表示「成功」
```

#### ✅ 正確做法：全系統一致
```tsx
// 全系統統一：綠色 = 成功/在線
<Badge variant="dot-success" text="Online" />

// 紅色 = 錯誤/離線
<Badge variant="dot-error" text="Offline" />

// 黃色 = 警告
<Badge variant="dot-warning" text="Pending" />
```

#### ❌ Count Badge 包含不必要資訊
```tsx
// 不好：count variant 應僅顯示數字，不應有文字
<Badge variant="count-alert" count={5}>
  Notifications  {/* 多餘，只顯示數字 */}
</Badge>
```

#### ✅ 正確做法：count 只用於計數
```tsx
<Badge variant="count-alert" count={notifications.length} />

// 需要文字說明時用文字 Badge
<Badge variant="text-alert" text="5 Notifications" />
```

#### ❌ Dot Badge 位置不明確
```tsx
// 不好：點在哪裡？
<Badge variant="dot-success" />
```

#### ✅ 正確做法：點應配合內容
```tsx
// 點 + 文字，清晰表達
<Badge variant="dot-success" text="Online" />

// 點 + 圖示，醒目標記
<Badge variant="dot-error">
  <Icon icon={AlertIcon} />
</Badge>
```

#### ❌ 尺寸搭配不當
```tsx
// 不好：子尺寸的文字太小，難以閱讀
<Badge variant="text-success" text="Verified" size="sub" />
```

#### ✅ 正確做法：根據上下文選尺寸
```tsx
// 主要列表項使用 main
<Badge variant="text-success" text="Active" size="main" />

// 細小列表使用 sub
<Badge variant="text-inactive" text="Disabled" size="sub" />
```

### 核心要點

1. **count=0 自動隱藏**：計數為 0 時 Badge 不顯示，節省空間
2. **overflowCount 防溢出**：大數字用 "99+" 表示，防止版面破裂
3. **型別區分明確**：dot、count、text 各有用途，勿混用
4. **狀態色彩一致**：全系統統一顏色語義
5. **點搭配內容**：點應與圖示或文字結合，增強表意
6. **尺寸適應場景**：main 用於主要內容，sub 用於輔助資訊

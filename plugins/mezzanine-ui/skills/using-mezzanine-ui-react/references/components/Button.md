# Button Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Button`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Button) · Verified 1.4.1 (2026-07-01)

The most commonly used interactive element, supporting multiple variants and sizes.

> **Aliases** — Button · CTA · 按鈕 · Figma `Button / *`
> **Not for** — 模擬分段控制項的選中狀態（用 [`RadioGroup type="segment"`](Radio.md)，**不要**用多顆 Button 的 variant 差異）；開關（用 [`Toggle`](Toggle.md)）

## Import

```tsx
import { Button, ButtonGroup } from '@mezzanine-ui/react';
import type {
  ButtonProps,
  ButtonPropsBase,
  ButtonComponent,
  ButtonVariant,
  ButtonSize,
  ButtonGroupProps,
  ButtonGroupChild,
  ButtonGroupOrientation,
} from '@mezzanine-ui/react';

// The following types must be imported from sub-path
import type { ButtonIconType } from '@mezzanine-ui/react/Button';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/foundation-button--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Button Props

`ButtonProps<C>` is a generic type extending `ButtonPropsBase` plus the native attributes of element `C`.

| Property          | Type              | Default          | Description                                              |
| ----------------- | ----------------- | ---------------- | -------------------------------------------------------- |
| `variant`         | `ButtonVariant`   | `'base-primary'` | Button variant                                           |
| `size`            | `ButtonSize`      | `'main'`         | Button size                                              |
| `disabled`        | `boolean`         | `false`          | Whether disabled                                         |
| `loading`         | `boolean`         | `false`          | Whether to show loading state (with Spinner icon)        |
| `icon`            | `IconDefinition`  | -                | Icon                                                     |
| `iconType`        | `ButtonIconType`  | -                | Icon position                                            |
| `children`        | `ReactNode`       | -                | Button text; used as tooltip when `iconType='icon-only'` |
| `disabledTooltip` | `boolean`         | `false`          | Whether to disable icon-only button's tooltip            |
| `tooltipPosition` | `PopperPlacement` | `'bottom'`       | Tooltip position for icon-only button                    |
| `component`       | `ButtonComponent` | `'button'`       | Custom render element (`'button'`, `'a'`, or JSX component) |

---

## ButtonComponent Type

```ts
type ButtonComponent = 'button' | 'a' | JSXElementConstructor<any>;
```

---

## ButtonVariant Type

### Base

| Variant          | Description      | Use Case                  |
| ---------------- | ---------------- | ------------------------- |
| `base-primary`   | Primary button   | Main action (CTA)         |
| `base-secondary` | Secondary button | Secondary action          |
| `base-tertiary`  | Tertiary button  | Low-priority action       |
| `base-ghost`     | Ghost button     | Action on plain background |
| `base-dashed`    | Dashed button    | Add/create actions        |
| `base-text-link` | Text link        | Navigation or linking     |

### Destructive

| Variant                 | Description             | Use Case                     |
| ----------------------- | ----------------------- | ---------------------------- |
| `destructive-primary`   | Destructive primary     | Irreversible actions (delete) |
| `destructive-secondary` | Destructive secondary   | Secondary destructive action |
| `destructive-ghost`     | Destructive ghost       | Low-emphasis destructive action |
| `destructive-text-link` | Destructive text link   | Navigate to destructive action |

### Inverse

| Variant         | Description    | Use Case                    |
| --------------- | -------------- | --------------------------- |
| `inverse`       | Inverse button | Used on dark backgrounds    |
| `inverse-ghost` | Inverse ghost  | Ghost button on dark backgrounds |

---

## ButtonSize Type

```ts
type ButtonSize = GeneralSize; // 'main' | 'sub' | 'minor'
```

| Size    | Description |
| ------- | ----------- |
| `main`  | Main size   |
| `sub`   | Sub size    |
| `minor` | Minor size  |

---

## ButtonIconType Type

| IconType    | Description          |
| ----------- | -------------------- |
| `leading`   | Icon on left of text |
| `trailing`  | Icon on right of text |
| `icon-only` | Icon only            |

---

## Usage Examples

### Basic Variants

```tsx
import { Button } from '@mezzanine-ui/react';

// Primary button
<Button variant="base-primary">Primary</Button>

// Secondary button
<Button variant="base-secondary">Secondary</Button>

// Tertiary button
<Button variant="base-tertiary">Tertiary</Button>

// Ghost button
<Button variant="base-ghost">Ghost</Button>

// Dashed button
<Button variant="base-dashed">Dashed</Button>

// Text link
<Button variant="base-text-link">Text Link</Button>
```

### Destructive Actions

```tsx
<Button variant="destructive-primary">Delete</Button>
<Button variant="destructive-secondary">Cancel</Button>
<Button variant="destructive-ghost">Remove</Button>
<Button variant="destructive-text-link">Delete Link</Button>
```

### Sizes

```tsx
<Button size="main">Main Size</Button>
<Button size="sub">Sub Size</Button>
<Button size="minor">Minor Size</Button>
```

### With Icons

```tsx
import { PlusIcon, ChevronDownIcon, TrashIcon } from '@mezzanine-ui/icons';

// Leading icon
<Button icon={PlusIcon} iconType="leading">Add</Button>

// Trailing icon
<Button icon={ChevronDownIcon} iconType="trailing">Expand</Button>

// Icon only (automatically shows tooltip)
<Button icon={TrashIcon} iconType="icon-only">Delete</Button>

// Icon only (tooltip disabled)
<Button icon={TrashIcon} iconType="icon-only" disabledTooltip>Delete</Button>
```

### States

```tsx
// Disabled
<Button disabled>Disabled</Button>

// Loading
<Button loading>Loading</Button>

// Loading (with icon)
<Button loading icon={PlusIcon} iconType="leading">Adding</Button>
```

### As Link

```tsx
// Using <a> tag
<Button component="a" href="/path">Go to Link</Button>

// With Next.js Link
import Link from 'next/link';

<Button component={Link} href="/path">Go to Link</Button>
```

---

## ButtonGroup

Button group that combines multiple buttons together.

### ButtonGroup Props

`ButtonGroupProps` extends native `<div>` element attributes (excluding `key` and `ref`).

| Property      | Type                                     | Default          | Description                                        |
| ------------- | ---------------------------------------- | ---------------- | -------------------------------------------------- |
| `children`    | `ButtonGroupChild \| ButtonGroupChild[]` | **required**     | Child buttons (only `Button` elements are accepted) |
| `disabled`    | `boolean`                                | `false`          | Group default disabled state (individual buttons can override) |
| `fullWidth`   | `boolean`                                | `false`          | Whether to set width: 100%                         |
| `orientation` | `ButtonGroupOrientation`                 | `'horizontal'`   | Arrangement direction                              |
| `size`        | `ButtonSize`                             | `'main'`         | Group default button size (individual buttons can override) |
| `variant`     | `ButtonVariant`                          | `'base-primary'` | Group default button variant (individual buttons can override) |

> `ButtonGroupOrientation` is equivalent to `'horizontal' | 'vertical'`.
>
> `ButtonGroupChild` is equivalent to `ReactElement<ButtonProps> | null | undefined | false`.

### Usage Examples

```tsx
import { Button, ButtonGroup } from '@mezzanine-ui/react';

// Horizontal group
<ButtonGroup>
  <Button>Left</Button>
  <Button>Center</Button>
  <Button>Right</Button>
</ButtonGroup>

// Vertical group
<ButtonGroup orientation="vertical">
  <Button>Top</Button>
  <Button>Center</Button>
  <Button>Bottom</Button>
</ButtonGroup>
```

---

## Figma Mapping

| Figma Variant                    | React Props                                      |
| -------------------------------- | ------------------------------------------------ |
| `Size=Main, Variant=Primary`    | `<Button size="main" variant="base-primary">`    |
| `Size=Sub, Variant=Secondary`   | `<Button size="sub" variant="base-secondary">`   |
| `Variant=Destructive-Primary`   | `<Button variant="destructive-primary">`         |
| `State=Disabled`                 | `<Button disabled>`                              |
| `State=Loading`                  | `<Button loading>`                               |
| `Icon=Leading`                   | `<Button icon={Icon} iconType="leading">`        |
| `Icon=Trailing`                  | `<Button icon={Icon} iconType="trailing">`       |
| `Icon=Only`                      | `<Button icon={Icon} iconType="icon-only">`      |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 頁面主要行動 | `variant="base-primary"` | 視覺突出，引導使用者注意 |
| 次要行動 | `variant="base-secondary"` | 降低視覺優先級 |
| 低優先級行動 | `variant="base-tertiary"` 或 `base-ghost` | 最少視覺干擾 |
| 新增/建立操作 | `variant="base-dashed"` | 視覺上暗示「新增」語意 |
| 刪除/危險操作 | `variant="destructive-primary"` | 紅色警告，明確意圖 |
| 導覽/外部連結 | `component="a"` + `variant="base-text-link"` | 語意正確，保留 HTML 連結特性 |
| 僅顯示圖示 | `iconType="icon-only"` + `children="..."` | children 自動作為 tooltip |
| 載入中狀態 | `loading` | 自動封鎖重複點擊，清晰反饋 |
| 禁用狀態 | `disabled` | 防止誤觸，清楚溝通不可用 |
| Next.js 導覽 | `component={Link}` + `href="/path"` | 整合 Next.js 路由，享受預加載 |

### 常見錯誤

#### ❌ 一個頁面多個主按鈕
```tsx
<Button variant="base-primary">主要行動</Button>
<Button variant="base-primary">次要行動</Button>  {/* 混淆使用者 */}
```

#### ✅ 正確做法：只有一個主按鈕
```tsx
<Button variant="base-primary">主要行動</Button>
<Button variant="base-secondary">次要行動</Button>
```

#### ❌ 圖示按鈕無文字提示
```tsx
<Button icon={DeleteIcon} iconType="icon-only" disabledTooltip>
  {/* 使用者不知道按鈕作用 */}
</Button>
```

#### ✅ 正確做法：提供 children 作 tooltip
```tsx
<Button icon={DeleteIcon} iconType="icon-only">
  刪除  {/* 自動成為 tooltip */}
</Button>
```

#### ❌ 導覽使用 button 而非 link
```tsx
<Button onClick={() => router.push('/page')}>
  {/* 非語意，損失 HTML link 優勢 */}
</Button>
```

#### ✅ 正確做法：用 component="a" 保留語意
```tsx
<Button component="a" href="/page" variant="base-text-link">
  導覽  {/* 語意正確，可被爬蟲索引 */}
</Button>
```

#### ❌ 載入時手動禁用與提示
```tsx
<Button disabled={isLoading}>
  {isLoading ? '載入中...' : '提交'}
  {/* 重複且易錯 */}
</Button>
```

#### ✅ 正確做法：使用 loading 狀態
```tsx
<Button loading={isLoading}>
  提交  {/* 自動展示 Spinner，禁用交互 */}
</Button>
```

#### ❌ 圖示與文字搭配不當
```tsx
<Button icon={PlusIcon} iconType="trailing">
  新增  {/* icon 在文字後，與預期相反 */}
</Button>
```

#### ✅ 正確做法：選擇合理的圖示位置
```tsx
<Button icon={PlusIcon} iconType="leading">
  新增  {/* leading 較直覺 */}
</Button>

<Button icon={ChevronDownIcon} iconType="trailing">
  選項  {/* trailing 適合展開型按鈕 */}
</Button>
```

#### ❌ 忽視按鈕大小一致性
```tsx
<ButtonGroup>
  <Button size="main">大</Button>
  <Button size="minor">小</Button>  {/* 視覺不和諧 */}
</ButtonGroup>
```

#### ✅ 正確做法：group 層級統一大小
```tsx
<ButtonGroup size="sub">
  <Button>按鈕 1</Button>
  <Button>按鈕 2</Button>  {/* 統一應用 size="sub" */}
</ButtonGroup>
```

### 核心要點

1. **一個主按鈕**：每頁面最多一個 `base-primary`，避免視覺競爭
2. **語意導覽**：優先用 `component="a"` + `href` 而非 `onClick` 導航
3. **圖示搭配**：圖示僅圖示時需提供文字作 tooltip
4. **Loading 狀態**：`loading` 自動管理狀態反饋和防重複點擊
5. **層級明確**：用 variant 區分優先級，用 size 區分尺度

# Anchor Component

> **Category**: Others
>
> **Storybook**: `Others/Anchor`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Anchor) · Verified 1.5.1 (2026-09-12)

Anchor navigation component for in-page section navigation with automatic hash tracking.

## Import

```tsx
import { Anchor, AnchorGroup } from '@mezzanine-ui/react';
import type { AnchorProps, AnchorGroupProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/navigation-anchor--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

> **Note**: `AnchorItemData` type is not exported from `@mezzanine-ui/react` main entry, only used internally.

---

## Anchor Props (Data Mode)

| Property  | Type               | Description        |
| --------- | ------------------ | ------------------ |
| `anchors` | `AnchorItemData[]` | Anchor data array  |

## Anchor Props (Children Mode)

| Property       | Type                                                          | Description          |
| -------------- | ------------------------------------------------------------- | -------------------- |
| `autoScrollTo` | `boolean`                                                     | Auto-scroll on click |
| `children`     | `string \| ReactElement<AnchorPropsWithChildren, typeof Anchor> \| Array<string \| ReactElement<AnchorPropsWithChildren, typeof Anchor>>` | Child anchors or text |
| `disabled`     | `boolean`                                                     | Whether disabled     |
| `href`         | `string`                                                      | Link target          |
| `onClick`      | `() => void`                                                  | Click callback       |
| `title`        | `string`                                                      | Title attribute      |

---

## AnchorGroup Props

| Property    | Type                                                              | Description      |
| ----------- | ----------------------------------------------------------------- | ---------------- |
| `anchors`   | `AnchorItemData[]`                                                | Anchor data array |
| `children`  | `ReactElement<AnchorPropsWithChildren> \| ReactElement<...>[]`    | Anchor children  |
| `className` | `string`                                                          | Custom className |

> `anchors` and `children` are mutually exclusive; use one or the other.

---

## AnchorItemData Type

```tsx
interface AnchorItemData {
  autoScrollTo?: boolean;
  children?: AnchorItemData[];
  disabled?: boolean;
  href: string;
  id: string;
  name: string;
  onClick?: VoidFunction;
  title?: string;
}
```

---

## Usage Examples

### Using Data Mode

```tsx
import { Anchor, AnchorGroup } from '@mezzanine-ui/react';

const anchors = [
  { id: '1', name: 'Chapter 1', href: '#chapter1' },
  { id: '2', name: 'Chapter 2', href: '#chapter2' },
  { id: '3', name: 'Chapter 3', href: '#chapter3', children: [
    { id: '3-1', name: 'Chapter 3 Section 1', href: '#chapter3-1' },
    { id: '3-2', name: 'Chapter 3 Section 2', href: '#chapter3-2' },
  ]},
];

<AnchorGroup>
  <Anchor anchors={anchors} />
</AnchorGroup>
```

### Using Children Mode

```tsx
<AnchorGroup>
  <Anchor href="#chapter1">Chapter 1</Anchor>
  <Anchor href="#chapter2">Chapter 2</Anchor>
  <Anchor href="#chapter3">
    Chapter 3
    <Anchor href="#chapter3-1">Chapter 3 Section 1</Anchor>
    <Anchor href="#chapter3-2">Chapter 3 Section 2</Anchor>
  </Anchor>
</AnchorGroup>
```

### Auto Scroll

```tsx
<AnchorGroup>
  <Anchor href="#section1" autoScrollTo>Section 1</Anchor>
  <Anchor href="#section2" autoScrollTo>Section 2</Anchor>
</AnchorGroup>
```

### Disabled Item

```tsx
<AnchorGroup>
  <Anchor href="#enabled">Enabled Item</Anchor>
  <Anchor href="#disabled" disabled>Disabled Item</Anchor>
</AnchorGroup>
```

### With Click Callback

```tsx
<AnchorGroup>
  <Anchor
    href="#section1"
    onClick={() => console.log('Clicked section1')}
  >
    Section 1
  </Anchor>
</AnchorGroup>
```

---

## Nesting Levels

Anchor supports up to 3 levels of nesting, with a maximum of 3 items per level:

```
├── Level 1 (main anchor)
│   ├── Level 2 (sub anchor, max 3 items)
│   │   └── Level 3 (grandchild anchor, max 3 items)
```

Structures beyond 3 levels are ignored. Sub-anchors exceeding 3 per level are silently truncated.

---

## Figma Mapping

| Figma Variant               | React Props                    |
| --------------------------- | ------------------------------ |
| `Anchor / Default`          | Default                        |
| `Anchor / Active`           | Matches current hash           |
| `Anchor / Disabled`         | `disabled`                     |
| `Anchor / Nested`           | Nested structure with children |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 定義錨點資料 | `<Anchor anchors={[...]} />` | 資料驅動，易於動態生成 |
| 手寫結構 | `<Anchor><Anchor href="#...">Item</Anchor></Anchor>` | 直覺，視覺清晰 |
| 自動卷動 | `autoScrollTo={true}` | 使用者點擊時平滑導航 |
| 長文檔導覽 | 搭配 AnchorGroup | 多層級結構清楚 |
| 禁用特定項 | `disabled={true}` | 灰顯不可用選項 |
| 最多 3 層嵌套 | 頂層 + 二層 + 三層 | 超過會被忽略 |

### 常見錯誤

#### ❌ 缺少唯一 id/href
```tsx
// 錯誤：無法正確追蹤和連結
<Anchor>
  <Anchor>Item without href</Anchor>
</Anchor>
```

#### ✅ 正確做法：每個錨點都有唯一 href
```tsx
<Anchor href="#section-1">Section 1</Anchor>
<Anchor href="#section-2">Section 2</Anchor>
```

#### ❌ 過度巢狀超過 3 層
```tsx
// 錯誤：4 層以上被忽視
<Anchor href="#l1">
  L1
  <Anchor href="#l2">
    L2
    <Anchor href="#l3">
      L3
      <Anchor href="#l4">
        L4 (忽視)
      </Anchor>
    </Anchor>
  </Anchor>
</Anchor>
```

#### ✅ 正確做法：控制在 3 層內
```tsx
<Anchor href="#main">
  Main
  <Anchor href="#sub">
    Sub
    <Anchor href="#detail">
      Detail
    </Anchor>
  </Anchor>
</Anchor>
```

#### ❌ 父級禁用未預期子級也禁用
```tsx
// 錯誤期望：只禁用父級
<Anchor disabled>
  Parent (disabled)
  <Anchor href="#child">
    Child (also disabled!)  {/* 子級也會被禁用 */}
  </Anchor>
</Anchor>
```

#### ✅ 正確做法：理解級聯禁用
```tsx
// 如果只想禁用一個項，直接在該項設定
<Anchor href="#enabled">Enabled</Anchor>
<Anchor href="#disabled" disabled>Disabled</Anchor>

// 如果父級禁用，子級自動禁用
<Anchor disabled>
  Parent & Children all disabled
</Anchor>
```

#### ❌ 未設定 autoScrollTo
```tsx
// 不夠好：點擊錨點未自動卷動
<Anchor href="#section">Section</Anchor>
```

#### ✅ 正確做法：長文檔啟用自動卷動
```tsx
<Anchor href="#section" autoScrollTo>
  Section
</Anchor>
```

### 核心要點

1. **href 必需**：每個錨點都需要唯一 href 或 id
2. **3 層限制**：超過 3 層嵌套會被忽視，設計時要注意
3. **級聯禁用**：父級禁用會自動禁用所有子級
4. **自動卷動**：長頁面應啟用 `autoScrollTo`
5. **Hash 追蹤**：組件自動同步 URL hash，支援瀏覽器返回鍵

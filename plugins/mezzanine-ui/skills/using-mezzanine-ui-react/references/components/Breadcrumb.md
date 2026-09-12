# Breadcrumb Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Breadcrumb`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Breadcrumb) · Verified 1.5.1 (2026-09-12)

Breadcrumb component for displaying hierarchical page navigation paths.

## Import

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';
import type { BreadcrumbProps, BreadcrumbItemProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/navigation-breadcrumb--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

> **Note**: `BreadcrumbItem` component is not exported from `@mezzanine-ui/react` main entry. Use `items` array or children mode with the `BreadcrumbItemProps` type.

---

## Type Definitions

```ts
type BreadcrumbItemComponent = 'a' | 'span' | JSXElementConstructor<any>;

type BreadcrumbProps = Omit<NativeElementPropsWithoutKeyAndRef<'nav'>, 'children'> & (
  | { condensed?: boolean; items: BreadcrumbItemProps[]; children?: never }
  | { condensed?: boolean; items?: never; children: ReactElement<BreadcrumbItemProps> | ReactElement<BreadcrumbItemProps>[] }
);

type BreadcrumbItemProps<C extends BreadcrumbItemComponent = 'span'> =
  | ComponentOverridableForwardRefComponentPropsFactory<...>  // Text or link
  | BreadcrumbDropdownProps;                                   // Dropdown
```

---

## Breadcrumb Props

| Property    | Type                                                        | Default | Description                               |
| ----------- | ----------------------------------------------------------- | ------- | ----------------------------------------- |
| `condensed` | `boolean`                                                   | -       | Condensed mode, shows only last two items |
| `items`     | `BreadcrumbItemProps[]`                                     | -       | Items array (mutually exclusive with children) |
| `children`  | `ReactElement<BreadcrumbItemProps> \| ReactElement<...>[]`  | -       | BreadcrumbItem elements                   |
| `className` | `string`                                                    | -       | Custom CSS class                          |

> Extends `nav` element native attributes (excluding `children`).

---

## BreadcrumbItem Props

### Text Item (BreadcrumbItemTextProps)

| Property    | Type       | Default  | Description                   |
| ----------- | ---------- | -------- | ----------------------------- |
| `component` | `'span'`   | `'span'` | Renders as text               |
| `name`      | `string`   | required | Item name                     |
| `current`   | `boolean`  | -        | Whether current page          |
| `id`        | `string`   | -        | Unique identifier             |
| `href`      | `never`    | -        | Not available for text items  |
| `onClick`   | `never`    | -        | Not available for text items  |
| `target`    | `never`    | -        | Not available for text items  |

### Link Item (BreadcrumbLinkItemProps)

| Property    | Type                                                  | Default  | Description        |
| ----------- | ----------------------------------------------------- | -------- | ------------------ |
| `component` | `'a'`                                                 | -        | Renders as link    |
| `name`      | `string`                                              | required | Item name          |
| `href`      | `string`                                              | required | Link URL           |
| `target`    | `'_blank' \| '_parent' \| '_self' \| '_top' \| string` | -      | Link target        |
| `current`   | `boolean`                                             | -        | Whether current page |
| `id`        | `string`                                              | -        | Unique identifier  |
| `onClick`   | `() => void`                                          | -        | Click event        |

> Extends `a` element native attributes (excluding `children`), such as `rel`.

### Dropdown Item (BreadcrumbDropdownProps)

| Property    | Type             | Default  | Description              |
| ----------- | ---------------- | -------- | ------------------------ |
| `name`      | `string`         | required | Item name                |
| `className` | `string`         | -        | Custom CSS class         |
| `current`   | `boolean`        | -        | Whether current page     |
| `id`        | `string`         | -        | Unique identifier        |
| `options`   | `DropdownOption[]` | -      | Dropdown options (inherited from DropdownProps, required) |
| `open`      | `boolean`        | -        | Whether dropdown is open |
| `onClick`   | `() => void`     | -        | Click event              |

> Extends `DropdownProps` (excluding `children` and `onScroll`), inheriting props such as `options`, `onSelect`, `type`, `menuMaxHeight`, etc. `href` and `target` are `never`.

---

## Usage Examples

### Using items Array

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';

const items = [
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Details', href: '/products/123' },
];

<Breadcrumb items={items} />
```

### Using children

> **Note**: `BreadcrumbItem` is not exported from the main entry. Prefer using the `items` array mode.

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';

// Recommended: use items array
<Breadcrumb items={[
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Details' },
]} />
```

### Condensed Mode

When items exceed 4, middle items are automatically collapsed. Enabling `condensed` shows only the last two items.

```tsx
const items = [
  { name: 'Home', href: '/' },
  { name: 'Category', href: '/category' },
  { name: 'Sub Category', href: '/category/sub' },
  { name: 'Products', href: '/products' },
  { name: 'Details' },
];

// Auto collapse
<Breadcrumb items={items} />

// Condensed mode: shows only last two items + ellipsis menu
<Breadcrumb items={items} condensed />
```

### With Click Events

```tsx
const items = [
  {
    name: 'Home',
    href: '/',
    onClick: () => console.log('Go home'),
  },
  {
    name: 'Product List',
    href: '/products',
    onClick: () => console.log('Go products'),
  },
  { name: 'Details' },
];

<Breadcrumb items={items} />
```

### Open in New Window

```tsx
const items = [
  { name: 'Home', href: '/', target: '_blank' },
  { name: 'Products' },
];

<Breadcrumb items={items} />
```

---

## Auto Collapse Rules

- **4 items or fewer**: All displayed
- **More than 4 items**: First 2 + ellipsis menu + last 2
- **Condensed mode**: Ellipsis menu + last 2

---

## Figma Mapping

| Figma Variant                 | React Props              |
| ----------------------------- | ------------------------ |
| `Breadcrumb / Default`        | Basic configuration      |
| `Breadcrumb / Condensed`      | `condensed`              |
| `Breadcrumb / With Overflow`  | Auto collapse with 4+ items |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 4 項或以下 | `items={items}` | 全部顯示，清楚導航 |
| 5 項以上 | `items={items}` | 自動摺疊：首 2 + 菜單 + 末 2 |
| 深層級（6+） | `condensed={true}` | 僅顯示菜單 + 末 2 項 |
| 包含首頁 | 第一項指向 '/' | 標準做法 |
| 當前頁無 href | 最後項無 `href` | 表示當前頁，不可點 |
| 動態生成 | 配合路由狀態 | React Router 支援 |
| 項目有 onClick | `onClick: () => {...}` | 自訂導航邏輯 |
| 新窗口開啟 | `target="_blank"` | 外部連結 |

### 常見錯誤

#### ❌ 最後一項有 href
```tsx
// 不好：當前頁應無連結
const items = [
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Details', href: '/products/123' },  {/* 當前頁有 href */}
];
```

#### ✅ 正確做法：當前頁無 href
```tsx
const items = [
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Details' },  {/* 當前頁，無 href */}
];
```

#### ❌ 項目名稱不清
```tsx
// 不好：導航層級不明
const items = [
  { name: 'Page 1' },
  { name: 'Page 2' },
  { name: 'Page 3' },
];
```

#### ✅ 正確做法：清晰的層級命名
```tsx
const items = [
  { name: 'Home', href: '/' },
  { name: 'Products', href: '/products' },
  { name: 'Electronics', href: '/products/electronics' },
  { name: 'Laptops', href: '/products/electronics/laptops' },
  { name: 'Details' },
];
```

#### ❌ 不使用 condensed 導致冗長
```tsx
// 不好：8 層導航全顯示，占用空間
<Breadcrumb
  items={deepItemsArray}  {/* 8 項 */}
/>
```

#### ✅ 正確做法：深層級用 condensed
```tsx
<Breadcrumb
  items={deepItemsArray}
  condensed  {/* 8 項會顯示為：菜單 + 末 2 項 */}
/>
```

#### ❌ 自訂導航邏輯未使用 onClick
```tsx
// 不夠靈活：需要使用路由
<Breadcrumb
  items={items.map(item => ({
    ...item,
    href: generateHref(item),  {/* 但無法攔截 onClick */}
  }))}
/>
```

#### ✅ 正確做法：用 onClick 完全控制
```tsx
<Breadcrumb
  items={items.map(item => ({
    name: item.name,
    onClick: () => {
      // 自訂邏輯：路由、分析、驗證等
      router.push(item.path);
      trackEvent('breadcrumb-click', item.name);
    },
  }))}
/>
```

#### ❌ 忽視自動摺疊邏輯
```tsx
// 不知道摺疊規則，導致意外驚喜
const items = [
  { name: 'A', href: '#a' },
  { name: 'B', href: '#b' },
  { name: 'C', href: '#c' },
  { name: 'D', href: '#d' },
  { name: 'E', href: '#e' },
];

<Breadcrumb items={items} />
// 自動顯示：A, B, [菜單], D, E
```

#### ✅ 理解摺疊規則
```tsx
// ≤4 項：全顯示
<Breadcrumb items={items4} />  // A, B, C, D

// >4 項：首 2 + 菜單 + 末 2
<Breadcrumb items={items5} />  // A, B, [菜單], D, E

// condensed：菜單 + 末 2
<Breadcrumb items={items5} condensed />  // [菜單], D, E
```

#### ❌ 外部連結未設定 target
```tsx
// 不好：外部連結應在新窗口打開
const items = [
  { name: 'External', href: 'https://example.com' },
];
```

#### ✅ 正確做法：外部連結用 target="_blank"
```tsx
const items = [
  { name: 'External', href: 'https://example.com', target: '_blank' },
];
```

#### ❌ 使用不當的 component
```tsx
// 錯誤的用法：Breadcrumb 是高階，Item 不直接導出
import { Breadcrumb, BreadcrumbItem } from '@mezzanine-ui/react';
{/* BreadcrumbItem 不導出 */}
```

#### ✅ 正確做法：使用 items 陣列
```tsx
// items 陣列模式是推薦方式
<Breadcrumb
  items={[
    { name: 'Home', href: '/' },
    { name: 'Products' },
  ]}
/>
```

### 核心要點

1. **當前頁無 href**：最後一項不應有連結
2. **清晰命名**：項目名稱應明確表達層級
3. **自動摺疊**：5+ 項自動摺疊，≤4 項全顯示
4. **condensed 深層級**：超過 6 層時考慮啟用
5. **自訂邏輯用 onClick**：需要特殊行為時使用
6. **外部連結 target="_blank"**：提高用戶體驗

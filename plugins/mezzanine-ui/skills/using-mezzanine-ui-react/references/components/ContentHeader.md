# ContentHeader Component

> ⚠️ **DEPRECATED in 1.4.1** — This component is no longer exported from `@mezzanine-ui/react`.
> Import via sub-path `@mezzanine-ui/react/ContentHeader` when needed with Section or PageHeader (still required internally).

> **⚠️ Important Caveat**: Although removed from main exports, ContentHeader **remains internally required** by [`Section`](Section.md) (via `contentHeader` prop) and [`PageHeader`](PageHeader.md) (as a required child). Both components enforce this via runtime type validation. Until a replacement API is introduced, continue using ContentHeader via sub-path import when composing pages with Section or PageHeader. Do not use ContentHeader standalone in new code.

> **Category**: Internal (removed in 1.4.1)
>
> **Storybook**: `Internal/ContentHeader` (removed in 1.4.1)
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/ContentHeader) · **Deprecated** in 1.4.1 (2026-07-01)

Content header component for displaying title, description, filters, and action buttons.

## Import

```tsx
// ContentHeader is not exported from the main entry; import from sub-path
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import type { ContentHeaderProps } from '@mezzanine-ui/react/ContentHeader';
```

---

## ContentHeader Props

| Property         | Type                                      | Default    | Description                     |
| ---------------- | ----------------------------------------- | ---------- | ------------------------------- |
| `actions`        | `ButtonProps[]`                           | -          | Action button configuration     |
| `children`       | `ContentHeaderChild[]`                    | -          | Child elements                  |
| `description`    | `string`                                  | -          | Description text                |
| `filter`         | `FilterProps`                             | -          | Filter component configuration  |
| `onBackClick`    | `() => void`                              | -          | Back button click (only available when `size='main'`; `never` when `size='sub'`) |
| `size`           | `'main' \| 'sub'`                         | `'main'`   | Size                            |
| `title`          | `string`                                  | **required** | Title text                    |
| `titleComponent` | `'h1' \| 'h2' \| 'h3' \| 'h4' \| 'h5' \| 'h6' \| 'p'` | by size | Title HTML element    |
| `utilities`      | `(ButtonProps \| DropdownProps)[]`        | -          | Utility button configuration    |

---

## Children Validation (重要 — 過濾並警告)

ContentHeader 會在 runtime 透過 `isValidElement` 檢查每個子元素的 `type` 與 props，**只渲染白名單內的元件**，其他子元件 **不會出現在畫面上**，並在 console 印出 warning。常見「ContentHeader 寫了但右側按鈕區空白」的根因都是 children 不合法。

### 接受的 children 種類

| 類別 | 規則 | 例外/限制 |
| --- | --- | --- |
| 返回鈕 | `type === 'a'` 或 props 含 `href`（如 `<a>`、`<Link>`） | 也可改用 `onBackClick` prop（互斥） |
| Filter 元件 | `Input variant="search"` / `Select` / `Toggle` / `Checkbox` | `SegmentedControl` 寫在型別但目前**未實作**，使用會被丟棄並 warning |
| Action 按鈕 | `Button` | `variant` 必須是 `base-primary` / `base-secondary` / `destructive-secondary` 或 `undefined`；其他 variant 不渲染 |
| Utility 按鈕 | `Button` 且 `iconType="icon-only"` | 一般文字按鈕不算 utility |
| Overflow 下拉 | `Dropdown`，且其 trigger 必須是 icon-only `Button` | 非 icon-only Button trigger 會 warning + 丟棄 |
| 響應式版型 | 內部 `ContentHeaderResponsive`（一般使用不會直接寫） | - |

### 會被丟棄並警告的常見錯誤

```tsx
// ❌ 自訂 wrapper：div / Fragment 內外都不被認得
<ContentHeader title="X">
  <div className={styles.actions}>
    <Button>Save</Button>
  </div>
</ContentHeader>

// ❌ 純文字 / Typography
<ContentHeader title="X">
  <Typography>說明</Typography>   {/* warning + drop，請改用 description prop */}
  <Button>Save</Button>
</ContentHeader>

// ❌ 不合法的 Button variant
<ContentHeader title="X">
  <Button variant="text">Cancel</Button>           {/* drop */}
  <Button variant="destructive-primary">Delete</Button>  {/* drop（只允許 destructive-secondary）*/}
  <Button>Save</Button>
</ContentHeader>

// ❌ Dropdown trigger 不是 icon-only Button
<ContentHeader title="X">
  <Dropdown options={[...]}>
    <Button>Menu</Button>           {/* warning + drop */}
  </Dropdown>
</ContentHeader>

// ✅ 正確：合法 variant + icon-only trigger
<ContentHeader title="X">
  <Button variant="base-secondary">Cancel</Button>
  <Button>Save</Button>
  <Dropdown options={[...]}>
    <Button icon={DotHorizontalIcon} iconType="icon-only" />
  </Dropdown>
</ContentHeader>
```

### Button variant 排序

合法 Button 會自動依 variant 排序：
1. `destructive-secondary` → 最左
2. `base-secondary` → 中間
3. `base-primary` / undefined → 最右

> 不要嘗試以 `<div style={{ order }}>` 或 Fragment 控制順序 — 包裝層會被過濾掉，按鈕反而會被丟棄。

---

## filter Props

```tsx
type FilterProps = {
  variant: 'search' | 'select' | 'segmentedControl' | 'toggle' | 'checkbox';
} & (SearchInputProps | SelectProps | SegmentedControlProps | ToggleProps | CheckboxProps);
```

---

## Usage Examples

### Basic Usage

```tsx
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { Button } from '@mezzanine-ui/react';

<ContentHeader title="Product List">
  <Button variant="base-secondary">Export</Button>
  <Button>Add Product</Button>
</ContentHeader>
```

### With Description

```tsx
<ContentHeader
  title="Account Settings"
  description="Manage your account information and preferences"
>
  <Button>Save Changes</Button>
</ContentHeader>
```

### With Back Button

```tsx
<ContentHeader
  title="Edit Product"
  onBackClick={() => router.back()}
>
  <Button variant="base-secondary">Cancel</Button>
  <Button>Save</Button>
</ContentHeader>
```

### With Filter Component (using props)

```tsx
<ContentHeader
  title="Order Management"
  filter={{
    variant: 'search',
    placeholder: 'Search orders...',
    onChange: handleSearch,
  }}
  actions={[
    { children: 'Export', variant: 'base-secondary', onClick: handleExport },
    { children: 'Add Order', onClick: handleAdd },
  ]}
/>
```

### With Filter Component (using children)

```tsx
<ContentHeader title="User Management">
  <Input variant="search" placeholder="Search users..." onChange={handleSearch} />
  <Button variant="base-secondary">Export</Button>
  <Button>Add User</Button>
</ContentHeader>
```

### With Utility Buttons

```tsx
import { PlusIcon, FilterIcon, DotHorizontalIcon } from '@mezzanine-ui/icons';

<ContentHeader
  title="Reports"
  utilities={[
    { icon: PlusIcon, onClick: handleAdd },
    { icon: FilterIcon, onClick: handleFilter },
  ]}
>
  <Button>Generate Report</Button>
</ContentHeader>
```

### With Overflow Menu

```tsx
<ContentHeader title="Settings">
  <Dropdown
    options={[
      { id: 'export', name: 'Export' },
      { id: 'import', name: 'Import' },
      { id: 'reset', name: 'Reset' },
    ]}
    onSelect={handleMenuSelect}
  >
    <Button icon={DotHorizontalIcon} iconType="icon-only" />
  </Dropdown>
  <Button>Save</Button>
</ContentHeader>
```

### Using Link as Back Button

```tsx
import Link from 'next/link';

<ContentHeader title="Product Details">
  <Link href="/products" title="back" />
  <Button>Edit</Button>
</ContentHeader>
```

### Sub Size

```tsx
<ContentHeader
  size="sub"
  title="Sub-section Title"
  description="Sub-section description text"
>
  <Button size="sub">Action</Button>
</ContentHeader>
```

---

## Component Structure

```
┌──────────────────────────────────────────────────────────────┐
│ ContentHeader                                                │
│ ┌──────────────────────┬───────────────────────────────────┐ │
│ │ Title Area           │ Action Area                       │ │
│ │ [←] Title            │ [Search] [Secondary] [Primary] [Util] [⋮] │ │
│ │     Description      │                                   │ │
│ └──────────────────────┴───────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

---

## Button Auto-Sorting

Buttons in children are automatically sorted by variant:
1. `destructive-secondary` -> sorted to the leftmost
2. `base-secondary` -> sorted in the middle
3. `base-primary` (default) -> sorted to the rightmost

Buttons without a specified variant (i.e., `variant` is `undefined`) are also rendered, treated as `base-primary` for sorting. Only buttons with `destructive-secondary`, `base-secondary`, and `base-primary` (including `undefined`) variants are rendered; other variants are filtered out with a console warning.

---

## Figma Mapping

| Figma Variant                      | React Props                              |
| ---------------------------------- | ---------------------------------------- |
| `ContentHeader / Main`             | `size="main"` (default)                  |
| `ContentHeader / Sub`              | `size="sub"`                             |
| `ContentHeader / With Back`        | `onBackClick` or children has href element |
| `ContentHeader / With Description` | `description` has value                  |
| `ContentHeader / With Filter`      | `filter` or children has SearchInput/Select |
| `ContentHeader / With Actions`     | `actions` or children has Button         |
| `ContentHeader / With Utilities`   | `utilities` or children has icon-only Button |

---

## Best Practices

1. **title is required**: ContentHeader must have a title
2. **Flexible usage**: Can be configured via props or children
3. **Props take priority**: When both are set, props take priority over children
4. **Size matching**: Button sizes should match the ContentHeader size
5. **Semantic**: Renders as a `<header>` element

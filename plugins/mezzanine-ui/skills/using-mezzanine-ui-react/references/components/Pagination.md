# Pagination Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Pagination`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Pagination) · Verified 1.5.1 (2026-09-12)

Pagination component for paginated navigation of long data lists.

## Import

```tsx
import {
  Pagination,
  PaginationItem,
  PaginationJumper,
  PaginationPageSize,
  usePagination,
} from '@mezzanine-ui/react';
import type {
  PaginationProps,
  PaginationItemProps,
  PaginationItemType,
  PaginationJumperProps,
  PaginationPageSizeProps,
} from '@mezzanine-ui/react';
```

> `PaginationItemType` is actually re-exported from `@mezzanine-ui/core/pagination`.

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/navigation-pagination--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Pagination Props

Extends `DetailedHTMLProps<HTMLAttributes<HTMLElement>, HTMLElement>` (excluding `onChange`).

| Property                   | Type                                          | Default                                 | Description                       |
| -------------------------- | --------------------------------------------- | --------------------------------------- | --------------------------------- |
| `boundaryCount`            | `number`                                      | `1`                                     | Pages always shown at start/end   |
| `buttonText`               | `string`                                      | -                                       | Jumper button text                |
| `current`                  | `number`                                      | `1`                                     | Current page number               |
| `disabled`                 | `true`                                        | -                                       | Whether disabled (literal type)   |
| `hintText`                 | `string`                                      | -                                       | Hint text before jumper input     |
| `inputPlaceholder`         | `string`                                      | -                                       | Jumper input placeholder          |
| `itemRender`               | `(item: PaginationItemProps) => ReactNode`    | `(item) => <PaginationItem {...item}>` | Custom page item render           |
| `onChange`                 | `(page: number) => void`                      | -                                       | Page change event                 |
| `onChangePageSize`         | `PaginationPageSizeProps['onChange']`          | -                                       | Page size change event            |
| `pageSize`                 | `PaginationPageSizeProps['value']`             | `10`                                    | Items per page                    |
| `pageSizeLabel`            | `PaginationPageSizeProps['label']`             | -                                       | Page size label                   |
| `pageSizeOptions`          | `PaginationPageSizeProps['options']`           | -                                       | Page size options                 |
| `renderResultSummary`      | `(from: number, to: number, total: number) => string` | -                              | Custom result summary renderer    |
| `renderPageSizeOptionName` | `PaginationPageSizeProps['renderOptionName']`  | -                                       | Custom page size option name renderer |
| `showJumper`               | `boolean`                                     | `false`                                 | Show page jumper input            |
| `showPageSizeOptions`      | `boolean`                                     | `false`                                 | Show page size selector           |
| `siblingCount`             | `number`                                      | `1`                                     | Pages shown on each side of current |
| `total`                    | `number`                                      | `0`                                     | Total number of items             |

---

## PaginationItemProps

Extends HTML attributes (excluding `ref`).

| Property   | Type                 | Default  | Description            |
| ---------- | -------------------- | -------- | ---------------------- |
| `active`   | `boolean`            | `false`  | Whether current page   |
| `disabled` | `boolean`            | `false`  | Whether disabled       |
| `page`     | `number`             | `1`      | Page number            |
| `type`     | `PaginationItemType` | `'page'` | Item type              |

### PaginationItemType

```tsx
type PaginationItemType = 'page' | 'ellipsis' | 'previous' | 'next' | string;
```

---

## PaginationJumperProps

Extends `DetailedHTMLProps<HTMLAttributes<HTMLDivElement>, HTMLDivElement>` (excluding `onChange`).

| Property           | Type                      | Default | Description                  |
| ------------------ | ------------------------- | ------- | ---------------------------- |
| `buttonText`       | `string`                  | -       | Button text                  |
| `disabled`         | `true`                    | -       | Whether disabled             |
| `hintText`         | `string`                  | -       | Hint text before input       |
| `inputPlaceholder` | `string`                  | -       | Input placeholder            |
| `onChange`         | `(page: number) => void`  | -       | Page change callback         |
| `pageSize`         | `number`                  | `5`     | Items per page (defaults to 5 when standalone; controlled by Pagination's pageSize when inside Pagination, default 10) |
| `total`            | `number`                  | `0`     | Total number of items        |

---

## PaginationPageSizeProps

Extends HTML div attributes.

| Property           | Type                          | Default                       | Description            |
| ------------------ | ----------------------------- | ----------------------------- | ---------------------- |
| `disabled`         | `boolean`                     | `false`                       | Whether disabled       |
| `label`            | `string`                      | -                             | Label text             |
| `onChange`         | `(pageSize: number) => void`  | -                             | Page size change callback |
| `options`          | `number[]`                    | `[10, 20, 50, 100]`          | Size options           |
| `renderOptionName` | `(pageSize: number) => string`| `` (p) => `${p}` ``         | Custom option name     |
| `value`            | `number`                      | -                             | Current size value     |

---

## usePagination Hook

```tsx
const { items } = usePagination(options);
```

### UsePaginationParams

| Property             | Type                      | Default | Description                |
| -------------------- | ------------------------- | ------- | -------------------------- |
| `boundaryCount`      | `number`                  | `1`     | Pages shown at start/end   |
| `current`            | `number`                  | `1`     | Current page               |
| `disabled`           | `boolean`                 | `false` | Whether all disabled       |
| `hideFirstButton`    | `boolean`                 | -       | Hide first page button     |
| `hideLastButton`     | `boolean`                 | -       | Hide last page button      |
| `hideNextButton`     | `boolean`                 | -       | Hide next page button      |
| `hidePreviousButton` | `boolean`                 | -       | Hide previous page button  |
| `onChange`           | `(page: number) => void`  | -       | Page change callback       |
| `pageSize`           | `number`                  | `10`    | Items per page             |
| `siblingCount`       | `number`                  | `1`     | Pages before/after current |
| `total`              | `number`                  | `0`     | Total number of items      |

### Return Value

| Property | Type                    | Description                           |
| -------- | ----------------------- | ------------------------------------- |
| `items`  | `PaginationItemProps[]` | Pagination item array with events and state |

Each item contains: `active`, `page`, `type`, `disabled`, `onClick`, `aria-current`, `aria-disabled`, `aria-label`.

---

## Usage Examples

### Basic Usage

```tsx
import { Pagination } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicPagination() {
  const [current, setCurrent] = useState(1);

  return (
    <Pagination
      current={current}
      total={100}
      onChange={setCurrent}
    />
  );
}
```

### With Page Size Selector

```tsx
function PaginationWithPageSize() {
  const [current, setCurrent] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  return (
    <Pagination
      current={current}
      pageSize={pageSize}
      onChange={setCurrent}
      pageSizeOptions={[10, 20, 50, 100]}
      pageSizeLabel="Items per page"
      onChangePageSize={setPageSize}
    />
  );
}
```

### With Boundary and Sibling Count

```tsx
function PaginationWithBoundary() {
  const [current, setCurrent] = useState(1);

  return (
    <Pagination
      current={current}
      onChange={setCurrent}
      boundaryCount={2}
    />
  );
}
```

### Basic Usage

```tsx
function BasicPagination() {
  const [current, setCurrent] = useState(1);

  return (
    <Pagination
      current={current}
      onChange={setCurrent}
      pageSize={10}
    />
  );
}
```

### Disabled State

```tsx
<Pagination
  current={1}
  total={100}
  disabled
/>
```

### Using usePagination Hook

```tsx
import { usePagination, PaginationItem } from '@mezzanine-ui/react';

function CustomPagination() {
  const [current, setCurrent] = useState(1);
  const { items } = usePagination({
    current,
    total: 200,
    pageSize: 10,
    onChange: setCurrent,
  });

  return (
    <nav>
      {items.map((item, index) => (
        <PaginationItem key={index} {...item} />
      ))}
    </nav>
  );
}
```

---

## Figma Mapping

| Figma Variant                 | React Props                |
| ----------------------------- | -------------------------- |
| `Pagination / Basic`          | `current`, `onChange`      |
| `Pagination / With Page Size` | `pageSize`, `pageSizeOptions` |
| `Pagination / Disabled`       | `disabled`                 |

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關 Props |
| --- | --- | --- |
| 小型資料集 (<100) | 基本配置，無需額外功能 | `current`, `onChange`, `pageSize` |
| 中等資料集 (100-1000) | 添加頁大小選項 | `pageSizeOptions`, `onChangePageSize` |
| 大型資料集 (>1000) | 多層分頁與控制 | `pageSize`, `pageSizeOptions` |
| 表格資料分頁 | 配合表格顯示 | `pageSize`, `pageSizeOptions` |
| 搜尋結果分頁 | 動態更新頁大小選項 | `onChangePageSize` |
| 無限滾動替代 | 使用分頁而非無限滾動 | - |
| 自訂分頁結構 | 使用 `usePagination` hook | `usePagination` |

### 常見錯誤 (Common Mistakes)

1. **受控模式混亂**
   - ❌ 誤：提供 `current` 但不提供 `onChange`，或反之
   - ✅ 正確：同時提供 `current` 和 `onChange`
   - 範例：`<Pagination current={page} onChange={setPage} />`

2. **pageSize 值不合理**
   - ❌ 誤：提供 `pageSizeOptions={[1, 500, 1000]}`
   - ✅ 正確：提供合理漸進式選項，如 `[10, 20, 50]`
   - 影響：優化用戶體驗，避免過度加載或過少顯示

3. **缺少 pageSize 配置**
   - ❌ 誤：不設定 `pageSize`
   - ✅ 正確：根據內容設定合理的 `pageSize` 值
   - 範例：`<Pagination pageSize={20} />`

4. **boundaryCount 設定不當**
   - ❌ 誤：使用過大的 `boundaryCount` 導致頁碼擁擠
   - ✅ 正確：`boundaryCount={1}` 或 `{2}` 即可
   - 影響：保持分頁導航的清晰易讀

### 核心建議 (Core Recommendations)

1. **提供總數**：`total` 是分頁計算的必要條件
2. **受控模式**：使用 `current` 和 `onChange` 實現受控行為
3. **大資料集顯示跳轉**：資料量大時啟用 `showJumper`
4. **清晰摘要**：使用 `renderResultSummary` 提供明確信息
5. **合理分頁大小**：根據資料類型提供適當的頁大小選項

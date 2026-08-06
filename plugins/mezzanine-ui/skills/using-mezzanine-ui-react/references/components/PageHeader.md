# PageHeader Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/PageHeader`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/PageHeader) · Verified 1.4.1 (2026-07-01)

Page header component for displaying page-level navigation and titles. Contains breadcrumb and content header.

## Import

```tsx
import { PageHeader } from '@mezzanine-ui/react';
import type { PageHeaderProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/navigation-pageheader--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Type Definitions

```ts
type PageHeaderChild =
  | ReactElement<BreadcrumbProps>
  | ReactElement<ContentHeaderProps>
  | null | undefined | false;

type PageHeaderProps = NativeElementPropsWithoutKeyAndRef<'header'> & {
  children?: PageHeaderChild | PageHeaderChild[];
};
```

---

## PageHeader Props

> Extends `NativeElementPropsWithoutKeyAndRef<'header'>`.

| Property   | Type                                  | Default | Description                                  |
| ---------- | ------------------------------------- | ------- | -------------------------------------------- |
| `children` | `PageHeaderChild \| PageHeaderChild[]`| -       | Breadcrumb and/or ContentHeader sub-components |

---

## Children Validation (重要 — 過濾並警告)

PageHeader 在 runtime 透過 `flattenChildren` + `isValidElement` + `child.type === Breadcrumb || child.type === ContentHeader` 檢查每個直接子元素。**任何不在白名單內的元件都會被丟棄並 console.warn**：

```
[Mezzanine][PageHeader] only accepts Breadcrumb or ContentHeader as its children.
```

### 接受的 children

| 元件 | 數量 | 備註 |
| --- | --- | --- |
| `Breadcrumb` | 0 或 1 | 多個 → warning（`only accepts one Breadcrumb as its child.`）+ **後者覆蓋前者**（實際保留的是最後一個，而非第一個） |
| `ContentHeader` | 必為 1 | 缺少 → **console.error**（`requires a ContentHeader as its child.`，非 warning）；多個 → warning + 後者覆蓋前者；`size` 強制改寫為 `'main'`，手動指定會觸發 warning 且無效 |

### 常見錯誤

```tsx
// ❌ 自訂 div / Typography 包住 ContentHeader
<PageHeader>
  <div className={styles.head}>
    <ContentHeader title="X" />
  </div>
</PageHeader>

// ❌ 多個 Breadcrumb
<PageHeader>
  <Breadcrumb items={a} />
  <Breadcrumb items={b} />   {/* warning，且 items={a} 會被覆蓋丟棄，最終只顯示 items={b} */}
  <ContentHeader title="X" />
</PageHeader>

// ❌ 自行嘗試插入工具列 / Tab
<PageHeader>
  <Breadcrumb items={a} />
  <ContentHeader title="X" />
  <Tab>...</Tab>             {/* warning + drop — Tab 應放在 Section */}
</PageHeader>

// ✅ 正確
<PageHeader>
  <Breadcrumb items={a} />
  <ContentHeader title="X">
    <Button>Save</Button>
  </ContentHeader>
</PageHeader>
```

> **Note**: `ContentHeader` is not exported from the `@mezzanine-ui/react` main entry; it must be imported from the sub-path `@mezzanine-ui/react/ContentHeader`.
>
> **ContentHeader status**: Marked deprecated in 1.0.0 because it is no longer exported from the main entry. It **remains required** by PageHeader — a PageHeader must contain exactly one ContentHeader child, enforced by the type `PageHeaderChild = ReactElement<BreadcrumbProps> | ReactElement<ContentHeaderProps>`. Import via sub-path and use as shown in the examples below. See [ContentHeader.md](ContentHeader.md) for the full API.

---

## Usage Examples

### Basic Usage

```tsx
import { PageHeader, Breadcrumb, Button } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Product Management', href: '/products' },
      { name: 'Add Product' },
    ]}
  />
  <ContentHeader
    title="Add Product"
    description="Fill in the information below to add a product"
  >
    <Button variant="base-secondary">Cancel</Button>
    <Button>Save</Button>
  </ContentHeader>
</PageHeader>
```

### With Back Button

```tsx
<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Settings' },
    ]}
  />
  <ContentHeader
    title="Account Settings"
    onBackClick={() => router.back()}
  >
    <Button>Save Changes</Button>
  </ContentHeader>
</PageHeader>
```

### Without Breadcrumb

```tsx
<PageHeader>
  <ContentHeader
    title="Dashboard"
    description="Welcome back"
  >
    <Button>Add Report</Button>
  </ContentHeader>
</PageHeader>
```

### With Search and Filter

```tsx
<PageHeader>
  <Breadcrumb
    items={[
      { name: 'Home', href: '/' },
      { name: 'Order Management' },
    ]}
  />
  <ContentHeader
    title="Order List"
    filter={{
      variant: 'search',
      placeholder: 'Search orders...',
      onChange: handleSearch,
    }}
  >
    <Button variant="base-secondary">Export</Button>
    <Button>Add Order</Button>
  </ContentHeader>
</PageHeader>
```

---

## Component Structure

```
+------------------------------------------------------+
| PageHeader                                            |
| +--------------------------------------------------+ |
| | Breadcrumb                                        | |
| | Home > Product Management > Add Product           | |
| +--------------------------------------------------+ |
| +--------------------------------------------------+ |
| | ContentHeader                                     | |
| | [Back] Add Product    [Search] [Secondary] [Primary]| |
| |        Fill in the information...                 | |
| +--------------------------------------------------+ |
+------------------------------------------------------+
```

---

## Figma Mapping

| Figma Variant                     | React Props                              |
| --------------------------------- | ---------------------------------------- |
| `PageHeader / With Breadcrumb`    | Includes Breadcrumb                      |
| `PageHeader / Without Breadcrumb` | Does not include Breadcrumb              |
| `PageHeader / With Back`          | ContentHeader has `onBackClick`          |
| `PageHeader / With Actions`       | ContentHeader has children (buttons)     |

---

## Best Practices (最佳實踐)

### 容器與內容對齊 (Container & Body Alignment) — 重要

`PageHeader` 內建水平/垂直 padding（CSS：`padding: spacious spacious 0`，水平對應 `--mzn-spacing-padding-horizontal-spacious`，預設 16px / compact 14px）。**這個 padding 從 React props 上看不到**，因此頁面骨架要遵循：

1. **外層 container 不可加水平 padding** — `PageHeader` 必須能貼齊版面邊緣。在外層加 `padding` / `padding-inline` 會造成 PageHeader 雙重內縮。
2. **下方主要內容需用 wrapper 套上相同水平 padding** — 通常是 `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`，讓表格 / 卡片 / 表單的左緣對齊 PageHeader 的標題文字。
3. **`PageFooter` 與 `PageHeader` 同層** — `PageFooter` 也自帶 padding（`8px / 16px`）與 `border-top`，必須滿版，不可放進上述 body wrapper 內。
4. **垂直間距用 container 的 `row-gap`** — `PageHeader` 的 `padding-bottom` 是 `0`（刻意留給 container 分配），建議 `row-gap: var(--mzn-spacing-gap-calm)`；不要補 `margin-bottom`。

```tsx
// ✅ 正確
<div className={styles.page}>             {/* 無水平 padding，row-gap 分隔區塊 */}
  <PageHeader>...</PageHeader>            {/* 自己貼邊 */}
  <main className={styles.body}>          {/* 套水平 padding 對齊 */}
    <Table ... />
  </main>
  <PageFooter ... />                      {/* 同層貼邊，border-top 滿版 */}
</div>
```

```scss
.page {
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
}

.body {
  padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
  padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
}
```

詳見 [PATTERNS.md → Page Body Alignment with PageHeader](../PATTERNS.md#page-body-alignment-with-pageheader-重要--容易忽略)。

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關元件 |
| --- | --- | --- |
| 多層級導航 | 包含 `Breadcrumb` 顯示當前位置 | `Breadcrumb` |
| 簡單頁面 | 僅使用 `ContentHeader` 無需面包屑 | `ContentHeader` |
| 返回功能 | 在 `ContentHeader` 設定 `onBackClick` | `onBackClick` |
| 搜尋和篩選 | 使用 `ContentHeader` 的 `filter` 屬性 | `filter` |
| 頁面操作按鈕 | 在 `ContentHeader` children 放置操作按鈕 | `children` |
| 描述信息 | 使用 `ContentHeader` 的 `description` 屬性 | `description` |
| 響應式設計 | 在小螢幕上隱藏冗餘元素 | Media queries |

### 常見錯誤 (Common Mistakes)

1. **缺少 ContentHeader**
   - ❌ 誤：`<PageHeader><Breadcrumb ... /></PageHeader>` 只有面包屑
   - ✅ 正確：必須包含 `ContentHeader`，面包屑是可選的
   - 範例：至少要有 `<ContentHeader title="..." />`

2. **多層 Breadcrumb**
   - ❌ 誤：包含多個 `Breadcrumb` 組件
   - ✅ 正確：最多只能有一個 `Breadcrumb`
   - 影響：多個會導致重複或覆蓋

3. **自訂 ContentHeader size**
   - ❌ 誤：手動設定 `<ContentHeader size="sub" />`
   - ✅ 正確：不設定 `size`，自動為 `main`
   - 影響：確保一致的視覺層級

4. **未結構化導航**
   - ❌ 誤：深層導航不使用面包屑
   - ✅ 正確：超過 2 層導航結構建議使用面包屑
   - 範例：`Home > Products > Category > Item` 需面包屑

5. **按鈕位置混亂**
   - ❌ 誤：操作按鈕放在 `Breadcrumb` 下方
   - ✅ 正確：操作按鈕放在 `ContentHeader` children
   - 範例：`<ContentHeader><Button /></ContentHeader>`

6. **外層 container 加水平 padding 導致 PageHeader 雙重內縮**
   - ❌ 誤：`<div style={{ padding: 24 }}><PageHeader />...</div>` → PageHeader 比版面少 24px + 內建 16px
   - ✅ 正確：外層 container 不加水平 padding，下方內容用 wrapper 套 `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)` 對齊
   - 影響：標題文字與下方表格 / 表單左緣會錯開，視覺破裂

### 核心建議 (Core Recommendations)

1. **必須包含 ContentHeader**：PageHeader 必須包含一個 `ContentHeader`
2. **面包屑可選**：面包屑可選，但導航層級多時推薦使用
3. **大小自動設定**：`ContentHeader` 的大小自動設為 main
4. **語義化**：正確使用 `<header>` 標籤提升可訪問性
5. **響應式考量**：考慮在小螢幕上隱藏某些元素

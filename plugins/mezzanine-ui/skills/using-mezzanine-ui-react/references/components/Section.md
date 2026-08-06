# Section Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Section`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Section) · Verified 1.4.1 (2026-07-01)
>
> **Migration Note**: Module resolution fix changed barrel file extension from `.tsx` → `.ts`. No API changes.

Section container component for composing `ContentHeader`, `FilterArea`, `Tab`, and other sub-components to build structured page sections. The passed `contentHeader` and `filterArea` automatically receive `size="sub"`.

> **ContentHeader note**: `ContentHeader` is removed in 1.4.1 (deprecated since 1.1.0) because it is no longer exported from the `@mezzanine-ui/react` main entry. However, it **remains internally required** by Section's `contentHeader` prop — runtime validation rejects any other component type. Import `ContentHeader` via the sub-path `@mezzanine-ui/react/ContentHeader` and continue using it as shown in the examples below. See [ContentHeader.md](ContentHeader.md) for details.

## Import

```tsx
import { Section, SectionGroup } from '@mezzanine-ui/react';
import type { SectionProps, SectionGroupProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-section--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Props

The component uses `forwardRef<HTMLDivElement, PropsWithChildren<SectionProps>>`, so it also accepts `children` and a standard div ref.

> **Important**: `SectionProps` does **not** extend native `<div>`/HTML attributes. Only `className`, `contentHeader`, `filterArea`, `tab`, and `children` are accepted — the component destructures exactly these props (no `...rest` spread onto the root `<div>`). Props such as `style`, `id`, or `data-*` are **not** supported and will not reach the DOM.

| Property        | Type                               | Default | Description                                                          |
| --------------- | ---------------------------------- | ------- | -------------------------------------------------------------------- |
| `className`     | `string`                           | -       | Additional CSS class                                                 |
| `contentHeader` | `ReactElement<ContentHeaderProps>` | -       | Accepts `<ContentHeader />` component; other components trigger a console warning |
| `filterArea`    | `ReactElement<FilterAreaProps>`    | -       | Accepts `<FilterArea />` component; other components trigger a console warning    |
| `tab`           | `ReactElement<TabProps>`           | -       | Accepts `<Tab />` component; other components trigger a console warning           |
| `children`      | `ReactNode`                        | -       | Section body content, rendered after contentHeader, filterArea, and tab           |

> Section automatically injects `size="sub"` prop into the passed `contentHeader` and `filterArea`, ensuring correct sizing in sub-sections.

---

## SectionGroup Props

SectionGroup is a layout container component that groups multiple `Section` components with a configurable direction.

> Extends `HTMLAttributes<HTMLDivElement>` — unlike `Section`, `SectionGroup` spreads remaining props (`style`, `id`, `data-*`, event handlers, etc.) onto its root `<div>`.

| Property    | Type                           | Default      | Description                                                    |
| ----------- | ------------------------------ | ------------ | -------------------------------------------------------------- |
| `className` | `string`                       | -            | Additional CSS class                                           |
| `direction` | `'horizontal' \| 'vertical'`   | `'vertical'` | Layout direction for grouped sections                          |
| `children`  | `ReactNode`                    | -            | Child elements, typically multiple `Section` components        |

---

## Render Order

The internal render order within Section is fixed as follows:

1. `contentHeader` (ContentHeader component)
2. `filterArea` (FilterArea component)
3. `tab` (Tab component)
4. `children` (body content)

---

## Usage Examples

### Basic Section

```tsx
import { Section } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function BasicSection() {
  return (
    <Section
      contentHeader={<ContentHeader title="Order List" />}
    >
      <p>Order content area</p>
    </Section>
  );
}
```

### With FilterArea

```tsx
import { Section, FilterArea } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function SectionWithFilter() {
  return (
    <Section
      contentHeader={<ContentHeader title="Product Management" />}
      filterArea={
        <FilterArea>
          {/* Filter criteria content */}
        </FilterArea>
      }
    >
      <div>Product list</div>
    </Section>
  );
}
```

### With Tab Pagination

```tsx
import { Section, Tab, TabItem } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { Key, useState } from 'react';

function SectionWithTabs() {
  const [activeTab, setActiveTab] = useState<Key>('all');

  return (
    <Section
      contentHeader={<ContentHeader title="Member Management" />}
      tab={
        <Tab activeKey={activeTab} onChange={(key) => setActiveTab(key)}>
          <TabItem key="all">All</TabItem>
          <TabItem key="active">Active</TabItem>
          <TabItem key="inactive">Inactive</TabItem>
        </Tab>
      }
    >
      <div>
        {activeTab === 'all' && <p>All members</p>}
        {activeTab === 'active' && <p>Active members</p>}
        {activeTab === 'inactive' && <p>Inactive members</p>}
      </div>
    </Section>
  );
}
```

### Full Composition

```tsx
import { Section, FilterArea, Tab, TabItem } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function FullSection() {
  return (
    <Section
      contentHeader={
        <ContentHeader
          title="Report Overview"
          actions={[{ children: 'Export', variant: 'base-secondary' }]}
        />
      }
      filterArea={
        <FilterArea>
          {/* Date range, status filters, etc. */}
        </FilterArea>
      }
      tab={
        <Tab activeKey="daily">
          <TabItem key="daily">Daily</TabItem>
          <TabItem key="weekly">Weekly</TabItem>
          <TabItem key="monthly">Monthly</TabItem>
        </Tab>
      }
    >
      <div>Report data area</div>
    </Section>
  );
}
```

### SectionGroup - Vertical Layout (Default)

```tsx
import { Section, SectionGroup } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function VerticalSectionGroup() {
  return (
    <SectionGroup direction="vertical">
      <Section
        contentHeader={<ContentHeader title="Sales Analytics" />}
      >
        <div>Sales data visualization</div>
      </Section>
      <Section
        contentHeader={<ContentHeader title="Revenue Trends" />}
      >
        <div>Revenue charts and metrics</div>
      </Section>
      <Section
        contentHeader={<ContentHeader title="Regional Performance" />}
      >
        <div>Regional breakdown</div>
      </Section>
    </SectionGroup>
  );
}
```

### SectionGroup - Horizontal Layout

```tsx
import { Section, SectionGroup } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function HorizontalSectionGroup() {
  return (
    <SectionGroup direction="horizontal">
      <Section
        contentHeader={<ContentHeader title="Active Users" />}
      >
        <div>User count: 1,250</div>
      </Section>
      <Section
        contentHeader={<ContentHeader title="Total Revenue" />}
      >
        <div>Revenue: $45,000</div>
      </Section>
      <Section
        contentHeader={<ContentHeader title="Conversion Rate" />}
      >
        <div>Rate: 12.5%</div>
      </Section>
    </SectionGroup>
  );
}
```

### SectionGroup with Custom Styling

```tsx
import { Section, SectionGroup } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

function StyledSectionGroup() {
  return (
    <SectionGroup
      direction="horizontal"
      className="section-group-custom"
      style={{ gap: '24px' }}
    >
      <Section
        contentHeader={<ContentHeader title="Section 1" />}
        className="section-custom"
      >
        <div>Content 1</div>
      </Section>
      <Section
        contentHeader={<ContentHeader title="Section 2" />}
        className="section-custom"
      >
        <div>Content 2</div>
      </Section>
    </SectionGroup>
  );
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-section--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Type Validation

Section validates the types of passed sub-components at runtime:

- `contentHeader` only accepts `<ContentHeader />` component
- `filterArea` only accepts `<FilterArea />` component
- `tab` only accepts `<Tab />` component

Passing non-matching components will output a console warning, e.g.:

```
[Section] Invalid contentHeader type: <MyCustomHeader>. Only <ContentHeader /> component from @mezzanine-ui/react is allowed.
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-section--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| 內容區配備標題和操作 | 使用 `contentHeader` 搭配 `children` | ContentHeader 提供標題、搜尋、操作按鈕等，Section 自動調整尺寸 |
| 多條件篩選 | 使用 `filterArea` 放置過濾控制項 | FilterArea 佔據專用區域，隔離篩選邏輯，內容獨立更新 |
| 分頁籤式檢視 | 使用 `tab` 切換不同資料集合 | Tab 改變時 children 內容更新，Section 保持結構穩定 |
| 完整的列表頁面 | 組合 contentHeader、filterArea、tab、children | 按順序組合可建立標準的資料管理頁面 |
| 需要最小高度保持版面穩定 | 使用 CSS custom property `--section-content-min-height` | 避免內容少時頁面塌陷 |
| 垂直排列多個 Section | 使用 `SectionGroup` 搭配 `direction="vertical"` | 統一管理多個 Section 的間距和佈局 |
| 水平排列多個統計卡 | 使用 `SectionGroup` 搭配 `direction="horizontal"` | 並排顯示 KPI 或統計數據，充分利用寬度 |

### 常見錯誤

- **傳入非指定元件到 contentHeader/filterArea/tab**：Section 會在控制台警告並可能行為異常。應傳入正確的 Mezzanine 元件
- **嘗試在 contentHeader 中手動設置 `size="main"`**：Section 會自動覆寫為 `size="sub"`，手動設置無效
- **在 filterArea 內放置非篩選相關內容**：FilterArea 語義上應該只包含篩選條件，其他內容應放在 children
- **期望 tab 改變時 contentHeader 也更新**：ContentHeader 位置固定在頂部，改變 tab 不會影響它。若需聯動，應在 children 處理
- **嵌套多層 Section**：雖然技術上可行但會導致複雜的嵌套層級。應扁平化結構或改用其他容器
- **在 SectionGroup 中混合不同的 direction**：SectionGroup 只支援單一 direction。若需複雜佈局，應嵌套多個 SectionGroup

## Best Practices

> **版面 padding 契約**：`Section` 自帶 `padding: vertical-spacious horizontal-spacious`（預設 16px、compact 12/14px）、圓角與卡片底色，但**沒有 margin**。
>
> - **外側**：`Section` 必須放在套了 `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)` 的 main content wrapper 內；直接掛在無水平 padding 的 page container 下會**貼齊版面邊緣**，且無法與 `PageHeader` 標題文字對齊。
> - **內側**：卡片內距由元件自己提供，**不要**再對 `Section` 或它的直接子元素補 padding。
>
> 對齊結果：卡片左緣 = `PageHeader` 標題文字左緣（16px），卡片內容再內縮 16px。詳見 [PATTERNS.md → Page Body Alignment with PageHeader](../PATTERNS.md#page-body-alignment-with-pageheader-重要--容易忽略)。

1. **Use designated components**: `contentHeader`, `filterArea`, `tab` only accept their corresponding Mezzanine components; do not pass custom components.
2. **Automatic size adjustment**: Section automatically sets `contentHeader` and `filterArea` to `size="sub"`; no manual specification needed.
3. **Structural consistency**: Use the Section composition pattern consistently across pages to ensure uniform layout and spacing.
4. **Body content in children**: Place tables, lists, and other main data content in `children`; let Section manage the block layout.
5. **Consistent height**: Use `minHeight` on the content area when you need consistent section heights across a page.
6. **SectionGroup for multiple sections**: Use `SectionGroup` to manage layout of multiple `Section` components; set `direction="vertical"` for stacked layouts or `direction="horizontal"` for side-by-side layouts.
7. **Responsive layouts**: Consider using CSS media queries with `SectionGroup direction` for responsive behavior (e.g., horizontal on desktop, vertical on mobile).

# Description Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Description`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Description) · Verified 1.4.1 (2026-07-01)

Description component for displaying structured information in title-content pairs.

## Import

```tsx
import {
  Description,
  DescriptionContent,
  DescriptionTitle,
  DescriptionGroup,
} from '@mezzanine-ui/react';
import type {
  DescriptionProps,
  DescriptionContentProps,
  DescriptionTitleProps,
  DescriptionGroupProps,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-description-description--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Description Props

Extends `DistributiveOmit<DescriptionTitleProps, 'className' | 'children'>`, so it also accepts `badge`, `icon`, `tooltip`, `tooltipPlacement`, `widthType`, etc.

| Property      | Type                           | Default        | Description                              |
| ------------- | ------------------------------ | -------------- | ---------------------------------------- |
| `children`    | `ReactElement`                 | -              | Content element (see supported types below) |
| `className`   | `string`                       | -              | Custom class name                        |
| `orientation` | `DescriptionOrientation`       | `'horizontal'` | Layout direction                         |
| `size`        | `DescriptionSize`              | `'main'`       | Default size for child content           |
| `title`       | `string`                       | -              | Required, title text                     |

---

### Size Propagation

The `size` prop on `Description` sets the default size for its child `DescriptionContent`. A child's own `size` prop takes precedence over the parent's `size`.

```tsx
// All children default to 'sub' size
<Description title="Name" size="sub">
  <DescriptionContent>John Doe</DescriptionContent>
</Description>

// Child overrides parent size
<Description title="Name" size="sub">
  <DescriptionContent size="main">John Doe</DescriptionContent>
</Description>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-description-description--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Supported children Types

Description's children can be one of the following components:

- `DescriptionContent` (text content)
- `Badge` (badge)
- `Button` (button)
- `Progress` (progress bar)
- `TagGroup` (tag group)

---

## DescriptionTitle Props

`DescriptionTitleProps` uses a discriminated union type; whether `icon` is required depends on whether `tooltip` is provided.

### Base Props (DescriptionTitleBaseProps)

| Property      | Type                    | Default     | Description                    |
| ------------- | ----------------------- | ----------- | ------------------------------ |
| `badge`       | `BadgeDotVariant`       | -           | Dot badge next to the title    |
| `children`    | `string`                | -           | Required, title text           |
| `className`   | `string`                | -           | Custom class name              |
| `size`        | `DescriptionSize`       | `'main'`    | Title text size                |
| `widthType`   | `DescriptionWidthType`  | `'stretch'` | Title width behavior           |

### With Tooltip (DescriptionTitleWithTooltip)

| Property           | Type             | Default | Description                            |
| ------------------ | ---------------- | ------- | -------------------------------------- |
| `icon`             | `IconDefinition` | -       | Required, icon after the title         |
| `tooltip`          | `string`         | -       | Required, tooltip shown on icon hover  |
| `tooltipPlacement` | `Placement`      | `'top'` | Tooltip position                       |

### Without Tooltip (DescriptionTitleWithoutTooltip)

| Property           | Type              | Default | Description                     |
| ------------------ | ----------------- | ------- | ------------------------------- |
| `icon`             | `IconDefinition`  | -       | Optional, icon after the title  |
| `tooltip`          | `undefined`       | -       | Do not set tooltip              |
| `tooltipPlacement` | `undefined`       | -       | Do not set placement            |

> When `tooltip` is provided, `icon` is required.

---

## DescriptionContent Props

`DescriptionContentProps` uses a discriminated union type; whether `icon` and `onClickIcon` are accepted depends on `variant`.

### Base Props (DescriptionContentBaseProps)

| Property      | Type                                                        | Default    | Description                                        |
| ------------- | ----------------------------------------------------------- | ---------- | -------------------------------------------------- |
| `children`    | `string`                                                    | -          | Required, content text                             |
| `className`   | `string`                                                    | -          | Custom class name                                  |
| `size`        | `DescriptionSize`                                           | `'main'`   | Text size (`'main' \| 'sub'`)                      |
| `variant`     | `'normal' \| 'statistic' \| 'trend-up' \| 'trend-down'`    | `'normal'` | Content style                                      |
| `icon`        | `never`                                                     | -          | Not available (only for `'with-icon'` variant)     |
| `onClickIcon` | `never`                                                     | -          | Not available (only for `'with-icon'` variant)     |

### With Clickable Icon (DescriptionContentWithClickableIcon)

| Property      | Type             | Default | Description                     |
| ------------- | ---------------- | ------- | ------------------------------- |
| `children`    | `string`         | -       | Required, content text          |
| `className`   | `string`         | -       | Custom class name               |
| `size`        | `DescriptionSize`| -       | Text size (`'main' \| 'sub'`)   |
| `variant`     | `'with-icon'`    | -       | Required, enables icon mode     |
| `icon`        | `IconDefinition` | -       | Required, icon after content    |
| `onClickIcon` | `VoidFunction`   | -       | Icon click event                |

---

## DescriptionGroup Props

| Property    | Type             | Default | Description                        |
| ----------- | ---------------- | ------- | ---------------------------------- |
| `children`  | `ReactElement[]` | -       | Required, Description child elements |
| `className` | `string`         | -       | Custom class name                  |

---

## Type Definitions

```ts
// Title width behavior
type DescriptionWidthType = 'narrow' | 'wide' | 'stretch' | 'hug';

// Content size
type DescriptionSize = 'main' | 'sub';

// Layout direction (inherited from Orientation)
type DescriptionOrientation = 'horizontal' | 'vertical';

// Content style variant (full enumeration, some are for internal use)
type DescriptionContentVariant =
  | 'badge'
  | 'button'
  | 'normal'
  | 'progress'
  | 'statistic'
  | 'tags'
  | 'trend-up'
  | 'trend-down'
  | 'with-icon';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-description-description--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Basic Usage

```tsx
import { Description, DescriptionContent } from '@mezzanine-ui/react';

<Description title="Name">
  <DescriptionContent>John Doe</DescriptionContent>
</Description>
```

### Vertical Layout

```tsx
<Description title="Address" orientation="vertical">
  <DescriptionContent>
    123 Main Street, Suite 456, New York, NY 10001
  </DescriptionContent>
</Description>
```

### With Badge

```tsx
import { Description, Badge } from '@mezzanine-ui/react';

<Description title="Status">
  <Badge variant="dot-success" text="Online" />
</Description>
```

### With Button

```tsx
import { Description, Button } from '@mezzanine-ui/react';

<Description title="Action">
  <Button variant="text" onClick={handleClick}>
    Edit
  </Button>
</Description>
```

### With Progress

```tsx
import { Description, Progress } from '@mezzanine-ui/react';

<Description title="Progress">
  <Progress percent={75} type="percent" />
</Description>
```

### With TagGroup

```tsx
import { Description, Tag, TagGroup } from '@mezzanine-ui/react';

<Description title="Tags">
  <TagGroup>
    <Tag label="React" />
    <Tag label="TypeScript" />
    <Tag label="Node.js" />
  </TagGroup>
</Description>
```

### With Badge Title

```tsx
<Description title="Status" badge="dot-success">
  <DescriptionContent>Running</DescriptionContent>
</Description>
```

### With Tooltip Title

```tsx
import { InfoIcon } from '@mezzanine-ui/icons';

<Description title="Field Name" icon={InfoIcon} tooltip="This is the field description text">
  <DescriptionContent>Content</DescriptionContent>
</Description>
```

### Using DescriptionGroup

```tsx
import { DescriptionGroup, Description, DescriptionContent } from '@mezzanine-ui/react';

<DescriptionGroup>
  <Description title="Name">
    <DescriptionContent>John Doe</DescriptionContent>
  </Description>
  <Description title="Position">
    <DescriptionContent>Engineer</DescriptionContent>
  </Description>
</DescriptionGroup>
```

### DescriptionContent Variants

```tsx
// Statistic number
<DescriptionContent variant="statistic" size="main">
  1,234
</DescriptionContent>

// Trend up
<DescriptionContent variant="trend-up">
  +12.5%
</DescriptionContent>

// Trend down
<DescriptionContent variant="trend-down">
  -3.2%
</DescriptionContent>

// With icon
<DescriptionContent variant="with-icon" icon={EditIcon} onClickIcon={handleEdit}>
  Editable content
</DescriptionContent>
```

### Information List

```tsx
function UserInfo({ user }) {
  return (
    <div className="info-list">
      <Description title="Name">
        <DescriptionContent>{user.name}</DescriptionContent>
      </Description>
      <Description title="Email">
        <DescriptionContent>{user.email}</DescriptionContent>
      </Description>
      <Description title="Phone">
        <DescriptionContent>{user.phone}</DescriptionContent>
      </Description>
      <Description title="Status">
        <Badge variant="dot-success" text="Active" />
      </Description>
    </div>
  );
}
```

### Detail Page

```tsx
function OrderDetail({ order }) {
  return (
    <div className="order-detail">
      <Description title="Order ID">
        <DescriptionContent>{order.id}</DescriptionContent>
      </Description>
      <Description title="Created Date">
        <DescriptionContent>{order.createdAt}</DescriptionContent>
      </Description>
      <Description title="Order Status">
        <Badge variant="dot-warning" text="Processing" />
      </Description>
      <Description title="Processing Progress">
        <Progress percent={order.progress} type="percent" />
      </Description>
      <Description title="Action">
        <Button variant="contained" onClick={handleViewDetail}>
          View Details
        </Button>
      </Description>
    </div>
  );
}
```

### Mixed Layout

```tsx
<div className="description-grid">
  <Description title="Title One">
    <DescriptionContent>Content One</DescriptionContent>
  </Description>
  <Description title="Title Two">
    <DescriptionContent>Content Two</DescriptionContent>
  </Description>
  <Description title="Detailed Description" orientation="vertical">
    <DescriptionContent>
      This is a longer description text, using vertical layout to give the content more space to display.
    </DescriptionContent>
  </Description>
</div>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-description-description--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `Description / Horizontal`       | `orientation="horizontal"`               |
| `Description / Vertical`         | `orientation="vertical"`                 |
| `Description / With Content`     | children is DescriptionContent           |
| `Description / With Badge`       | children is Badge                        |
| `Description / With Button`      | children is Button                       |
| `Description / With Progress`    | children is Progress                     |
| `Description / With Tags`        | children is TagGroup                     |

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 用戶資訊卡 | `orientation="horizontal"`, `size="main"` | 橫向佈局，用於簡潔資訊展示 |
| 訂單詳情頁 | `orientation="vertical"`, 混合內容類型 | 縱向佈局可容納更多內容 |
| 狀態指示 | children 為 Badge | 搭配 Badge 顯示狀態 |
| 進度追蹤 | children 為 Progress | 顯示處理進度或完成度 |
| 標籤展示 | children 為 TagGroup | 展示標籤或分類 |
| 操作按鈕 | children 為 Button | 提供快速操作入口 |

### 常見錯誤

1. **混淆方向導致佈局混亂**
   ```tsx
   // ❌ 錯誤：方向不一致
   <Description title="Name" orientation="horizontal">
     <DescriptionContent>John</DescriptionContent>
   </Description>
   <Description title="Biography" orientation="horizontal">
     <DescriptionContent>Long text content...</DescriptionContent>
   </Description>

   // ✅ 正確：根據內容長度選擇方向
   <Description title="Name" orientation="horizontal">
     <DescriptionContent>John</DescriptionContent>
   </Description>
   <Description title="Biography" orientation="vertical">
     <DescriptionContent>Long text content...</DescriptionContent>
   </Description>
   ```

2. **使用不支援的子元件類型**
   ```tsx
   // ❌ 錯誤：使用了不支援的元件
   <Description title="Info">
     <div>Custom content</div>
   </Description>

   // ✅ 正確：使用支援的元件
   <Description title="Info">
     <DescriptionContent>Custom content</DescriptionContent>
   </Description>
   ```

3. **尺寸不匹配導致視覺失衡**
   ```tsx
   // ❌ 錯誤：父層 size 與子層不同步
   <Description title="Large" size="main">
     <DescriptionContent size="sub">Content</DescriptionContent>
   </Description>

   // ✅ 正確：讓子層繼承父層 size（除非需要覆蓋）
   <Description title="Large" size="main">
     <DescriptionContent>Content</DescriptionContent>
   </Description>
   ```

4. **標題過長導致視覺不美觀**
   ```tsx
   // ❌ 錯誤：標題過長
   <Description title="This is a very long title that explains everything in detail">
     <DescriptionContent>Content</DescriptionContent>
   </Description>

   // ✅ 正確：簡潔標題，詳細說明用 tooltip
   <Description title="Description" icon={InfoIcon} tooltip="This is a very long title that explains everything in detail">
     <DescriptionContent>Content</DescriptionContent>
   </Description>
   ```

### 核心原則

1. **保持標題簡潔**: 標題應短小清晰
2. **適當內容**: 根據內容類型選擇合適的子元件
3. **佈局一致**: 保持同一區域內方向的一致性
4. **間距控制**: 多個 Descriptions 之間使用適當的間距
5. **響應式設計**: 在小屏幕上考慮使用縱向佈局
6. **內容對齐**: 多行 Description 應採用相同尺寸以保持對齐
